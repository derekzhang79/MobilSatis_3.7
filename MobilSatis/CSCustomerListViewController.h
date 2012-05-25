//
//  CSCustomerListViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCustomer.h"
#import "CSBaseViewController.h"
@protocol CSCustomerListViewControllerDelegate;
@interface CSCustomerListViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    NSMutableArray *customers;
    NSMutableArray  *filteredListContent;
    NSString        *savedSearchTerm;
}
-(id)initWithCustomers:(NSMutableArray*)myCustomers andUser:(CSUser*)myUser;
@end

@protocol CSCustomerListViewControllerDelegate <NSObject>

- (void)selectedCustomer:(CSCustomer*)myCustomer;
- (BOOL)isDealer:(CSCustomer*)aCustomer;

@end
