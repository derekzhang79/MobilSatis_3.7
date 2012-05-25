//
//  CSEquipmentViewController.m
//  MobilSatis
//
//  Created by ABH on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "CSEquipmentViewController.h"
@interface CSEquipmentViewController ()

@end

@implementation CSEquipmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer{
    self  = [super initWithUser:myUser];
    customer = aCustomer;
    return self;
}

- (IBAction)segmentTapped:(id)sender{
    
    
    UISegmentedControl *myControl = (UISegmentedControl*) sender;
    if ([myControl selectedSegmentIndex] == 0) {
        //  do whatever you wanna do
    }
    if ([myControl selectedSegmentIndex] == 1) {
        //  do whatever you wanna do
    }
}

- (IBAction)refreshData{
    
}


- (void)getCoolersFromSap{
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_COOLERS_OF_CUSTOMER"];
    [sapHandler addImportWithKey:@"CUSTOMER" andValue:customer.kunnr];
    [sapHandler addImportWithKey:@"P_DIGER" andValue:@"X"];
    [sapHandler addTableWithName:@"COOLERS" andColumns:[NSMutableArray arrayWithObjects:@"TANIM",@"SERIAL_NUMBER",@"TYPE", nil]];
    [sapHandler addTableWithName:@"OTHER_COOLERS" andColumns:[NSMutableArray arrayWithObjects:@"TANIM",@"MIKTAR",@"TYPE", nil]];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
}

-(void)getResponseWithString:(NSString *)myResponse{
    [self initEfesCoolersWithEnvelope:[[ABHXMLHelper getValuesWithTag:@"ZMOB_TEYIT_ITM_STR" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initOtherCoolersWithEnvelope:[[ABHXMLHelper getValuesWithTag:@"ZMOB_TEYIT_ITM_OTHR" fromEnvelope:myResponse] objectAtIndex:0]];
}

- (void)initEfesCoolersWithEnvelope:(NSString*)envelope{
    
}

- (void)initOtherCoolersWithEnvelope:(NSString*)envelope{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [efesOtherSegmentControl addTarget:self
                                action:@selector(segmentTapped:)
                      forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Yenile" style:UIBarButtonSystemItemAction target:self action:@selector(refreshData)];
    [[self navigationItem] setRightBarButtonItem:refreshButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

