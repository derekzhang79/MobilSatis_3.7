//
//  ConfirmationListViewController.m
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSConfirmationListViewController.h"
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
#import "CSConfirmation.h"
#import "CSConfirmConfirmationViewController.h"
#import "CSCooler.h"
@implementation CSConfirmationListViewController

- (id)init{
    self = [super init];
    confirmations = [[NSMutableArray alloc] init];
    return self;
}
-(id)initWithUser:(CSUser*)myUser{
    self = [self init];
    user = myUser;  
        return self;
}
-(id)initWithUser:(CSUser*)myUser andConfirmations:(NSMutableArray*)confirmations{
    self = [self init];
    user = myUser;
    self->confirmations = confirmations;
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    return [confirmations count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //create row
    //    CNActivity *tempActivity = [activities objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    CSConfirmation *tempConfirmation = [confirmations objectAtIndex:[indexPath row]];
    [[cell detailTextLabel] setText:[tempConfirmation confirmationNumber]];
    [[cell textLabel] setText:[[tempConfirmation customer] name1]];
    [[cell textLabel] setTextColor:[UIColor colorWithRed:0.187f green:0.152f blue:0.26f alpha:1.0f]];
    //    [[cell detailTextLabel] setHighlighted:YES];
    
    [cell setBackgroundColor:[UIColor colorWithRed:0.255f green:0.246f blue:0.176f alpha:1]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
     cell.imageView.image = [UIImage imageNamed:@"teyit_kalem.png"];
    return cell;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    //return UITableViewCellAccessoryCheckmark; check isareti
//    //return UITableViewCellAccessoryDisclosureIndicator;
//}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.opaque = YES;
    myTableView.backgroundView = nil;
    [myTableView setSeparatorColor:[UIColor colorWithRed:0.255f green:0.246f blue:0.176f alpha:1]];


//    [activityIndicator setHidesWhenStopped:YES];
    [welcomeLabel setText:[NSString stringWithFormat:@"Hosgeldiniz, %@ %@",[user name], [user surname]]];
    [self refreshConfirmations];
    
    // Do any additional setup after loading the view from its nib.
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yenile" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshConfirmations)];
    [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
        [[[self tabBarController ]navigationItem] setTitle:@"Teyit Seçimi"];
    [myTableView reloadData];
}

-(IBAction)refreshConfirmations{
    if ([super isAnimationRunning]) {
        return;
    }
[super playAnimationOnView:self.view];
    //prep table
    NSString *tableName = [NSString stringWithFormat:@"ET_TEYITLER"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"CONFNUMBER"];
    [columns addObject:@"KUNNR"];
    [columns addObject:@"STATUS"];
    [columns addObject:@"RECORDDATE"];
    //CANLI 10.12.1.179 TEST SRECTS081
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_CONFIRMATIONS_OF_SALE"];

    [sapHandler setDelegate:self];
    [sapHandler addImportWithKey:@"USERNAME" andValue:[[self user] username]];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    
}
-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
    NSMutableArray *confirmationNumbers =  [ABHXMLHelper getValuesWithTag:@"CONFNUMBER" fromEnvelope:myResponse];
    NSMutableArray *customerNames =  [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:myResponse];
    if( [confirmationNumbers count] != 0 ){
        [self initConfirmationsWithNumbers:confirmationNumbers andCustomerNames:customerNames];
        [myTableView reloadData];
    }else{
        selectedConfirmation.items = [[NSMutableArray alloc] init];
        NSMutableArray *sernr = [ABHXMLHelper getValuesWithTag:@"SERIAL_NUMBER" fromEnvelope:myResponse];
        NSMutableArray *desc = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:myResponse];
        NSMutableArray *activityReason = [ABHXMLHelper getValuesWithTag:@"EP_ACIKLAMA" fromEnvelope:myResponse];
        if ([sernr count] >0) {
            
            CSCooler *cooler;
            for(int sayac= 0 ; sayac < [sernr count] ;sayac++){
                cooler = [[CSCooler alloc] init];
                [cooler setSernr:[sernr objectAtIndex:sayac]];
                [cooler setDescription:[desc objectAtIndex:sayac]];
                [[selectedConfirmation items] addObject:cooler];
            }
            
            
            [selectedConfirmation setActivityReason:[activityReason objectAtIndex:0]];
            CSConfirmConfirmationViewController *confirmConfirmationViewController = [[CSConfirmConfirmationViewController alloc] initWithConfirmation:selectedConfirmation andItems:[selectedConfirmation items]];
            [confirmConfirmationViewController setDelegate:self];
            [self.navigationController pushViewController:confirmConfirmationViewController animated:YES];
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hatalı Teyit" 
                                                            message:[NSString stringWithFormat:@"Teyit kalemleri boş."]
                                                           delegate:self 
                                  
                                                  cancelButtonTitle:@"Tamam" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
-(void)initConfirmationsWithNumbers:(NSMutableArray*)myNumbers{
    [confirmations removeAllObjects];
    CSConfirmation *aConfirmation;
    for(id number in myNumbers){
        aConfirmation = [[CSConfirmation alloc] init];
        [aConfirmation setConfirmationNumber:number];
        [confirmations addObject:aConfirmation];
    }
    
}
-(void)initConfirmationsWithNumbers:(NSMutableArray*)myNumbers andCustomerNames:(NSMutableArray*)myCustomerNames{
    [self initConfirmationsWithNumbers:myNumbers];
    CSCustomer *aCustomer;
    for(int sayac = 0; sayac<[confirmations count];sayac++){
        aCustomer = [[CSCustomer alloc] init];
        [aCustomer setName1:[myCustomerNames objectAtIndex:sayac]];
        [[confirmations objectAtIndex:sayac] setCustomer:aCustomer];
    }
    
    
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([super isAnimationRunning]) {
        return;
    }
    selectedConfirmation = [confirmations objectAtIndex:[indexPath row]];
    NSString *tableName = [NSString stringWithFormat:@"KALEM"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"TANIM"];
    [columns addObject:@"SERIAL_NUMBER"];
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_CONFIRMATION_ITEMS"];
    [sapHandler setDelegate:self];
    [sapHandler addImportWithKey:@"OBJECTID" andValue:[selectedConfirmation confirmationNumber]];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    [super playAnimationOnView:self.view];
    
    
}

-(void)removeConfirmation:(CSConfirmation *)aConfirmation{
    CSConfirmation *tempConfirmation;
    for (int sayac = 0; sayac<[confirmations count]; sayac++) {
        tempConfirmation = [confirmations objectAtIndex:sayac];
        if ([tempConfirmation.confirmationNumber isEqualToString:aConfirmation.confirmationNumber]) {
            [confirmations removeObject:tempConfirmation];
            break;
        }
    }
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
