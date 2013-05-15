//
//  CSDealerListViewController.m
//  CrmServis
//
//  Created by ABH on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSDealerListViewController.h"
#import "CSCustomerListViewController.h"
@implementation CSDealerListViewController
@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getDealersFromSap {
    
    NSString *tableName = [NSString stringWithFormat:@"T_DEALER"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"KUNNR"];
    [columns addObject:@"NAME1"];

    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_CUSTOMERS_FOR_SALES"];
    [sapHandler addImportWithKey:@"I_TUNAME" andValue:[self.user username]];
        [columns addObject:@"PARVW"];
        [columns addObject:@"USTBR"];
        [columns addObject:@"USTNM"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    tableName = [NSString stringWithFormat:@"T_CUST"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];

//    return YES;
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    
    if ([CoreDataHandler isInternetConnectionNotAvailable] && [CoreDataHandler isCoreDataSwitchOn]) {
        self.user.customers = [[NSMutableArray alloc] init];
        self.user.dealers = [[NSMutableArray alloc] init];
        
        NSArray *eventsArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
        CDOUser *userLogin;
        
        if ([eventsArray count] > 0)
        {
            userLogin = (CDOUser *)[eventsArray objectAtIndex:0];
        }
        
        NSArray *dealerArray = [[userLogin dealers] allObjects];
        NSArray *customerArray = [[userLogin customers] allObjects];
        
        if ([dealerArray count] > 0 && [customerArray count] > 0) {
            
            for (CDODealer *temp in dealerArray) {
                CSDealer *tempDealer = [[CSDealer alloc] init];
                
                [tempDealer setKunnr:[temp kunnr]];
                [tempDealer setName1:[temp name1]];
                
                if (tempDealer != nil) {
                    [[self.user dealers] addObject:tempDealer];
                }
            }
        
            for (CDOCustomer *temp in customerArray) {
                CSCustomer *tempCustomer = [[CSCustomer alloc] init];
            
                [tempCustomer setKunnr:[temp kunnr]];
                [tempCustomer setName1:[temp name1]];
                [tempCustomer setRelationship:[temp relationship]];
                [tempCustomer setRole:[temp role]];
                [tempCustomer setType:[temp type]];
                [tempCustomer setLocationCoordinate:[[CSMapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[[[temp location] coordinate] latitude] doubleValue], [[[[temp location] coordinate] longitude] doubleValue]) title:[[temp location] title]]];
            
                CSDealer *tempDealer = [[CSDealer alloc] init];
                [tempDealer setKunnr:[[temp dealer] kunnr]];
                [tempDealer setName1:[[temp dealer] name1]];
            
                [tempCustomer setDealer:tempDealer];
                
                if (tempCustomer != nil) {
                    [[self.user customers] addObject:tempCustomer];
                }
            }
        }
        [tableView reloadData];
    }
    else {
        NSMutableArray *dealerTableAsArray= [ABHXMLHelper getValuesWithTag:@"ZMOB_DEALER" fromEnvelope:myResponse];
        NSMutableArray *customerTableAsArray= [ABHXMLHelper getValuesWithTag:@"ZMOB_CUSTOMER" fromEnvelope:myResponse];
        NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:myResponse];
        [self checkExistingCoreDataToDelete:[itemCount count]];
        
        if ([dealerTableAsArray count] > 0) {
            NSString *dealerTable = [NSString stringWithFormat:@"%@",[dealerTableAsArray objectAtIndex:0]];
            [self initDealerFromResponse:dealerTable];
        }
        if ([customerTableAsArray count] > 0) {
            NSString *customerTable = [NSString stringWithFormat:@"%@",[customerTableAsArray objectAtIndex:0]];
            [self initCustomerFromResponse:customerTable];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startUpCompleted" object:nil userInfo:nil];
        [tableView reloadData];
    }
}

-(void)initDealerFromResponse:(NSString*)response {
    self.user.dealers = [[NSMutableArray alloc] init];
    NSMutableArray *dealerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *dealerNames = [[NSMutableArray alloc] init];
    CSDealer *tempDealer;
    dealerNumbers = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:response];
    dealerNames = [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:response];
    for (int sayac = 0; sayac<[dealerNumbers count]; sayac++) {
        tempDealer = [[CSDealer alloc] init];
        [tempDealer setKunnr:[dealerNumbers objectAtIndex:sayac ]];
        [tempDealer setName1:[dealerNames objectAtIndex:sayac ]];
        
        if (isNewDealerOrCustomerAvailable && [CoreDataHandler isCoreDataSwitchOn]) {
            [self addDealerToCoreData:tempDealer];
        }
        
        [[self.user dealers] addObject:tempDealer];
    }    
}

