//
//  CSProfileSalesChartViewController.m
//  MobilSatis
//
//  Created by alp keser on 9/17/12.
//
//

#import "CSProfileSalesChartViewController.h"

@interface CSProfileSalesChartViewController ()

@end

@implementation CSProfileSalesChartViewController
//@synthesize report2,report3;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andBeginDate:(NSString*)begin andEndDate:(NSString*)end{
    self = [super initWithUser:myUser];
    beginDate = [NSString stringWithFormat:@"%@",begin];
    endDate = [NSString stringWithFormat:@"%@",end];
    return self;
}
-(void) showMessageFromResponses:(NSMutableArray*)responses{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Açıklama" message:[responses objectAtIndex:0] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
}
- (void)getSalesDataOfUser:(CSUser*)aUser{
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_MYK_AYLIKKUMULE"];
    [sapHandler addImportWithKey:@"I_MYK" andValue:[user username]];
    //aUser.username
    [sapHandler addImportWithKey:@"SORGU_BASLANGIC" andValue:beginDate];
    [sapHandler addImportWithKey:@"SORGU_BITIS" andValue:endDate];
    //20120501 -- 20120531
    
    NSString *tableName = [NSString stringWithFormat:@"TABLO1"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"FIILI_GECMIS"];
    [columns addObject:@"FIILI_GUNCEL"];
    [columns addObject:@"GELISME"];
    [columns addObject:@"BUTCE"];
    [columns addObject:@"ORAN_GERC_BUTCE"];
    
    [sapHandler addTableWithName:tableName andColumns:columns];
    tableName = [NSString stringWithFormat:@"TABLO2"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    tableName = [NSString stringWithFormat:@"TABLO3"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [super playAnimationOnView:self.view];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
}
-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    [self refreshAll];
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        
        report1 = [[NSMutableArray alloc] init];
        report2 = [[NSMutableArray alloc] init];
        report3 = [[NSMutableArray alloc] init];
        report1Texts = [[NSMutableArray alloc] init];
        report2Texts = [[NSMutableArray alloc] init];
        report3Texts = [[NSMutableArray alloc] init];
        header1 = @"";
        header2 = @"";
        header3 = @"";
        
        NSArray *eventsArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
        CDOUser *userLogin;
        
        if ([eventsArray count] > 0) {
            userLogin = (CDOUser *)[eventsArray objectAtIndex:0];
        }
        
        if ([userLogin chartSaleData] != nil) {
            for (CDOMonthlySaleData *montySaleData in [[userLogin chartSaleData] chartReport1]) {
                [report1 addObject:[montySaleData sale]];
                [budget1 addObject:[montySaleData budget]];
                [report1Texts addObject:[montySaleData month]];
            }
            header1 = [[userLogin chartSaleData] chartTitle1];
            
            for (CDOMonthlySaleData *montySaleData in [[userLogin chartSaleData] chartReport2]) {
                [report2 addObject:[montySaleData sale]];
                [budget2 addObject:[montySaleData budget]];
                [report2Texts addObject:[montySaleData month]];
            }
            header2 = [[userLogin chartSaleData] chartTitle2];

            for (CDOMonthlySaleData *montySaleData in [[userLogin chartSaleData] chartReport3]) {
                [report3 addObject:[montySaleData sale]];
                [budget3 addObject:[montySaleData budget]];
                [report3Texts addObject:[montySaleData month]];
            }
            header3 = [[userLogin chartSaleData] chartTitle3];
            
            [self preparePickerControl];
            self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report1]andxAxisTexts:report1Texts andPlotData:[self getDataArrayFromReport:budget1]];
            [self->barPlot initialisePlot];
        }

    }
    else
    {
        [self showMessageFromResponses:[ABHXMLHelper getValuesWithTag:@"MESSAGE" fromEnvelope:myResponse]];
        int sayac = 0;
        header1 =@"";
        header2 =@"";
        header3 =@"";
        if ([[[ABHXMLHelper getValuesWithTag:@"TABLO1_GOSTER" fromEnvelope:myResponse] objectAtIndex:0] isEqualToString:@"X"]) {
            header1 = [NSString stringWithFormat:@"%@",[[ABHXMLHelper getValuesWithTag:@"TABLO1_BASLIK" fromEnvelope:myResponse] objectAtIndex:0] ];
            report1Texts = [[NSMutableArray alloc] init];
            report1 = [[NSMutableArray alloc] init];
            budget1 = [[NSMutableArray alloc] init];
            [self parseResponse:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:sayac] intoArray:&report1 andTexts:&report1Texts andBudgets:&budget1];
            sayac++;
        }
        if ([[[ABHXMLHelper getValuesWithTag:@"TABLO2_GOSTER" fromEnvelope:myResponse] objectAtIndex:0] isEqualToString:@"X"]) {
            header2 = [[ABHXMLHelper getValuesWithTag:@"TABLO2_BASLIK" fromEnvelope:myResponse] objectAtIndex:0];
            report2Texts = [[NSMutableArray alloc] init];
            report2 = [[NSMutableArray alloc] init];
            budget2 = [[NSMutableArray alloc] init];
            [self parseResponse:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:sayac] intoArray:&report2 andTexts:&report2Texts andBudgets:&budget2];
            sayac++;
        }
        if ([[[ABHXMLHelper getValuesWithTag:@"TABLO3_GOSTER" fromEnvelope:myResponse] objectAtIndex:0] isEqualToString:@"X"]) {
            header3 = [[ABHXMLHelper getValuesWithTag:@"TABLO3_BASLIK" fromEnvelope:myResponse] objectAtIndex:0];
            report3Texts = [[NSMutableArray alloc] init];
            report3 = [[NSMutableArray alloc] init];
            budget3 = [[NSMutableArray alloc] init];
            [self parseResponse:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:2] intoArray:&report3 andTexts:&report3Texts andBudgets:&budget3];
        }
