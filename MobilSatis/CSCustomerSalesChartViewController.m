//
//  CSCustomerSalesChartViewController.m
//  MobilSatis
//
//  Created by ABH on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSCustomerSalesChartViewController.h"

@implementation CSCustomerSalesChartViewController
@synthesize thisYearSale;
@synthesize lastYearSale;


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

- (void)getSalesData {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getBWHostName] andClient:[ABHConnectionInfo getBWClient] andDestination:[ABHConnectionInfo getBWDestination] andSystemNumber:[ABHConnectionInfo getBWSystemNumber] andUserId:[ABHConnectionInfo getBWUserId] andPassword:[ABHConnectionInfo getBWPassword] andRFCName:@"ZMOB_GET_SALE_DATA"];
   //[sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:customer.kunnr];
    [sapHandler addTableWithName:@"T_LITRE" andColumns:[NSMutableArray arrayWithObjects:@"AY",@"LITRE", nil]];
    [sapHandler addTableWithName:@"T_MLITRE" andColumns:[NSMutableArray arrayWithObjects:@"MATERIAL",@"TANIM",@"LITRE", nil]];
    [super playAnimationOnView:self.view];
    [sapHandler prepCall];    
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        
        NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
        CDOCustomerDetail *tempCust;
        
        if ([arr count] > 0) {
            tempCust = [arr objectAtIndex:0];
        }
        
        if ([tempCust customerSale] != nil) {
            
            sixMonthData = [[NSMutableArray alloc] init];
            sixMonthTexts = [[NSMutableArray alloc] init];
            CGFloat liter;
            int sayac = 0;

            for (CDOMonthlySaleData *temp in [tempCust customerSale]) {
                
                liter = [[temp sale] floatValue] ;
                [sixMonthData addObject:[NSValue valueWithCGPoint:CGPointMake(sayac+1, liter)]];
                [sixMonthTexts addObject:[temp month]];
                sayac++;
                }
            
                [sixMonthTexts insertObject:@"" atIndex:0];
                [sixMonthData addObject:[NSValue valueWithCGPoint:CGPointMake(sixMonthData.count+1 , 0)]];
            
                [table reloadData];
            
                self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:sixMonthData andxAxisTexts:sixMonthTexts];
                [self->barPlot initialisePlot];

            }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Seçtiğiniz müşterinin satışları cihazınızda kayıtlı değildir" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        @try {
            [self initLastMonth:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_MALZ_LITRE" fromEnvelope:myResponse] objectAtIndex:0]];
            [self initLastSixMonths:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:0]];
            // selectedConfirmation.items = [[NSMutableArray alloc] init];
            self.lastYearSale = [[ABHXMLHelper getValuesWithTag:@"E_ESKI_SATIS" fromEnvelope:myResponse] objectAtIndex:0];
            self.thisYearSale = [[ABHXMLHelper getValuesWithTag:@"E_YILLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:0];
        
            [table reloadData];
        
            self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:sixMonthData andxAxisTexts:sixMonthTexts];
            [self->barPlot initialisePlot];
        }
        @catch (NSException *exception) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Beklenmeyen bir hata oluştu tekrar deneyiniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            [alert show];
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

- (void)initLastMonth:(NSString*)envelope{

    lastMonthData = [[NSMutableArray alloc] init];
    NSMutableArray *lastMonthValues =[[NSMutableArray alloc] init]; 
    lastMonthTexts = [[NSMutableArray alloc] init]; 
    NSMutableArray *material = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:envelope];
    //lastMonthTexts = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:envelope];
    lastMonthValues = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:envelope];
    float saleAmount;
    for (int sayac=0; sayac<[lastMonthValues count]; sayac++) {
        //month = [[monthArray objectAtIndex:sayac] floatValue] ;
         saleAmount = [[lastMonthValues objectAtIndex:sayac] floatValue] ;
        [lastMonthData addObject:[NSValue valueWithCGPoint:CGPointMake(sayac+1,saleAmount)]];
    }
    lastMonthTexts = [[NSMutableArray alloc] initWithCapacity:material.count];
    for (int sayac=0; sayac<[material count]; sayac++) {
        [lastMonthTexts addObject:[material objectAtIndex:sayac] ];
    }
    [lastMonthTexts insertObject:@"" atIndex:0];

}
- (void)initLastSixMonths:(NSString*)envelope{
    NSMutableArray *monthArray = [ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:envelope];
    NSMutableArray *literArray = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:envelope];
    
    sixMonthData = [[NSMutableArray alloc] init];
    sixMonthTexts = [[NSMutableArray alloc] init];
    CGFloat month, liter;
    
    for (int sayac=0; sayac<[literArray count]; sayac++) {
        //month = [[monthArray objectAtIndex:sayac] floatValue] ;
        liter = [[literArray objectAtIndex:sayac] floatValue] ;
        [sixMonthData addObject:[NSValue valueWithCGPoint:CGPointMake(sayac+1, liter)]];
    }
    sixMonthTexts = [[NSMutableArray alloc] initWithCapacity:monthArray.count];
    for (int sayac=0; sayac<[monthArray count]; sayac++) {
        [sixMonthTexts addObject:[monthArray objectAtIndex:sayac] ];
    }
    [sixMonthTexts insertObject:@"" atIndex:0];
    [sixMonthData addObject:[NSValue valueWithCGPoint:CGPointMake(sixMonthData.count+1 , 0)]];
    
    [self checkExistingCoreDataToDelete];
    [self saveLastSixMonthsCustomerSaleDataToCoreData];
}

