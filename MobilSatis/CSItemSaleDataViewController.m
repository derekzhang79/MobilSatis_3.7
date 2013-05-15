//
//  CSItemSaleDataViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 15.11.2012.
//
//

#import "CSItemSaleDataViewController.h"

@interface CSItemSaleDataViewController ()

@end

@implementation CSItemSaleDataViewController
@synthesize pickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser andUserSaleData:(CSUserSaleData*)anUserSaleData andTitle:(NSString*)atitle beginDate:(NSString*)aBegin endDate:(NSString *)aEnd {
    self = [self initWithUser:myUser];
    userSaleData = anUserSaleData;
    title = atitle;
    beginDate = [NSString stringWithFormat:@"%@", aBegin];
    endDate = [NSString stringWithFormat:@"%@", aEnd];
    
    return self;
}

- (void)getItemSaleDataFromSAP {
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_ITEM_SALES_DATA"];
    
    [sapHandler addImportWithKey:@"I_MYK" andValue:[[self user] username]];
    
    [sapHandler addImportWithKey:@"I_BEGIN_DATE" andValue:beginDate];
    [sapHandler addImportWithKey:@"I_END_DATE" andValue:endDate];
    [sapHandler addImportWithKey:@"I_MATNR" andValue:[userSaleData lineKey]];
    
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithObjects:@"AY", @"LITRE", @"BUTCE", nil];
    NSMutableArray *arr3 = [[NSMutableArray alloc] initWithObjects:@"TYPE", @"ID", @"NUMBER", @"MESSAGE", @"LOG_NO", @"LOG_MSG_NO", @"MESSAGE_V1", @"MESSAGE_V2", @"MESSAGE_V3", @"MESSAGE_V4", @"PARAMETER", @"ROW", @"FIELD", @"SYSTEM", nil];
    NSMutableArray *arr4 = [[NSMutableArray alloc] initWithObjects:@"TABLO1_GOSTER", @"TABLO2_GOSTER", @"TABLO3_GOSTER", @"TABLO4_GOSTER", @"TABLO1_BASLIK", @"TABLO2_BASLIK", @"TABLO4_BASLIK", nil];
    
    [sapHandler addTableWithName:@"TABLO1" andColumns:arr2];
    [sapHandler addTableWithName:@"TABLO2" andColumns:arr2];
    [sapHandler addTableWithName:@"TABLO3" andColumns:arr2];
    [sapHandler addTableWithName:@"RETURN" andColumns:arr3];
    [sapHandler addTableWithName:@"EKBILGI" andColumns:arr4];
    
    
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];

}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    [self refreshAll];
    //[self showMessageFromResponses:[ABHXMLHelper getValuesWithTag:@"MESSAGE" fromEnvelope:myResponse]];
    
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
    
    [report1Texts insertObject:@"" atIndex:0];
    [report2Texts insertObject:@"" atIndex:0];
    [report3Texts insertObject:@"" atIndex:0];
    [report1 addObject:@""];
    [report2 addObject:@""];
    [report3 addObject:@""];

    [self preparePickerControl];
    self->barPlot = [[CSBarGraphHandler alloc] initWithHostingView:barGraphHostingView andData:[self getDataArrayFromReport:report1] andxAxisTexts:report1Texts andPlotData:[self getDataArrayFromReport:budget1]];
    [self->barPlot initialisePlot];
    
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
    [report1Texts removeAllObjects];
    [report2Texts removeAllObjects];
    [report3Texts removeAllObjects];
}

-(void)preparePickerControl{
    [pickerView setHidden:NO];
    [pickerView reloadAllComponents];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [pickerView setHidden:YES];
//    CGRect tempFrame = pickerView.frame;
//    tempFrame.size.height = 170;
//    [pickerView setFrame:tempFrame];

    [self getItemSaleDataFromSAP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