//    [self parseResponseFromReports:[ABHXMLHelper getValuesWithTag:@"ZEYONETICI_RAPOR_TABLO" fromEnvelope:myResponse] andProjections:[ABHXMLHelper getValuesWithTag:@"ZEYONETICI_TAHMIN_TABLO" fromEnvelope:myResponse]];
//    [self getTitlesFormEnvelope:myResponse];
//    NSMutableArray*dataArray = [[NSMutableArray alloc] init];
//    CGFloat month, liter;
//    for (int counter=0; counter<[report1 count]; counter++) {
//        liter = [[report1 objectAtIndex:counter] floatValue] ;
//        [dataArray addObject:[NSValue valueWithCGPoint:CGPointMake(counter+1, liter)]];
//    }
        
        [self checkExistingCoreDataToDelete];
        [self saveChartSaleDataToCoreData];

        [self preparePickerControl];
        self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report1]andxAxisTexts:report1Texts andPlotData:[self getDataArrayFromReport:budget1]];
        [self->barPlot initialisePlot];
        }
    }

- (NSMutableArray*)getDataArrayFromReport:(NSMutableArray*)report{
    NSMutableArray*dataArray = [[NSMutableArray alloc] init];
    CGFloat month, liter;
    for (int counter=0; counter<[report count]; counter++) {
        liter = [[report objectAtIndex:counter] floatValue] ;
        [dataArray addObject:[NSValue valueWithCGPoint:CGPointMake(counter+1, liter)]];
    }
    return dataArray;
}

# pragma mark - Core Data methods

- (void)saveChartSaleDataToCoreData {
    
        CDOChartSaleData *chartSaleData = (CDOChartSaleData *)[CoreDataHandler insertEntityData:@"CDOChartSaleData"];
        
        for (int  i = 0; i < [report1 count]; i++) {
            CDOMonthlySaleData *temp = (CDOMonthlySaleData *)[CoreDataHandler insertEntityData:@"CDOMonthlySaleData"];
            
            [temp setMonth:[report1Texts objectAtIndex:i]];
            if (i < [budget1 count]) {
                [temp setBudget:[budget1 objectAtIndex:i]];
            }
            [temp setSale:[report1 objectAtIndex:i]];
            
            [chartSaleData addChartReport1Object:temp];
        }
        
        [chartSaleData setChartTitle1:header1];
        
        for (int  i = 0; i < [report2 count]; i++) {
            CDOMonthlySaleData *temp = (CDOMonthlySaleData *)[CoreDataHandler insertEntityData:@"CDOMonthlySaleData"];
            
            [temp setMonth:[report2Texts objectAtIndex:i]];
            if (i < [budget2 count]) {
                [temp setBudget:[budget2 objectAtIndex:i]];
            }
            [temp setSale:[report2 objectAtIndex:i]];
            
            [chartSaleData addChartReport2Object:temp];
        }
        
        [chartSaleData setChartTitle2:header2];
        
        for (int  i = 0; i < [report3 count]; i++) {
            CDOMonthlySaleData *temp = (CDOMonthlySaleData *)[CoreDataHandler insertEntityData:@"CDOMonthlySaleData"];
            
            [temp setMonth:[report3Texts objectAtIndex:i]];
            if (i < [budget3 count]) {
                [temp setBudget:[budget3 objectAtIndex:i]];
            }
            [temp setSale:[report3 objectAtIndex:i]];
            
            [chartSaleData addChartReport3Object:temp];
        }
        
        [chartSaleData setChartTitle3:header3];
        
        CDOUser *userLog = (CDOUser *)[CoreDataHandler insertExistingEntityData:@"CDOUser" andValueForSort:@"username"];
        [userLog setChartSaleData:chartSaleData];
        
        [CoreDataHandler saveEntityData];
}

