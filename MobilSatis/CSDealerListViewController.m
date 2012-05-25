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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}






-(void)getDealersFromSap{
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
    [super playAnimationOnView:self.view];
    
    return YES;
}

-(void)getResponseWithString:(NSString *)myResponse{
    //NSLog(@"%@",myResponse);
    [super      stopAnimationOnView];
     NSMutableArray *dealerTableAsArray= [ABHXMLHelper getValuesWithTag:@"ZMOB_DEALER" fromEnvelope:myResponse];
     NSMutableArray *customerTableAsArray= [ABHXMLHelper getValuesWithTag:@"ZMOB_CUSTOMER" fromEnvelope:myResponse];
    
    NSString *dealerTable = [NSString stringWithFormat:@"%@",[dealerTableAsArray objectAtIndex:0]];
    NSString *customerTable = [NSString stringWithFormat:@"%@",[customerTableAsArray objectAtIndex:0]]; 
    [self initCustomerFromResponse:customerTable];
    [self initDealerFromResponse:dealerTable];
    [tableView reloadData];
    
}

-(void)initDealerFromResponse:(NSString*)response{
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
        [[self.user dealers] addObject:tempDealer];
    }
    
}
-(void)initCustomerFromResponse:(NSString*)response{
    self.user.customers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNames = [[NSMutableArray alloc] init];
    NSMutableArray *relationship = [[NSMutableArray alloc] init];
    NSMutableArray *dealerNames = [[NSMutableArray alloc] init];
    NSMutableArray *dealerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *roles = [[NSMutableArray alloc] init];
    CSCustomer *tempCustomer;
    CSDealer *tempDealer;
    customerNumbers = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:response];
    customerNames = [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:response];
    relationship = [ABHXMLHelper getValuesWithTag:@"VTWEG" fromEnvelope:response];
    dealerNames = [ABHXMLHelper getValuesWithTag:@"USTNM" fromEnvelope:response];
    dealerNumbers = [ABHXMLHelper getValuesWithTag:@"USTBR" fromEnvelope:response];
    roles = [ABHXMLHelper getValuesWithTag:@"PARVW" fromEnvelope:response];
    for (int sayac = 0; sayac<[customerNumbers count]; sayac++) {
        tempCustomer = [[CSCustomer alloc] init];
        tempDealer = [[CSDealer alloc] init];
        [tempCustomer setKunnr:[customerNumbers objectAtIndex:sayac ]];
        [tempCustomer setName1:[customerNames objectAtIndex:sayac ]];
        [tempCustomer setRole:[roles objectAtIndex:sayac]];
        [tempDealer setKunnr:[dealerNumbers objectAtIndex:sayac]];
        [tempDealer setName1:[dealerNames objectAtIndex:sayac]];
        [tempCustomer setDealer:tempDealer];
        [tempCustomer setRelationship:[relationship objectAtIndex:sayac ]];
        [[self.user customers] addObject:tempCustomer];
    }
    
}

- (CSCustomer*)convertDealerToCustomer:(CSDealer*)aDealer{
    CSCustomer *fakeCustomer = [[CSCustomer alloc] init];
    [fakeCustomer setKunnr:aDealer.kunnr];
    [fakeCustomer setName1:aDealer.name1];
    return fakeCustomer;
}
- (void)addFakeCustomer:(CSCustomer*)aFakeCustomer ToCustomerList:(NSMutableArray*)customerList{
    [customerList addObject:aFakeCustomer];
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
    cell.imageView.image = [UIImage imageNamed:@"pin6.png"];
    [cell setTextColor:[CSApplicationProperties getUsualTextColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super playAnimationOnView:self.view];
    NSMutableArray * selectedCustomers = [[NSMutableArray alloc] init];
    CSDealer *selectedDealer = [user.dealers objectAtIndex:[indexPath row]] ;
    for (int sayac = 0 ; sayac < [self.user.customers count]; sayac++) {
        if ([[[[user.customers objectAtIndex:sayac] dealer] kunnr] isEqualToString:[selectedDealer kunnr]]) {
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [welcomeLabel setText:[NSString stringWithFormat:@"Hosgeldiniz, %@ %@",[user name], [user surname]]];
    tableView.backgroundColor = [UIColor clearColor];
   tableView.opaque = NO;
    [tableView setSeparatorColor:[UIColor colorWithRed:0.255f green:0.246f blue:0.176f alpha:1]];
    tableView.backgroundView = nil;
    [welcomeLabel setTextColor:[CSApplicationProperties  getUsualTextColor]];

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
