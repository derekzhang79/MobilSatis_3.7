//
//  CSDealerSalesChartViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 12.11.2012.
//
//

#import "CSDealerSalesChartViewController.h"

@interface CSDealerSalesChartViewController ()

@end

@implementation CSDealerSalesChartViewController
@synthesize myCustomer;
@synthesize pickerView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [pickerView setHidden:YES];
    CGRect tempFrame = pickerView.frame;
    tempFrame.size.height = 170;
    [pickerView setFrame:tempFrame];
    [self getDealerSalesDataFromSAP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer {
    self = [super initWithUser:myUser];
    self.myCustomer = aCustomer;
    return self;
}

- (void)getDealerSalesDataFromSAP {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_DEALER_SALES_DATA"];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:[myCustomer kunnr]];
    //[sapHandler addImportWithKey:@"I_KUNNR" andValue:@"700001"];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *beginDate = [NSString stringWithFormat:@"%d%d01", components.year - 1, components.month];
    NSString *endDate = [NSString stringWithFormat:@"%d%d01", components.year, components.month];
    
    [sapHandler addImportWithKey:@"I_BEGIN_DATE" andValue:beginDate];
    [sapHandler addImportWithKey:@"I_END_DATE" andValue:endDate];
    
   // NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"SIRA", @"KATEGORI", @"ETIKET", @"FIILI_GECMIS", @"FIILI_GUNCEL", @"GELISME", @"BUTCE", @"ORAN_GERC_BUTCE", @"GEREKEN", @"ORAN_GERC_GEREK", @"LINEKEY", nil];
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithObjects:@"AY", @"LITRE", @"BUTCE", nil];
    NSMutableArray *arr3 = [[NSMutableArray alloc] initWithObjects:@"TYPE", @"ID", @"NUMBER", @"MESSAGE", @"LOG_NO", @"LOG_MSG_NO", @"MESSAGE_V1", @"MESSAGE_V2", @"MESSAGE_V3", @"MESSAGE_V4", @"PARAMETER", @"ROW", @"FIELD", @"SYSTEM", nil];
    NSMutableArray *arr4 = [[NSMutableArray alloc] initWithObjects:@"TABLO1_GOSTER", @"TABLO2_GOSTER", @"TABLO3_GOSTER", @"TABLO4_GOSTER", @"TABLO1_BASLIK", @"TABLO2_BASLIK", @"TABLO4_BASLIK", nil];
    
    //[sapHandler addTableWithName:@"TABLO1" andColumns:arr];
    //[sapHandler addTableWithName:@"TABLO2" andColumns:arr];
    //[sapHandler addTableWithName:@"TABLO3" andColumns:arr];
    [sapHandler addTableWithName:@"AYLIK_TABLO1" andColumns:arr2];
    [sapHandler addTableWithName:@"AYLIK_TABLO2" andColumns:arr2];
    [sapHandler addTableWithName:@"AYLIK_TABLO3" andColumns:arr2];
    [sapHandler addTableWithName:@"RETURN" andColumns:arr3];
    [sapHandler addTableWithName:@"EKBILGI" andColumns:arr4];

    [super playAnimationOnView:self.view];

    [sapHandler prepCall];
    //[activityIndicator startAnimating];

}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    [self refreshAll];
    //[self showMessageFromResponses:[ABHXMLHelper getValuesWithTag:@"MESSAGE" fromEnvelope:myResponse]];
    
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
        
        NSArray *eventsArray = [CoreDataHandler fetchCustomerDetailByKunnr:[myCustomer kunnr]];
        CDOCustomerDetail *userLogin;
        
        if ([eventsArray count] > 0) {
            userLogin = [eventsArray objectAtIndex:0];
        }
        
        if ([userLogin dealerSale] != nil) {
            for (CDOMonthlySaleData *montySaleData in [[userLogin dealerSale] dealerSalesReport1]) {
                [report1 addObject:[montySaleData sale]];
                [budget1 addObject:[montySaleData budget]];
                [report1Texts addObject:[montySaleData month]];
            }
            header1 = [[userLogin dealerSale] title1];
            
            for (CDOMonthlySaleData *montySaleData in [[userLogin dealerSale] dealerSalesReport2]) {
                [report2 addObject:[montySaleData sale]];
                [budget2 addObject:[montySaleData budget]];
                [report2Texts addObject:[montySaleData month]];
            }
            header2 = [[userLogin dealerSale] title2];
            
            for (CDOMonthlySaleData *montySaleData in [[userLogin dealerSale] dealerSalesReport3]) {
                [report3 addObject:[montySaleData sale]];
                [budget3 addObject:[montySaleData budget]];
                [report3Texts addObject:[montySaleData month]];
            }
            header3 = [[userLogin dealerSale] title3];
            
            [self preparePickerControl];
            
            self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report1] andxAxisTexts:report1Texts andPlotData:[self getDataArrayFromReport:budget1]];
            [self->barPlot initialisePlot];
            
        }
        
    }
    else
        {      
    
        header1 = @"";
        header2 = @"";
        header3 = @"";
    
        report1Texts = [[NSMutableArray alloc] init];
        report1 = [[NSMutableArray alloc] init];
        budget1 = [[NSMutableArray alloc] init];
    
        report2Texts = [[NSMutableArray alloc] init];
        report2 = [[NSMutableArray alloc] init];
        budget2 = [[NSMutableArray alloc] init];
    
        report3Texts = [[NSMutableArray alloc] init];
        report3 = [[NSMutableArray alloc] init];
        budget3 = [[NSMutableArray alloc] init];
    
        NSString *tablo1 = [[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:0];
        NSString *tablo2 = [[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:1];
        NSString *tablo3 = [[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:2];

        NSArray *arr = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:[[ABHXMLHelper getValuesWithTag:@"BAPIRET2" fromEnvelope:myResponse] objectAtIndex:0]];
        NSArray *arr2 = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:[[ABHXMLHelper getValuesWithTag:@"ZEYONETICI_RAPOR_EKBILGI" fromEnvelope:myResponse] objectAtIndex:0]];

        for (int i = 0; i < [arr count]; i++) {
            if ([[[ABHXMLHelper getValuesWithTag:@"NUMBER" fromEnvelope:[arr objectAtIndex:i]] objectAtIndex:0] isEqualToString:@"139"]) {
                NSString *ekbilgi = [arr2 objectAtIndex:i];
            
                if ([[[ABHXMLHelper getValuesWithTag:@"TABLO1_GOSTER" fromEnvelope:ekbilgi] objectAtIndex:0] isEqualToString:@"X"]) {
                    header1 = [[ABHXMLHelper getValuesWithTag:@"TABLO1_BASLIK" fromEnvelope:ekbilgi] objectAtIndex:0];
                    if ([[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:tablo1] count] > i)
                        [self getSaleDataFromEnvelope:tablo1:i:0];
                }
    
                if ([[[ABHXMLHelper getValuesWithTag:@"TABLO2_GOSTER" fromEnvelope:ekbilgi] objectAtIndex:0] isEqualToString:@"X"]) {
                    header2 = [[ABHXMLHelper getValuesWithTag:@"TABLO2_BASLIK" fromEnvelope:ekbilgi] objectAtIndex:0];
                    if ([[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:tablo2] count] > i)
                        [self getSaleDataFromEnvelope:tablo2:i:1];
                }

                if ([[[ABHXMLHelper getValuesWithTag:@"TABLO3_GOSTER" fromEnvelope:ekbilgi] objectAtIndex:0] isEqualToString:@"X"]) {
                    header3 = [[ABHXMLHelper getValuesWithTag:@"TABLO3_BASLIK" fromEnvelope:ekbilgi] objectAtIndex:0];
                    if ([[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:tablo3] count] > i)
                        [self getSaleDataFromEnvelope:tablo3:i:2];
                }
            }
        }
        
        [report1 addObject:@""];
        [report2 addObject:@""];
        [report3 addObject:@""];
        [report1Texts insertObject:@"" atIndex:0];
        [report2Texts insertObject:@"" atIndex:0];
        [report3Texts insertObject:@"" atIndex:0];

        [self saveDealerSalesDataToCoreData];
    
        [self preparePickerControl];
        self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report1] andxAxisTexts:report1Texts andPlotData:[self getDataArrayFromReport:budget1]];
        [self->barPlot initialisePlot];
    }
}

