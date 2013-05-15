//
//  CSCustomerSalesChartViewController.h
//  MobilSatis
//
//  Created by ABH on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "CSBarGraphHandler.h"
#import "CSCustomer.h"

@interface CSCustomerSalesChartViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet CPTGraphHostingView *barGraphHostingView;
    IBOutlet CPTGraphHostingView *sixMonthGraphHostingView;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIImageView *backgroundImage;
    CSBarGraphHandler *barPlot;
    CSBarGraphHandler *sixMonthGraphHandler;
    NSMutableArray *lastMonthData;
    NSMutableArray *sixMonthData;
    NSMutableArray *sixMonthTexts; 
    NSMutableArray *lastMonthTexts;
    CSCustomer *customer;
    IBOutlet UITableView *table;
    NSString *lastYearSale;
    NSString *thisYearSale;
    CGRect oldNavFrame;
}
@property (nonatomic, retain) NSString *lastYearSale;
@property (nonatomic, retain) NSString *thisYearSale;

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer;
- (void)getSalesData;
- (void)initLastMonth;
- (void)initLastSixMonths;

@end
