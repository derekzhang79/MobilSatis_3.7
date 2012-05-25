//
//  CSCustomerSalesChartViewController.m
//  MobilSatis
//
//  Created by ABH on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSCustomerSalesChartViewController.h"

@implementation CSCustomerSalesChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer{
    self = [super initWithUser:myUser];
    customer = selectedCustomer;
    return  self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [self adjustViewsForOrientation:toInterfaceOrientation];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
  //      titleImageView.center = CGPointMake(235.0f, 42.0f);
    //    subtitleImageView.center = CGPointMake(355.0f, 70.0f);
      //  ...
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
       // titleImageView.center = CGPointMake(160.0f, 52.0f);
        //subtitleImageView.center = CGPointMake(275.0f, 80.0f);
       // ...
    }
}

- (void)getSalesData{
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getBWHostName] andClient:[ABHConnectionInfo getBWClient] andDestination:[ABHConnectionInfo getBWDestination] andSystemNumber:[ABHConnectionInfo getBWSystemNumber] andUserId:[ABHConnectionInfo getBWUserId] andPassword:[ABHConnectionInfo getBWPassword] andRFCName:@"ZMOB_GET_SALE_DATA"];
   //[sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:customer.kunnr];
    [sapHandler addTableWithName:@"T_LITRE" andColumns:[NSMutableArray arrayWithObjects:@"AY",@"LITRE", nil]];
    [sapHandler addTableWithName:@"T_MLITRE" andColumns:[NSMutableArray arrayWithObjects:@"MATERIAL",@"TANIM",@"LITRE", nil]];
    [sapHandler prepCall];
    
    [super playAnimationOnView:self.view];
    
}
-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
    NSLog(@"%@",myResponse);
    [self initLastMonth:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_MALZ_LITRE" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initLastSixMonths:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:0]];
   // selectedConfirmation.items = [[NSMutableArray alloc] init];
         
    

    
    self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:sixMonthData];
    [self->barPlot initialisePlot];
    
    
}

- (void)initLastMonth:(NSString*)envelope{
//    <soapenv:Body><ns1:callSapRFCByName2XMLResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://webService.abh.com"><callSapRFCByName2XMLReturn soapenc:arrayType="xsd:anyType[3]" xsi:type="soapenc:Array" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"><callSapRFCByName2XMLReturn xsi:type="soapenc:string"><ZMOB_AYLIK_LITRE><item><AY>KASIM</AY><LITRE>345.680</LITRE></item><item><AY>ARALIK</AY><LITRE>883.520</LITRE></item><item><AY>OCAK</AY><LITRE>447.920</LITRE></item><item><AY>ŞUBAT</AY><LITRE>539.600</LITRE></item><item><AY>MART</AY><LITRE>715.520</LITRE></item></ZMOB_AYLIK_LITRE></callSapRFCByName2XMLReturn><callSapRFCByName2XMLReturn xsi:type="soapenc:string"><ZMOB_AYLIK_MALZ_LITRE><item><MALZEME>000000000000150003</MALZEME><TANIM>EP KASA 50</TANIM><LITRE>156.000</LITRE></item><item><MALZEME>000000000000150015</MALZEME><TANIM>EP KOLİ 50</TANIM><LITRE>20.000</LITRE></item><item><MALZEME>000000000000150021</MALZEME><TANIM>EP TAVA 50</TANIM><LITRE>192.000</LITRE></item><item><MALZEME>000000000000150137</MALZEME><TANIM>MGD KOLİ 3</TANIM><LITRE>39.600</LITRE></item><item><MALZEME>000000000000150140</MALZEME><TANIM>EP TAVA 50</TANIM><LITRE>24.000</LITRE></item><item><MALZEME>000000000000150440</MALZEME><TANIM>EP KOLİ 50</TANIM><LITRE>6.000</LITRE></item><item><MALZEME>000000000000150487</MALZEME><TANIM>XT TAVA 50</TANIM><LITRE>36.000</LITRE></item><item><MALZEME>000000000000151105</MALZEME><TANIM>EP KOLİ 50</TANIM><LITRE>30.000</LITRE></item><item><MALZEME>000000000000151110</MALZEME><TANIM>EP TAVA 50</TANIM><LITRE>36.000</LITRE></item></ZMOB_AYLIK_MALZ_LITRE></callSapRFCByName2XMLReturn><callSapRFCByName2XMLReturn xsi:type="soapenc:string"><OUTPUT><E_AY></E_AY></OUTPUT></callSapRFCByName2XMLReturn></callSapRFCByName2XMLReturn></ns1:callSapRFCByName2XMLResponse></soapenv:Body></soapenv:Envelope>
    NSMutableArray *material = [ABHXMLHelper getValuesWithTag:@"MALZEME" fromEnvelope:envelope];
    NSMutableArray *description = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:envelope];
    NSMutableArray *liter = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:envelope];
    lastMonthData = [[NSMutableArray alloc] init];

}
- (void)initLastSixMonths:(NSString*)envelope{
    NSMutableArray *monthArray = [ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:envelope];
    NSMutableArray *literArray = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:envelope];
    
    sixMonthData = [[NSMutableArray alloc] init];

    CGFloat month, liter;
    
    for (int sayac=0; sayac<[monthArray count]; sayac++) {
        //month = [[monthArray objectAtIndex:sayac] floatValue] ;
        liter = [[literArray objectAtIndex:sayac] floatValue] ;
        [sixMonthData addObject:[NSValue valueWithCGPoint:CGPointMake(sayac+1, liter)]];
    }

}

- (IBAction)segmentTapped:(id)sender{
    
    
    UISegmentedControl *myControl = (UISegmentedControl*) sender;
    if ([myControl selectedSegmentIndex] == 0) {
        //  do whatever you wanna do
       // barPlot reloadSoldier:<#(NSMutableArray *)#> isHorizontal:<#(BOOL)#>
    }
    if ([myControl selectedSegmentIndex] == 1) {
        //  do whatever you wanna do
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self getSalesData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //    [barGraphHostingView setHidden:YES];
   
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