- (void)getSaleDataFromEnvelope:(NSString *)envelope:(int)counter:(int)sayac {
    NSString *month = [[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:envelope] objectAtIndex:counter];
    NSString *litre = [[ABHXMLHelper getValuesWithTag:@"FIILI_GUNCEL" fromEnvelope:envelope] objectAtIndex:counter];
    NSString *budget = [[ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:envelope] objectAtIndex:counter];
    
    if (sayac == 0) {
        [report1Texts addObject:month];
        [report1 addObject:litre];
        [budget1 addObject:budget];
    }
    else if(sayac == 1) {
        [report2Texts addObject:month];
        [report2 addObject:litre];
        [budget2 addObject:budget];
    }
    else if(sayac == 2) {
        [report3Texts addObject:month];
        [report3 addObject:litre];
        [budget3 addObject:budget];
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


-(void) showMessageFromResponses:(NSMutableArray*)responses{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Açıklama" message:[responses objectAtIndex:0] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
    [alert show];
}

- (void)refreshAll{
    [report1 removeAllObjects];
    [report2 removeAllObjects];
    [report3 removeAllObjects];
}

-(void)preparePickerControl{
    [pickerView setHidden:NO];
    [pickerView reloadAllComponents];
}

#pragma mark - Core Data methods

- (void)saveDealerSalesDataToCoreData {
    
    CDODealerSalesData *dealerSaleData = (CDODealerSalesData *)[CoreDataHandler insertEntityData:@"CDODealerSalesData"];
    
    for (int  i = 0; i < [report1 count]; i++) {
        CDOMonthlySaleData *temp = (CDOMonthlySaleData *)[CoreDataHandler insertEntityData:@"CDOMonthlySaleData"];
        
        [temp setMonth:[report1Texts objectAtIndex:i]];
        if (i < [budget1 count]) {
            [temp setBudget:[budget1 objectAtIndex:i]];
        }
        [temp setSale:[report1 objectAtIndex:i]];
        
        [dealerSaleData addDealerSalesReport1Object:temp];
    }
    
    [dealerSaleData setTitle1:header1];
    
    for (int  i = 0; i < [report2 count]; i++) {
        CDOMonthlySaleData *temp = (CDOMonthlySaleData *)[CoreDataHandler insertEntityData:@"CDOMonthlySaleData"];
        
        [temp setMonth:[report2Texts objectAtIndex:i]];
        if (i < [budget2 count]) {
            [temp setBudget:[budget2 objectAtIndex:i]];
        }
        [temp setSale:[report2 objectAtIndex:i]];
        
        [dealerSaleData addDealerSalesReport2Object:temp];
    }
    
    [dealerSaleData setTitle2:header2];
    
    for (int  i = 0; i < [report3 count]; i++) {
        CDOMonthlySaleData *temp = (CDOMonthlySaleData *)[CoreDataHandler insertEntityData:@"CDOMonthlySaleData"];
        
        [temp setMonth:[report3Texts objectAtIndex:i]];
        if (i < [budget3 count]) {
            [temp setBudget:[budget3 objectAtIndex:i]];
        }
        [temp setSale:[report3 objectAtIndex:i]];
        
        [dealerSaleData addDealerSalesReport3Object:temp];
    }
    
    [dealerSaleData setTitle3:header3];
    
    NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[myCustomer kunnr]];
    CDOCustomerDetail *custDetail;
    
    if ([arr count] > 0) {
        custDetail = [arr objectAtIndex:0];
    }
    
    [custDetail setDealerSale:dealerSaleData];
    
    [CoreDataHandler saveEntityData];
    
}

- (void)checkExistingCoreDataToDelete {
    
    NSArray *customerDetailArray = [CoreDataHandler fetchCustomerDetailByKunnr:[myCustomer kunnr]];
    CDOCustomerDetail *customerDetail;
    
    if ([customerDetailArray count] > 0) {
        customerDetail = [customerDetailArray objectAtIndex:0];
    }
    
    [[CoreDataHandler getManagedObject] deleteObject:[customerDetail dealerSale]];
    
    [customerDetail setDealerSale:nil];
        
    [CoreDataHandler saveEntityData];
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
            else {
                row++;
            }
        case 1:
            if(header2.length>0){
                return header2;
            }
            else {
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
    
    if (header1.length>0 && [report1 count] > 0) {
        returnValue++;
    }
    if (header2.length>0 && [report2 count] > 0) {
        returnValue++;
    }
    if (header3.length>0 && [report3 count] > 0) {
        returnValue++;
    }
    return returnValue;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationItem] setTitle:@"Bayi/Dist. Satış"];
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
//    [self view].transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
}
@end
