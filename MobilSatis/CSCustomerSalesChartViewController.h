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
@interface CSCustomerSalesChartViewController : CSBaseViewController{
    IBOutlet CPTGraphHostingView *barGraphHostingView;
    IBOutlet CPTGraphHostingView *sixMonthGraphHostingView;
    IBOutlet UISegmentedControl *segmentedControl;
    CSBarGraphHandler *barPlot;
    CSBarGraphHandler *sixMonthGraphHandler;
    NSMutableArray *lastMonthData;
    NSMutableArray *sixMonthData;
    CSCustomer *customer;
}
- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer;
- (void)getSalesData;
- (void)initLastMonth;
- (void)initLastSixMonths;

@end
