//
//  ConfirmationListViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABHSAPHandler.h"
#import "CSUser.h"
#import "CSConfirmation.h"
#import "ABHConnectionInfo.h"
#import "CSConfirmConfirmationViewController.h"
#import "CSBaseViewController.h"
@interface CSConfirmationListViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate,ABHSAPHandlerDelegate,CSConfirmConfirmationViewControllerDelegate>{
    IBOutlet UITableView *myTableView;
    IBOutlet UILabel *welcomeLabel;
    NSMutableArray *confirmations;
//    CSUser *user;
    CSConfirmation *selectedConfirmation;
}
@property (nonatomic,retain) CSUser *user;
-(id)initWithUser:(CSUser*)myUser;
-(id)initWithUser:(CSUser*)myUser andConfirmations:(NSMutableArray*)confirmations;
-(IBAction)refreshConfirmations;
-(void)initConfirmationsWithNumbers:(NSMutableArray*)myNumbers;
-(void)initConfirmationsWithNumbers:(NSMutableArray*)myNumbers andCustomerNames:(NSMutableArray*)myCustomerNames;
@end
