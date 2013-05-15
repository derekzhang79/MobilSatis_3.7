//
//  CSProfileViewController.h
//  MobilSatis
//
//  Created by ABH on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSConfirmationListViewController.h"
#import "CSUserSalesViewController.h"
#import "CSSharePointSafariViewController.h"
#import "CSEfesPilsenCommercialsViewController.h"
#import "CSConnectWithOtherMYKViewController.h"
#import "CSFinancialReportViewController.h"

@interface CSProfileViewController : CSBaseViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ABHSAPHandlerDelegate> {
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UITableView *TableView;
}

@property (nonatomic, retain) UITableView *TableView;
@property (nonatomic, retain) UILabel *welcomeLabel;

- (void)viewConfirmations;
- (void)viewSales;
- (void)startUpCompleted;
@end
