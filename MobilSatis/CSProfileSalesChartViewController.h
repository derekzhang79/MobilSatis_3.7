//
//  CSProfileSalesChartViewController.h
//  MobilSatis
//
//  Created by alp keser on 9/17/12.
//
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "CSBarGraphHandler.h"
#import "CSCustomer.h"
#import "CSGraphData.h"

@interface CSProfileSalesChartViewController : CSBaseViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
    IBOutlet CPTGraphHostingView *barGraphHostingView;
    IBOutlet CPTGraphHostingView *sixMonthGraphHostingView;
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIImageView *backgroundImage;
    CSBarGraphHandler *barPlot;
    CSBarGraphHandler *sixMonthGraphHandler;
    NSMutableArray *report1;
    NSMutableArray *budget1;
    NSMutableArray *report1Texts;
    NSMutableArray *report2;
    NSMutableArray *budget2;
    NSMutableArray *report2Texts;
    NSMutableArray *report3;
    NSMutableArray *budget3;
    NSMutableArray *report3Texts;
    NSString *header1;
    NSString *header2;
    NSString *header3;
    NSMutableArray *monthTexts;
    CSCustomer *customer;
    IBOutlet UITableView *table;
    NSString *lastYearSale;
    NSString *thisYearSale;
    CGRect oldNavFrame;
    NSString *beginDate;
    NSString *endDate;
}
@property (nonatomic, retain) NSString *lastYearSale;
@property (nonatomic, retain) NSString *thisYearSale;
//@property (nonatomic,assign)NSMutableArray *report1;
//@property (nonatomic,retain)NSMutableArray *report2;
//@property (nonatomic,retain)NSMutableArray *report3;
- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer;
- (id)initWithUser:(CSUser *)myUser andBeginDate:(NSString*)begin andEndDate:(NSString*)end;
- (void)getSalesData;
- (void)initLastMonth;
- (void)initLastSixMonths;


@end
