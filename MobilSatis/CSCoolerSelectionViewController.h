//
//  CSCoolerSelectionViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import "CSCooler.h"
@interface CSCoolerSelectionViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    CSCustomer *customer;
    IBOutlet UITableView *tableView;
    NSString *selectedProcess;
}

@property (nonatomic,retain)CSCustomer *customer;
-(id)initWithCustomer:(CSCustomer*)aCustomer andUser:(CSUser*)myUser andProcess:(NSString*)process;
-(void)initCoolersWithResponse:(NSString*)response;
@end