- (IBAction)segmentTapped:(id)sender{
    
    
    UISegmentedControl *myControl = (UISegmentedControl*) sender;
    if ([myControl selectedSegmentIndex] == 0) {
        //  do whatever you wanna do
       // barPlot reloadSoldier:<#(NSMutableArray *)#> isHorizontal:<#(BOOL)#>
        [barPlot turnThatThingToVerticalwithData:sixMonthData andXAxisTexts:sixMonthTexts];
        
    }
    if ([myControl selectedSegmentIndex] == 1) {
        //  do whatever you wanna do
      [barPlot turnThatThingToHorizantalwithData:lastMonthData andYAxisTexts:lastMonthTexts];
        
    }
}

#pragma mark - Core Data methods

- (void)saveLastSixMonthsCustomerSaleDataToCoreData {
    
    NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
    CDOCustomerDetail *cust;
    
    if ([arr count] > 0) {
        cust = [arr objectAtIndex:0];
    }
    
    for (int i = 0; i < [sixMonthData count]; i++) {
        CDOMonthlySaleData *tempSaleData = (CDOMonthlySaleData *)[CoreDataHandler insertEntityData:@"CDOMonthlySaleData"];
        [tempSaleData setMonth:[sixMonthTexts objectAtIndex:i]];
        
        NSValue *value = [sixMonthData objectAtIndex:i];
        CGPoint point = [value CGPointValue];
        
        [tempSaleData setSale:[NSString stringWithFormat:@"%f",point.y]];
        
        [cust addCustomerSaleObject:tempSaleData];
    }
    
    [CoreDataHandler saveEntityData];
}

- (void)checkExistingCoreDataToDelete {
    
    NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
    CDOCustomerDetail *customerDetail;
    
    if ([arr count] > 0)
        customerDetail = [arr objectAtIndex:0];
    
    for (CDOMonthlySaleData *temp in [customerDetail customerSale]) 
        [[CoreDataHandler getManagedObject] deleteObject:temp];
    
    [customerDetail setCustomerSale:nil];
    [CoreDataHandler saveEntityData];
}

#pragma mark - Table delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    int row = [indexPath row];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    switch (row) {
        case 0:
            cell.textLabel.text = @"Geçen Yıl";
            cell.detailTextLabel.text = self.lastYearSale;
            break;
        case 1:
            cell.textLabel.text = @"Fiili";
            cell.detailTextLabel.text = self.thisYearSale;
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    oldNavFrame = self.navigationController.navigationBar.frame;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//    self.navigationController.view.frame = CGRectMake(0, 0, 768, 1064);
//        }else{
//            self.navigationController.view.frame = CGRectMake(0, 0, 320, 500);
//        }
    // Do any additional setup after loading the view from its nib.
    
    [self getSalesData];
    [segmentedControl addTarget:self
                                action:@selector(segmentTapped:)
                      forControlEvents:UIControlEventValueChanged];
    
  /*  
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        if ([table respondsToSelector:@selector(backgroundView)]) 
        {
            table.backgroundView = nil;
            [table setBackgroundView:[[UIView alloc] init]];
            table.backgroundColor = [UIColor whiteColor];

        }    
    }
    else {*/
    table.backgroundColor = [UIColor clearColor];
    table.opaque = NO;
    table.backgroundView = nil;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //}
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Müşteri Satışları"];
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    [self view].transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
//     CGRect tempframe = self.navigationController.navigationBar.frame;
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//            //tempframe.size.height = 50;
//        }else{
//            
//        }
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, tempframe.size.width, 50);
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
//     [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//    
//        oldNavFrame.origin.y = 20;
//        oldNavFrame.size.height = 44;
//        self.navigationController.view.frame = CGRectMake(0, 0, 768, 1024);
//    }
//    else
//    {
//        oldNavFrame.origin.y = 20;
//        oldNavFrame.size.height = 44;
//        self.navigationController.view.frame = CGRectMake(0, 0, 320, 480);
//    }
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
//    self.navigationController.navigationBar.frame = oldNavFrame;
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
