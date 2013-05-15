//
//  CSUserSalesViewController.m
//  MobilSatis
//
//  Created by ABH on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSUserSalesViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface CSUserSalesViewController ()

@end

@implementation CSUserSalesViewController
@synthesize saleMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{
    self = [super init];
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return self;
}


- (void)getSalesDataOfUser:(CSUser*)aUser{
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZEYONETICI_MYK_BAZINDA_RAPOR2"];
     [sapHandler addImportWithKey:@"PERSONEL_MYK" andValue:[user username]];
    //aUser.username
    [sapHandler addImportWithKey:@"SORGU_BASLANGIC" andValue:[self getFirstDay]];
    [sapHandler addImportWithKey:@"SORGU_BITIS" andValue:[self getLastDay]];
    //20120501 -- 20120531
    
    NSString *tableName = [NSString stringWithFormat:@"TABLO1"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"FIILI_GECMIS"];
    [columns addObject:@"FIILI_GUNCEL"];
    [columns addObject:@"GELISME"];
    [columns addObject:@"BUTCE"];
    [columns addObject:@"ORAN_GERC_BUTCE"];
    [columns addObject:@"LINE_KEY"];
    
    [sapHandler addTableWithName:tableName andColumns:columns];
     tableName = [NSString stringWithFormat:@"TABLO2"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    tableName = [NSString stringWithFormat:@"TABLO3"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    tableName = [NSString stringWithFormat:@"TABLO4"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [super playAnimationOnView:self.view];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
}
-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    [super stopAnimationOnView];
    [self refreshAll];
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        report1 = [[NSMutableArray alloc] init];
        report2 = [[NSMutableArray alloc] init];
        report3 = [[NSMutableArray alloc] init];
        projection1 = [[NSMutableArray alloc] init];
        
        NSArray *eventsArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
        NSArray *report1Array;
        NSArray *report2Array;
        NSArray *report3Array;
        NSArray *projection1Array;
        CDOUser *userLogin;
        
        if ([eventsArray count] > 0)
        {
            userLogin = (CDOUser *)[eventsArray objectAtIndex:0];
            report1Array = [[[userLogin userSaleData] saleReport1] allObjects];
            report2Array = [[[userLogin userSaleData] saleReport2] allObjects];
            report3Array = [[[userLogin userSaleData] saleReport3] allObjects];
            projection1Array = [[[userLogin userSaleData] saleReport4] allObjects];
        }
        
        for (CDOSaleData *temp in report1Array) {
            CSUserSaleData *tempSaleData = [[CSUserSaleData alloc] initWithCategory:[temp category] andLabel:[temp label] andActualHistory:[temp actualHistory] andCurrent:[temp actualCurrent] andDevelopment:[temp development] andBudget:[temp budget] andCurrentRate:[temp currentRate] andLineKey:[temp lineKey]];
            [self generateLeftAmountForSaleData:tempSaleData];
            [report1 addObject:tempSaleData];
        }
        
        for (CDOSaleData *temp in report2Array) {
            CSUserSaleData *tempSaleData = [[CSUserSaleData alloc] initWithCategory:[temp category] andLabel:[temp label] andActualHistory:[temp actualHistory] andCurrent:[temp actualCurrent] andDevelopment:[temp development] andBudget:[temp budget] andCurrentRate:[temp currentRate] andLineKey:[temp lineKey]];
            [self generateLeftAmountForSaleData:tempSaleData];
            [report2 addObject:tempSaleData];
        }
        
        for (CDOSaleData *temp in report3Array) {
            CSUserSaleData *tempSaleData = [[CSUserSaleData alloc] initWithCategory:[temp category] andLabel:[temp label] andActualHistory:[temp actualHistory] andCurrent:[temp actualCurrent] andDevelopment:[temp development] andBudget:[temp budget] andCurrentRate:[temp currentRate] andLineKey:[temp lineKey]];
            [self generateLeftAmountForSaleData:tempSaleData];
            [report3 addObject:tempSaleData];
        }
        
    for (CDOSaleData *temp in projection1Array) {
        CSUserSaleData *tempSaleData = [[CSUserSaleData alloc] initWithCategory:[temp category] andLabel:[temp label] andActualHistory:nil andCurrent:[temp actualCurrent] andDevelopment:[temp development] andBudget:[temp budget] andCurrentRate:[temp currentRate] andLineKey:nil];
        [projection1 addObject:tempSaleData];
    }
        
        titles = [[NSMutableArray alloc] init];
        [titles addObject:[[userLogin userSaleData] saleTitle1]];
        [titles addObject:[[userLogin userSaleData] saleTitle2]];
        [titles addObject:[[userLogin userSaleData] saleTitle3]];
        [titles addObject:[[userLogin userSaleData] saleTitle4]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Açıklama" message:[[userLogin userSaleData] saleMessage] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        
        [table reloadData];
    }
    else
    {
        [self showMessageFromResponses:[ABHXMLHelper getValuesWithTag:@"MESSAGE" fromEnvelope:myResponse]];
        [self parseResponseFromReports:[ABHXMLHelper getValuesWithTag:@"ZEYONETICI_RAPOR_TABLO" fromEnvelope:myResponse] andProjections:[ABHXMLHelper getValuesWithTag:@"ZEYONETICI_TAHMIN_TABLO" fromEnvelope:myResponse]];
        [self getTitlesFormEnvelope:myResponse];
        [table reloadData];
    }
}
-(void) showMessageFromResponses:(NSMutableArray*)responses{
    
    saleMessage = [responses objectAtIndex:0];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Açıklama" message:[responses objectAtIndex:0] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
    [alert show];
}
-(void) parseResponseFromReports:(NSMutableArray*)reports andProjections:(NSMutableArray*)projections{
//    NSMutableArray *
    report1 = [[NSMutableArray alloc] init];
    report2 = [[NSMutableArray alloc] init];
    report3 = [[NSMutableArray alloc] init];
    projection1 = [[NSMutableArray alloc] init];
    
    NSMutableArray *categories;
    NSMutableArray *labels;
    NSMutableArray *actualHistories;
    NSMutableArray *actualCurrents;
    NSMutableArray *developments;
    NSMutableArray *budgets;
    NSMutableArray *currentRate;
    NSMutableArray *lineKey;
    CSUserSaleData *tempSaleData = [[CSUserSaleData alloc] init];
    for (int sayac = 0; sayac<reports.count; sayac++) {
        switch (sayac) {
            case 0:
                categories = [ABHXMLHelper getValuesWithTag:@"KATEGORI" fromEnvelope:[reports objectAtIndex:sayac]];
                labels = [ABHXMLHelper getValuesWithTag:@"ETIKET" fromEnvelope:[reports objectAtIndex:sayac]];
                actualHistories = [ABHXMLHelper getValuesWithTag:@"FIILI_GECMIS" fromEnvelope:[reports objectAtIndex:sayac]];
                actualCurrents = [ABHXMLHelper getValuesWithTag:@"FIILI_GUNCEL" fromEnvelope:[reports objectAtIndex:sayac]];
                developments = [ABHXMLHelper getValuesWithTag:@"GELISME" fromEnvelope:[reports objectAtIndex:sayac]];
                budgets = [ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:[reports objectAtIndex:sayac]];
                currentRate = [ABHXMLHelper getValuesWithTag:@"ORAN_GERC_BUTCE" fromEnvelope:[reports objectAtIndex:sayac]];
                lineKey = [ABHXMLHelper getValuesWithTag:@"LINEKEY" fromEnvelope:[reports objectAtIndex:sayac]];
                for (int sayac2 = 0; sayac2<categories.count; sayac2++) {
                    tempSaleData = [[CSUserSaleData alloc] initWithCategory:[categories objectAtIndex:sayac2] andLabel:[labels objectAtIndex:sayac2] andActualHistory:[ABHXMLHelper correctNumberValue:[actualHistories objectAtIndex:sayac2]] andCurrent:[ABHXMLHelper correctNumberValue:[actualCurrents objectAtIndex:sayac2]] andDevelopment:[ABHXMLHelper correctNumberValue:[developments objectAtIndex:sayac2]] andBudget:[ABHXMLHelper correctNumberValue:[budgets objectAtIndex:sayac2]] andCurrentRate:[ABHXMLHelper correctNumberValue:[currentRate objectAtIndex:sayac2]] andLineKey:[lineKey objectAtIndex:sayac2]];
                    [self generateLeftAmountForSaleData:tempSaleData];
                    [report1 addObject:tempSaleData];
                }
                
                break;
            case 1:
                categories = [ABHXMLHelper getValuesWithTag:@"KATEGORI" fromEnvelope:[reports objectAtIndex:sayac]];
                labels = [ABHXMLHelper getValuesWithTag:@"ETIKET" fromEnvelope:[reports objectAtIndex:sayac]];
                actualHistories = [ABHXMLHelper getValuesWithTag:@"FIILI_GECMIS" fromEnvelope:[reports objectAtIndex:sayac]];
                actualCurrents = [ABHXMLHelper getValuesWithTag:@"FIILI_GUNCEL" fromEnvelope:[reports objectAtIndex:sayac]];
                developments = [ABHXMLHelper getValuesWithTag:@"GELISME" fromEnvelope:[reports objectAtIndex:sayac]];
                budgets = [ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:[reports objectAtIndex:sayac]];
                currentRate = [ABHXMLHelper getValuesWithTag:@"ORAN_GERC_BUTCE" fromEnvelope:[reports objectAtIndex:sayac]];
                lineKey = [ABHXMLHelper getValuesWithTag:@"LINEKEY" fromEnvelope:[reports objectAtIndex:sayac]];
                for (int sayac2 = 0; sayac2<categories.count; sayac2++) {
                    tempSaleData = [[CSUserSaleData alloc] initWithCategory:[categories objectAtIndex:sayac2] andLabel:[labels objectAtIndex:sayac2] andActualHistory:[ABHXMLHelper correctNumberValue:[actualHistories objectAtIndex:sayac2]] andCurrent:[ABHXMLHelper correctNumberValue:[actualCurrents objectAtIndex:sayac2]] andDevelopment:[ABHXMLHelper correctNumberValue:[developments objectAtIndex:sayac2]] andBudget:[ABHXMLHelper correctNumberValue:[budgets objectAtIndex:sayac2]] andCurrentRate:[ABHXMLHelper correctNumberValue:[currentRate objectAtIndex:sayac2]] andLineKey:[lineKey objectAtIndex:sayac2]];
                    [self generateLeftAmountForSaleData:tempSaleData];
                   
                    [report2 addObject:tempSaleData];
                }
                
                break;
            case 2:
                categories = [ABHXMLHelper getValuesWithTag:@"KATEGORI" fromEnvelope:[reports objectAtIndex:sayac]];
                labels = [ABHXMLHelper getValuesWithTag:@"ETIKET" fromEnvelope:[reports objectAtIndex:sayac]];
                actualHistories = [ABHXMLHelper getValuesWithTag:@"FIILI_GECMIS" fromEnvelope:[reports objectAtIndex:sayac]];
                actualCurrents = [ABHXMLHelper getValuesWithTag:@"FIILI_GUNCEL" fromEnvelope:[reports objectAtIndex:sayac]];
                developments = [ABHXMLHelper getValuesWithTag:@"GELISME" fromEnvelope:[reports objectAtIndex:sayac]];
                budgets = [ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:[reports objectAtIndex:sayac]];
                currentRate = [ABHXMLHelper getValuesWithTag:@"ORAN_GERC_BUTCE" fromEnvelope:[reports objectAtIndex:sayac]];
                lineKey = [ABHXMLHelper getValuesWithTag:@"LINEKEY" fromEnvelope:[reports objectAtIndex:sayac]];
                for (int sayac2 = 0; sayac2<categories.count; sayac2++) {
                    tempSaleData = [[CSUserSaleData alloc] initWithCategory:[categories objectAtIndex:sayac2] andLabel:[labels objectAtIndex:sayac2] andActualHistory:[ABHXMLHelper correctNumberValue:[actualHistories objectAtIndex:sayac2]] andCurrent:[ABHXMLHelper correctNumberValue:[actualCurrents objectAtIndex:sayac2]] andDevelopment:[ABHXMLHelper correctNumberValue:[developments objectAtIndex:sayac2]] andBudget:[ABHXMLHelper correctNumberValue:[budgets objectAtIndex:sayac2]] andCurrentRate:[ABHXMLHelper correctNumberValue:[currentRate objectAtIndex:sayac2]] andLineKey:[lineKey objectAtIndex:sayac2]];
                     [self generateLeftAmountForSaleData:tempSaleData];
                    [report3    addObject:tempSaleData];
                }
                break;
            case 3:
             
                break;
                
            default:
                break;
        }
        
    }

    for (int sayac = 0; sayac < projections.count; sayac++) {
        categories = [ABHXMLHelper getValuesWithTag:@"KATEGORI" fromEnvelope:[projections objectAtIndex:sayac]];
        labels = [ABHXMLHelper getValuesWithTag:@"ETIKET" fromEnvelope:[projections objectAtIndex:sayac]];
      //  actualHistories = [ABHXMLHelper getValuesWithTag:@"FIILI_GECMIS" fromEnvelope:[projections objectAtIndex:sayac]];
        actualCurrents = [ABHXMLHelper getValuesWithTag:@"FIILI_GUNCEL" fromEnvelope:[projections objectAtIndex:sayac]];
        developments = [ABHXMLHelper getValuesWithTag:@"GEREKEN" fromEnvelope:[projections objectAtIndex:sayac]];
        //budgets = [ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:[projections objectAtIndex:sayac]];
        currentRate = [ABHXMLHelper getValuesWithTag:@"ORAN_GERC_GEREK" fromEnvelope:[projections objectAtIndex:sayac]]; 
        
    }
    for (int sayac2 = 0; sayac2<categories.count; sayac2++) {
        tempSaleData = [[CSUserSaleData alloc] initWithCategory:[categories objectAtIndex:sayac2] andLabel:[labels objectAtIndex:sayac2] andActualHistory:nil andCurrent:[ABHXMLHelper correctNumberValue:[actualCurrents objectAtIndex:sayac2]] andDevelopment:[ABHXMLHelper correctNumberValue:[developments objectAtIndex:sayac2]] andBudget:nil andCurrentRate:[ABHXMLHelper correctNumberValue:[currentRate objectAtIndex:sayac2]] andLineKey:nil];
        [projection1 addObject:tempSaleData];
    }
    
}
- (void)getTitlesFormEnvelope:(NSString*)envelope{
    titles = [[NSMutableArray alloc] init];
    [titles addObject:[[ABHXMLHelper getValuesWithTag:@"TABLO1_BASLIK" fromEnvelope:envelope] objectAtIndex:0]];
    [titles addObject:[[ABHXMLHelper getValuesWithTag:@"TABLO2_BASLIK" fromEnvelope:envelope] objectAtIndex:0]];
    [titles addObject:[[ABHXMLHelper getValuesWithTag:@"TABLO3_BASLIK" fromEnvelope:envelope] objectAtIndex:0]];
    [titles addObject:[[ABHXMLHelper getValuesWithTag:@"TABLO4_BASLIK" fromEnvelope:envelope] objectAtIndex:0]];
    
    [self checkExistingCoreDataToDelete];
    [self addUserSaleDataToCoreData];
}


#pragma mark - Core Data methods

- (void)addUserSaleDataToCoreData {
    
    NSArray *eventsArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
    CDOUser *userLogin;
    
    if ([eventsArray count] > 0)
    {
        userLogin = (CDOUser *)[eventsArray objectAtIndex:0];
    }
    
//    if ([userLogin userSaleData] != nil) {
//        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:[userLogin userSaleData], nil];
//        NSManagedObject *eventToDelete = [[CoreDataHandler getManagedObject] objectWithID:[[temp objectAtIndex:0] objectID]];
//        [[CoreDataHandler getManagedObject] deleteObject:eventToDelete];
//    }
    
    CDOUserSaleData *userSaleData = (CDOUserSaleData *)[CoreDataHandler insertEntityData:@"CDOUserSaleData"];
    
    for(CSUserSaleData *temp in report1)
    {
        CDOSaleData *saleTemp = (CDOSaleData *)[CoreDataHandler insertEntityData:@"CDOSaleData"];
        [saleTemp setActualCurrent:[temp actualCurrent]];
        [saleTemp setActualHistory:[temp actualHistory]];
        [saleTemp setBudget:[temp budget]];
        [saleTemp setCategory:[temp categroy]];
        [saleTemp setCurrentRate:[temp currentRate]];
        [saleTemp setDevelopment:[temp development]];
        [saleTemp setLabel:[temp label]];
        [saleTemp setLeftAmount:[temp leftAmount]];
        [saleTemp setLineKey:[temp lineKey]];
        
        [userSaleData addSaleReport1Object:saleTemp];
    }
    
    [userSaleData setSaleTitle1:[titles objectAtIndex:0]];
    
    for(CSUserSaleData *temp in report2)
    {
        CDOSaleData *saleTemp = (CDOSaleData *)[CoreDataHandler insertEntityData:@"CDOSaleData"];
        [saleTemp setActualCurrent:[temp actualCurrent]];
        [saleTemp setActualHistory:[temp actualHistory]];
        [saleTemp setBudget:[temp budget]];
        [saleTemp setCategory:[temp categroy]];
        [saleTemp setCurrentRate:[temp currentRate]];
        [saleTemp setDevelopment:[temp development]];
        [saleTemp setLabel:[temp label]];
        [saleTemp setLeftAmount:[temp leftAmount]];
        [saleTemp setLineKey:[temp lineKey]];
        
        [userSaleData addSaleReport2Object:saleTemp];
    }
    
    [userSaleData setSaleTitle2:[titles objectAtIndex:1]];
    
    for(CSUserSaleData *temp in report3)
    {
        CDOSaleData *saleTemp = (CDOSaleData *)[CoreDataHandler insertEntityData:@"CDOSaleData"];
        [saleTemp setActualCurrent:[temp actualCurrent]];
        [saleTemp setActualHistory:[temp actualHistory]];
        [saleTemp setBudget:[temp budget]];
        [saleTemp setCategory:[temp categroy]];
        [saleTemp setCurrentRate:[temp currentRate]];
        [saleTemp setDevelopment:[temp development]];
        [saleTemp setLabel:[temp label]];
        [saleTemp setLeftAmount:[temp leftAmount]];
        [saleTemp setLineKey:[temp lineKey]];
        
        [userSaleData addSaleReport3Object:saleTemp];
    }
    
    [userSaleData setSaleTitle3:[titles objectAtIndex:2]];
    
    for(CSUserSaleData *temp in projection1)
    {
        CDOSaleData *saleTemp = (CDOSaleData *)[CoreDataHandler insertEntityData:@"CDOSaleData"];
        [saleTemp setActualCurrent:[temp actualCurrent]];
        [saleTemp setActualHistory:[temp actualHistory]];
        [saleTemp setBudget:[temp budget]];
        [saleTemp setCategory:[temp categroy]];
        [saleTemp setCurrentRate:[temp currentRate]];
        [saleTemp setDevelopment:[temp development]];
        [saleTemp setLabel:[temp label]];
        [saleTemp setLeftAmount:[temp leftAmount]];
        [saleTemp setLineKey:[temp lineKey]];
        
        [userSaleData addSaleReport4Object:saleTemp];
    }
    
    [userSaleData setSaleTitle4:[titles objectAtIndex:3]];
    [userSaleData setSaleMessage:saleMessage];
    
    CDOUser *userLog = (CDOUser *)[CoreDataHandler insertExistingEntityData:@"CDOUser" andValueForSort:@"username"];
    [userLog setUserSaleData:userSaleData];
    
    [CoreDataHandler saveEntityData];
}

- (void)checkExistingCoreDataToDelete {
    
    NSArray *userSaleArray = [CoreDataHandler fetchExistingEntityData:@"CDOUserSaleData" sortingParameter:@"saleTitle1" objectContext:[CoreDataHandler getManagedObject]];
    
    for (CDOUserSaleData *temp in userSaleArray) {
        [[CoreDataHandler getManagedObject] deleteObject:temp];
    }
    
    NSArray *userArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
    CDOUser *userLog;
    
    if( [userArray count] > 0)
        userLog = [userArray objectAtIndex:0];
    
    [userLog setUserSaleData:nil];
    
    [CoreDataHandler saveEntityData];
}

- (NSString*)getFirstDayOfMonth:(int)monthNo{
    NSDate *curDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange =
    [currentCalendar
     rangeOfUnit:NSDayCalendarUnit
     inUnit:NSMonthCalendarUnit
     forDate:curDate];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *log =  [NSString stringWithFormat:@"%d%@01",components.year,[self correctDateComponent:monthNo]];
    return [NSString stringWithFormat:@"%d%@01",components.year,[self correctDateComponent:monthNo]];
}

- (NSString*)getFirstDay{
    NSDate *curDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange = 
    [currentCalendar 
     rangeOfUnit:NSDayCalendarUnit 
     inUnit:NSMonthCalendarUnit 
     forDate:curDate];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    
    return [NSString stringWithFormat:@"%d%@01",components.year,[self correctDateComponent:components.month]];
}

-(NSString*)getLastDayOfMonth:(int)monthNo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@%@01", yearString, [self correctDateComponent:monthNo]];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *curDate = [dateFormat dateFromString:dateStr];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange =
    [currentCalendar
     rangeOfUnit:NSDayCalendarUnit
     inUnit:NSMonthCalendarUnit
     forDate:curDate];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
        NSString *log =[ NSString stringWithFormat:@"%d%i%@",components.year,monthNo,[self correctDateComponent:daysRange.length]];
    return [NSString stringWithFormat:@"%d%@%@",components.year,[self correctDateComponent:monthNo],[self correctDateComponent:daysRange.length]];
}

-(NSString*)getLastDay{
    NSDate *curDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange = 
    [currentCalendar 
     rangeOfUnit:NSDayCalendarUnit 
     inUnit:NSMonthCalendarUnit 
     forDate:curDate];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    
    return [NSString stringWithFormat:@"%d%@%@",components.year,[self correctDateComponent:components.month],[self correctDateComponent:daysRange.length]];
}
- (NSString*)findTotalCurrentRateFromArray:(NSMutableArray*)anArray{
    CSUserSaleData *tempSaleTempData;
    for (int sayac = 0; sayac<anArray.count ; sayac++) {
        tempSaleTempData = [anArray objectAtIndex:sayac];
        if ([tempSaleTempData.label rangeOfString:@"Toplam"].location != NSNotFound) {
            return tempSaleTempData.currentRate;
        }
    }
    return @"Bulunamadı";
}
- (NSUInteger)calculateNumberOfTitles:(NSMutableArray*)titles{
    NSUInteger returnValue=0;
    for (int sayac = 0; sayac<titles.count; sayac++) {
        if (![[titles objectAtIndex:sayac] isEqualToString:@""]) {
            returnValue++;
        }
    }
    return returnValue;
}
- (void)refreshAll{
    [report1 removeAllObjects];
    [report2 removeAllObjects];
    [report3 removeAllObjects];
    [projection1 removeAllObjects];
    [titles removeAllObjects];
    fark = 0;
}

#pragma mark - Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    return  [self calculateNumberOfTitles:titles];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else {
        [[cell detailTextLabel] setText:@""];
        [cell setAccessoryView:nil];
    }
    
    
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    CSUserSaleData *tempSaleData;

    if ([[titles objectAtIndex:indexPath.row]isEqualToString:@""]) {
        fark++;
    }
        cell.textLabel.text = [titles objectAtIndex:indexPath.row+fark];
    
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    
    switch (indexPath.row+fark) {
        case 0:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[self findTotalCurrentRateFromArray:report1]];
            if(cell.detailTextLabel.text == nil)
                [cell.detailTextLabel setText:@"0"];
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[self findTotalCurrentRateFromArray:report2]];
            if(cell.detailTextLabel.text == nil)
                [cell.detailTextLabel setText:@"0"];
            break;
        case 2:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[self findTotalCurrentRateFromArray:report3]];
            if(cell.detailTextLabel.text == nil)
                [cell.detailTextLabel setText:@"0"];
            break;
        case 3:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[self findTotalCurrentRateFromArray:projection1]];
            if(cell.detailTextLabel.text == nil)
                [cell.detailTextLabel setText:@"0"];
            break;
            
        default:
            break;
    }


    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    
        @try {
            return @"Gerçekleşen Oranlarım";
        }
        @catch (NSException *exception) {
            NSLog(@"table viewda neler oluyor?");
            return @"My Title";
        }
        @finally {
             
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int sayac = 0;
    int sayac2 = 0;
    if (indexPath.row == 0 || indexPath.row == [self calculateNumberOfTitles:titles]-1) {
        while (sayac2 < indexPath.row) {            
            @try {
                if (![[titles objectAtIndex:sayac] isEqualToString:@""]) {
                    sayac++; 
                    sayac2++; 
                }  else {
                    sayac++; 
                    
                }
            }
            @catch (NSException *exception) {
                sayac--;                
            }
            
        }
    }else {
        while (sayac2 <= indexPath.row) {            
            @try {
                if (![[titles objectAtIndex:sayac] isEqualToString:@""]) {
                    sayac++; 
                    sayac2++; 
                }  else
                {
                    sayac++; 
                    
                }
            }
            @catch (NSException *exception) {
                sayac--;
            }
        }
          sayac--;
    }
  
    CSUserSalesDetailsViewController *userSalesDetailsViewController;
    switch (sayac) {
        case 0:
            userSalesDetailsViewController = [[CSUserSalesDetailsViewController alloc] initWithUser:user andArray:report1 andTitle:[titles objectAtIndex:sayac] beginDate:[self getFirstDayOfMonth:[myPicker selectedRowInComponent:0]+1] endDate:[self getLastDayOfMonth:[myPicker selectedRowInComponent:1]+1]];
                
            break;
        case 1:
            userSalesDetailsViewController = [[CSUserSalesDetailsViewController alloc] initWithUser:user andArray:report2 andTitle:[titles objectAtIndex:sayac] beginDate:[self getFirstDayOfMonth:[myPicker selectedRowInComponent:0]+1] endDate:[self getLastDayOfMonth:[myPicker selectedRowInComponent:1]+1]];
            break;
        case 2:
            userSalesDetailsViewController = [[CSUserSalesDetailsViewController alloc] initWithUser:user andArray:report3 andTitle:[titles objectAtIndex:sayac] beginDate:[self getFirstDayOfMonth:[myPicker selectedRowInComponent:0]+1] endDate:[self getLastDayOfMonth:[myPicker selectedRowInComponent:1]+1]];
            break;
        case 3:
            userSalesDetailsViewController = [[CSUserSalesDetailsViewController alloc] initWithUser:user andArray:projection1 andTitle:[titles objectAtIndex:sayac] beginDate:[self getFirstDayOfMonth:[myPicker selectedRowInComponent:0]+1] endDate:[self getLastDayOfMonth:[myPicker selectedRowInComponent:1]+1]];
            break;
            
        default:
            break;
    }
    [[self navigationController] pushViewController:userSalesDetailsViewController animated:YES ];
    
    
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    headerView.layer.cornerRadius = 5;
    headerView.layer.masksToBounds = YES;
    if (section == 0){
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:headerView.frame];
        [tempLabel setText:@"Gerçekleşen Oranlarım"];
        [tempLabel setTextColor:[UIColor whiteColor]];
        [tempLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:tempLabel];
         }
    else 
        [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}
