//
//  CSDealerListViewController.h
//  CrmServis
//
//  Created by ABH on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSDealer.h"
#import "CSCustomer.h"

@interface CSDealerListViewController : CSBaseViewController<UITableViewDataSource,UITableViewDataSource,ABHSAPHandlerDelegate>{
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UIImage *image;
    BOOL isNewDealerOrCustomerAvailable;
}

@property (nonatomic, retain) UIImage *image;

- (void)getDealersFromSap;
- (void)initDealerFromResponse:(NSString*)response;
- (void)initCustomerFromResponse:(NSString*)response;
- (CSCustomer*)convertDealerToCustomer:(CSDealer*)aDealer;
- (void)addFakeCustomer:(CSCustomer*)aFakeCustomer ToCustomerList:(NSMutableArray*)customerList;
@end
