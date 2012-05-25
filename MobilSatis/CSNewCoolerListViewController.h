//
//  CSNewCoolerListViewController.h
//  CrmServis
//
//  Created by ABH on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import "CSNewCoolerList.h"
#import "CSTowerAndSpoutSelectionViewController.h"
@interface CSNewCoolerListViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ABHSAPHandlerDelegate>{
    IBOutlet UITableView *tableView;
    NSString *selectedProcess;
    NSMutableArray *coolers;
    CSCustomer *customer;
    CSCooler *selectedCooler;
}
-(id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*) selectedCustomer;
-(void)getCoolers;
-(void)filterCoolers;
@end