-(void)initCustomerFromResponse:(NSString*)response {
    self.user.customers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNames = [[NSMutableArray alloc] init];
    NSMutableArray *relationship = [[NSMutableArray alloc] init];
    NSMutableArray *dealerNames = [[NSMutableArray alloc] init];
    NSMutableArray *dealerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *roles = [[NSMutableArray alloc] init];
    NSMutableArray *kdgrp = [[NSMutableArray alloc] init];
    NSMutableArray *katr5 = [[NSMutableArray alloc] init];
    NSMutableArray *xcor = [[NSMutableArray alloc] init];
    NSMutableArray *ycor = [[NSMutableArray alloc] init];
    
    CSCustomer *tempCustomer;
    CSDealer *tempDealer;
    customerNumbers = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:response];
    customerNames = [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:response];
    relationship = [ABHXMLHelper getValuesWithTag:@"VTWEG" fromEnvelope:response];
    dealerNames = [ABHXMLHelper getValuesWithTag:@"USTNM" fromEnvelope:response];
    dealerNumbers = [ABHXMLHelper getValuesWithTag:@"USTBR" fromEnvelope:response];
    roles = [ABHXMLHelper getValuesWithTag:@"PARVW" fromEnvelope:response];
    kdgrp = [ABHXMLHelper getValuesWithTag:@"KDGRP" fromEnvelope:response];
    katr5 = [ABHXMLHelper getValuesWithTag:@"KATR5" fromEnvelope:response];
    xcor = [ABHXMLHelper getValuesWithTag:@"XCOR" fromEnvelope:response];
    ycor = [ABHXMLHelper getValuesWithTag:@"YCOR" fromEnvelope:response];
    
    for (int sayac = 0; sayac<[customerNumbers count]; sayac++) {
        tempCustomer = [[CSCustomer alloc] init];
        tempDealer = [[CSDealer alloc] init];
        [tempCustomer setKunnr:[customerNumbers objectAtIndex:sayac ]];
        [tempCustomer setName1:[customerNames objectAtIndex:sayac ]];
        [tempCustomer setRole:[roles objectAtIndex:sayac]];
        [tempDealer setKunnr:[dealerNumbers objectAtIndex:sayac]];
        [tempDealer setName1:[dealerNames objectAtIndex:sayac]];
        [tempCustomer setDealer:tempDealer];
        [tempCustomer setRelationship:[relationship objectAtIndex:sayac]];
        
        [tempCustomer setLocationCoordinate:[[CSMapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[ycor objectAtIndex:sayac] doubleValue], [[xcor objectAtIndex:sayac] doubleValue]) title:[tempCustomer name1]]];
        
        NSString *tempKdgrp = [kdgrp objectAtIndex:sayac];
        
        if ([tempKdgrp isEqualToString:@"94"] || [tempKdgrp isEqualToString:@"95"]) {
            [tempCustomer setType:@"acik"];           
        }
        else {
            [tempCustomer setType:@"kapali"];
        }
        NSString *tempKatr5 = [katr5 objectAtIndex:sayac];
        
        if ([tempKatr5 isEqualToString:@"05"]) {
            [tempCustomer setType:@"bira"];
        }
        
        if ([[tempCustomer relationship] isEqualToString:@"11"]) {
            [tempCustomer setType:@"tali_dealer"];
        }
        
        // AATAC coreData için customer kayıt
        if (isNewDealerOrCustomerAvailable && [CoreDataHandler isCoreDataSwitchOn]) {
            [self addCustomerToCoreData:tempCustomer];
        }
        
        [[self.user customers] addObject:tempCustomer];
    }
    
}

- (CSCustomer*)convertDealerToCustomer:(CSDealer*)aDealer {
    CSCustomer *fakeCustomer = [[CSCustomer alloc] init];
    [fakeCustomer setKunnr:aDealer.kunnr];
    [fakeCustomer setName1:aDealer.name1];
    [fakeCustomer setType:@"dealer"];
    return fakeCustomer;
}


- (void)addFakeCustomer:(CSCustomer*)aFakeCustomer ToCustomerList:(NSMutableArray*)customerList {
    [customerList insertObject:aFakeCustomer atIndex:0];
}

#pragma mark - Core Data methods

- (void)addDealerToCoreData:(CSDealer *)aDealer {
    
    CDODealer *dealer = (CDODealer *)[CoreDataHandler insertEntityData:@"CDODealer"];
    [dealer setName1:[aDealer name1]];
    [dealer setKunnr:[aDealer kunnr]];
    
    NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
    CDOUser *userLog;
    
    if ([arr count] > 0) {
        userLog = [arr objectAtIndex:0];
    }
    [userLog addDealersObject:dealer];
    
    [CoreDataHandler saveEntityData];
    
}

