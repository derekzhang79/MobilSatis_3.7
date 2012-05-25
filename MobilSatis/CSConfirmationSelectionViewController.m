//
//  CSConfirmationSelectionViewController.m
//  CrmServisPrototype
//
//  Created by alp keser on 12/17/11.
//  Copyright (c) 2011 sabanci university. All rights reserved.
//

#import "CSConfirmationSelectionViewController.h"
#import "CSConfirmationListViewController.h"
#import "CSConfirmation.h"
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
@implementation CSConfirmationSelectionViewController
@synthesize confirmations;

- (id)init{
    self = [super init];
    return self;
}
-(id)initWithUser:(CSUser*)myUser{
    self = [self init];
    user = myUser;
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

-(IBAction)listMyConfirmations:(id)sender{
    [self refreshConfirmations];
    
    
}

-(IBAction)refreshConfirmations{
    //prep table
    NSString *tableName = [NSString stringWithFormat:@"ET_TEYITLER"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"CONFNUMBER"];
    [columns addObject:@"KUNNR"];
    [columns addObject:@"STATUS"];
    [columns addObject:@"RECORDDATE"];
    //CANLI 10.12.1.179 TEST SRECTS081
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:@"http://saprfcwebserviceext1.abh.com.tr/SapRFCWebService/services/RFCService"];
    [sapHandler prepRFCWithHostName:@"SRECTS081" andClient:@"100" andDestination:@"CLNT100" andSystemNumber:@"00" andUserId:@"MOBIL" andPassword:@"12345678" andRFCName:@"ZMOB_GET_CONFIRMATIONS_OF_SALE"];
    [sapHandler setDelegate:self];
    [sapHandler addImportWithKey:@"USERNAME" andValue:[user username]];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    
}
-(void)getResponseWithString:(NSString *)myResponse{
    NSMutableArray *confirmationNumbers =  [ABHXMLHelper getValuesWithTag:@"CONFNUMBER" fromEnvelope:myResponse];
    NSMutableArray *customerNames =  [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:myResponse];
    if( [confirmationNumbers count] != 0 ){
        [self initConfirmationsWithNumbers:confirmationNumbers andCustomerNames:customerNames];
        CSConfirmationListViewController *confirmationListViewController = [[CSConfirmationListViewController alloc] initWithUser:user andConfirmations:confirmations];
        
        [self.navigationController pushViewController:confirmationListViewController animated:YES];
    }
}
-(void)initConfirmationsWithNumbers:(NSMutableArray*)myNumbers{
    CSConfirmation *aConfirmation;
    confirmations = [[NSMutableArray alloc] init];
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





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Teyit Onayla" style:UIBarButtonItemStyleBordered target:self action:@selector(selectProcess)];
    [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