- (void)generateLeftAmountForSaleData:(CSUserSaleData*)tempSaleData{
    if (![tempSaleData.actualCurrent isEqualToString:@""] || ![tempSaleData.budget isEqualToString:@""]) {
        tempSaleData.leftAmount = [NSString stringWithFormat:@"%i",[[numberFormatter numberFromString:tempSaleData.budget] intValue] - [[numberFormatter numberFromString:tempSaleData.actualCurrent] intValue] ];
        [tempSaleData setLeftAmount:[ABHXMLHelper correctNumberValue:tempSaleData.leftAmount]];
      

    }
}
- (BOOL)checkMonths{
    NSDate *date;
    UIAlertView *alert;
    if ([myPicker selectedRowInComponent:0] > [myPicker selectedRowInComponent:1]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Başlangıç ayı bitiş ayından küçük olamaz" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
        [alert show];

        return NO;
    }else{
        date = [NSDate date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        if ([myPicker selectedRowInComponent:1] +1  > components.month) {
            alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Son ay mevcut aydan büyük olamaz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [alert show];
            return NO;

        }
        return YES;
    }
}

-(void)refreshSales{
    if (![self checkMonths]) {
        return;
    }
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZEYONETICI_MYK_BAZINDA_RAPOR2"];
    [sapHandler addImportWithKey:@"PERSONEL_MYK" andValue:[user username]];
    //aUser.username
    [sapHandler addImportWithKey:@"SORGU_BASLANGIC" andValue:[self getFirstDayOfMonth:[myPicker selectedRowInComponent:0]+1]];
    [sapHandler addImportWithKey:@"SORGU_BITIS" andValue:[self getLastDayOfMonth:[myPicker selectedRowInComponent:1]+1]];
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
    tableName = [NSString stringWithFormat:@"TABLO4"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
    
}

-(NSString*)correctDateComponent:(NSInteger)component{
    if (component<10) {
        return [NSString stringWithFormat:@"0%d",component];
    }else {
        return [NSString stringWithFormat:@"%d",component];
    }
}


#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 12;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [CSApplicationHelper getMonthFromNumber:row];
}
- (IBAction)goToChart:(id)sender{
    if ([super isAnimationRunning] || ![self checkMonths]) {
        return;
    }
    
    CSProfileSalesChartViewController *profileSalesChartViewController = [[CSProfileSalesChartViewController alloc] initWithUser:user  andBeginDate:[self getFirstDayOfMonth:[myPicker selectedRowInComponent:0]+1] andEndDate:[self getLastDayOfMonth:[myPicker selectedRowInComponent:1]+1]];
    [[self navigationController] pushViewController:profileSalesChartViewController animated:YES];
}

#pragma mark - view events
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    int month = [components month];
    [myPicker selectRow:month-1 inComponent:0 animated:YES];
    [myPicker selectRow:month-1 inComponent:1 animated:YES];
    CGRect tempFrame = myPicker.frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
    }else{
        //216 dan 
        tempFrame.size.height = 162; //116 dı 
        tempFrame.origin.y += 50;
        myPicker.frame = tempFrame;
    }
    // Do any additional setup after loading the view from its nib.
    //lets call rfc
    fark=0;
    
    [self getSalesDataOfUser:user];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-01.png"]];
    table.backgroundView = image;

    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    CGRect temp = self.navigationController.view.frame;//w320h480
//    CGRect temp2 = self.tabBarController.navigationController.view.frame;//w320h480
//    CGRect temp3 = self.tabBarController.view.frame;
//    if(  [UIApplication sharedApplication].statusBarHidden ) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//            self.navigationController.view.frame = CGRectMake(0,20,768,1044);
//            
//        }else{
//            self.navigationController.view.frame = CGRectMake(0,20,320,500);
//            
//        }
//        
//    }

    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Getir" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshSales)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
    [[self navigationItem] setTitle:@"Satışlarım"];
    //[myTableView reloadData];
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