- (void) checkExistingCoreDataToDelete {
    NSArray *userSaleArray = [CoreDataHandler fetchExistingEntityData:@"CDOChartSaleData" sortingParameter:@"chartTitle1" objectContext:[CoreDataHandler getManagedObject]];
    
    for (CDOChartSaleData *temp in userSaleArray) {
        [[CoreDataHandler getManagedObject] deleteObject:temp];
    }
    
    NSArray *userArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
    CDOUser *userLog;
    
    if( [userArray count] > 0)
        userLog = [userArray objectAtIndex:0];
    
    [userLog setChartSaleData:nil];
    
    [CoreDataHandler saveEntityData];

}

-(void)preparePickerControl{
    [pickerView setHidden:NO];
    [pickerView reloadAllComponents];
}

-(void)parseResponse:(NSString*)response intoArray:(NSMutableArray*__strong *)array andTexts:(NSMutableArray*__strong *)texts andBudgets:(NSMutableArray*__strong*)budgets{
   *texts = [[NSMutableArray alloc] initWithArray:[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:response] copyItems:NO];
    *budgets = [ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:response];
    *array = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:response];
    [*texts insertObject:@"" atIndex:0];
    [*array addObject:@""];
   // [*budgets addObject:@""];
//    CSGraphData *temp;
//    for (int sayac = 0; sayac<months.count;sayac++) {
//        temp  = [[CSGraphData alloc] init];
//        [temp setYData:[liter objectAtIndex:sayac]];
//        [temp setXData:[months objectAtIndex:sayac]];
//        [array addObject:temp];
//    }
}
- (void)refreshAll{
    [report1 removeAllObjects];
    [report2 removeAllObjects];
    [report3 removeAllObjects];
//    [projection1 removeAllObjects];
//    [titles removeAllObjects];
//    fark = 0;
}

#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self calcChartCount] ;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (row) {
        case 0:
            if (header1.length>0) {
                return header1;
            }
            else
            {
                row++;
            }
        case 1:
            if(header2.length>0){
               return header2;
            }else{
                row +=1;    
            }
            
            
        case 2:
            return header3;
            break;
            
        default:
            break;
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (row) {
        case 0:
            if (header1.length>0) {
                self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report1]andxAxisTexts:report1Texts andPlotData:[self getDataArrayFromReport:budget1]];
                [self->barPlot initialisePlot];
                break;
            }else{
                row++;
            }
            
            
        case 1:
            if(header2.length>0){
                self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report2]andxAxisTexts:report2Texts andPlotData:[self getDataArrayFromReport:budget2]];
                [self->barPlot initialisePlot];
                break;
            }else{
                row +=1;
            }
            
            
        case 2:
            self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report3]andxAxisTexts:report3Texts andPlotData:[self getDataArrayFromReport:budget3]];
            [self->barPlot initialisePlot];
            break;
            
        default:
            break;
    }
}
- (int)calcChartCount{
    int returnValue = 0;
    if (header1.length>0) {
        returnValue++;
    }
    if (header2.length>0) {
        returnValue++;
    }
    if (header3.length>0) {
        returnValue++;
    }
    return returnValue;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [pickerView setHidden:YES];
   CGRect tempFrame = pickerView.frame;
    tempFrame.size.height = 162; 
    [pickerView setFrame:tempFrame];
    [self getSalesDataOfUser:user];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yenile" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshConfirmations)];
    // [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
    [[self navigationItem] setTitle:@"Satış Özetim"];
//    [self view].transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    
        //[myTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];

    
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