- (void)addCustomerToCoreData:(CSCustomer *)aCustomer {

    CDOCustomer *customer = (CDOCustomer *)[CoreDataHandler insertEntityData:@"CDOCustomer"];
    [customer setKunnr:[aCustomer kunnr]];
    [customer setName1:[aCustomer name1]];
    [customer setRelationship:[aCustomer relationship]];
    [customer setHasPlan:[aCustomer hasPlan]];
    [customer setType:[aCustomer type]];
    [customer setRole:[aCustomer role]];
    
    CDODealer *dealer = (CDODealer *)[CoreDataHandler insertEntityData:@"CDODealer"];
    [dealer setName1:[[aCustomer dealer] name1]];
    [dealer setKunnr:[[aCustomer dealer] kunnr]];
    
    [customer setDealer:dealer];
    
    CDOLocation *location = (CDOLocation *)[CoreDataHandler insertEntityData:@"CDOLocation"];
    [location setTitle:[[aCustomer locationCoordinate] title]];
    
    CDOCoordinate *coor = (CDOCoordinate *)[CoreDataHandler insertEntityData:@"CDOCoordinate"];
    NSNumber *lat = [[NSNumber alloc] initWithDouble:[[aCustomer locationCoordinate] coordinate].latitude];
    NSNumber *lon = [[NSNumber alloc] initWithDouble:[[aCustomer locationCoordinate] coordinate].longitude];
    [coor setLatitude:lat];
    [coor setLongitude:lon];
    
    [location setCoordinate:coor];
    
    [customer setLocation:location];

    NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
    CDOUser *userLog;
    
    if ([arr count] > 0) {
        userLog = [arr objectAtIndex:0];
    }

    [userLog addCustomersObject:customer];

    [CoreDataHandler saveEntityData];

}

- (void)checkExistingCoreDataToDelete:(int)itemCount {
    
    NSArray *dealerArray = [CoreDataHandler fetchExistingEntityData:@"CDODealer" sortingParameter:@"kunnr" objectContext:[CoreDataHandler getManagedObject]];
    
    if (itemCount <= ([dealerArray count] + 1)) {
        isNewDealerOrCustomerAvailable = NO;
        return;
    }
    
    NSArray *customerArray = [CoreDataHandler fetchExistingEntityData:@"CDOCustomer" sortingParameter:@"kunnr" objectContext:[CoreDataHandler getManagedObject]];
    NSArray *userArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
   
    for (CDODealer *temp in dealerArray) {
        [[CoreDataHandler getManagedObject] deleteObject:temp];
    }
    
    for (CDOCustomer *temp in customerArray) {
        [[CoreDataHandler getManagedObject] deleteObject:temp];
    }
    
    
    CDOUser *userLogin;
    
    if ([userArray count] > 0)
        userLogin = [userArray objectAtIndex:0];
    
    [userLogin setDealers:nil];
    [userLogin setCustomers:nil];
    
    [CoreDataHandler saveEntityData];
    
    isNewDealerOrCustomerAvailable = YES;
}

#pragma mark - Delegate mehods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [user.dealers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSDealer *tempDealer = [[CSDealer alloc] init];
    tempDealer = [self.user.dealers objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        [[cell textLabel] setText:[tempDealer  name1]];
        [[cell detailTextLabel] setText:[tempDealer kunnr]];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
    
    cell.imageView.image = [UIImage imageNamed:@"appiconlar-01.png"];
    cell.textLabel.textColor = [UIColor whiteColor];

    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super playAnimationOnView:self.view];
    NSMutableArray * selectedCustomers = [[NSMutableArray alloc] init];
    CSDealer *selectedDealer = [user.dealers objectAtIndex:[indexPath row]];
    for (int sayac = 0 ; sayac < [self.user.customers count]; sayac++) {
        CSCustomer *cust = [[user customers] objectAtIndex:sayac];
        if ([[cust type] isEqualToString:@"tali_dealer"] && [[[cust dealer] kunnr] isEqualToString:[selectedDealer kunnr]]) {
            CSDealer *dealer = [[CSDealer alloc] init];
            [dealer setKunnr:[cust kunnr]];
            [dealer setName1:[cust name1]];
            [self addFakeCustomer:[self convertDealerToCustomer:dealer] ToCustomerList:selectedCustomers];
        }
        if ([[[cust dealer] kunnr] isEqualToString:[selectedDealer kunnr]]) {
            [selectedCustomers addObject:[user.customers objectAtIndex:sayac]];
        }
    }
    [self addFakeCustomer:[self convertDealerToCustomer:selectedDealer] ToCustomerList:selectedCustomers ];
    CSCustomerListViewController *customerListViewController = [[CSCustomerListViewController alloc] initWithCustomers:selectedCustomers andUser:[self user]];
    [super stopAnimationOnView];
    [[self navigationController] pushViewController:customerListViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[[self tabBarController ]navigationItem] setTitle:@"Bayi Seçimi"];
    [[[self tabBarController] navigationItem] setRightBarButtonItem:nil animated:YES];

}

- (void) viewWillDisappear:(BOOL)animated {
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [welcomeLabel setText:[NSString stringWithFormat:@"Hosgeldiniz, %@ %@",[user name], [user surname]]];
    tableView.backgroundColor = [UIColor clearColor];
   tableView.opaque = NO;
    [tableView setSeparatorColor:[UIColor colorWithRed:0.255f green:0.246f blue:0.176f alpha:1]];
    tableView.backgroundView = nil;
    //[welcomeLabel setTextColor:[CSApplicationProperties  getUsualTextColor]];

    [self getDealersFromSap];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
