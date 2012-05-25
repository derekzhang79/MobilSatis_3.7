//
//  CSConfirmationSelectionViewController.h
//  CrmServisPrototype
//
//  Created by alp keser on 12/17/11.
//  Copyright (c) 2011 sabanci university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSUser.h"
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
@interface CSConfirmationSelectionViewController : CSBaseViewController<ABHSAPHandlerDelegate,UITableViewDataSource,UITabBarControllerDelegate>{
    IBOutlet UITextField *confirmationNumberField;

    NSMutableArray *confirmations;
}


@property (nonatomic,retain)CSUser *user;
@property (nonatomic,retain)NSMutableArray *confirmations;
-(id)initWithUser:(CSUser*)myUser;
-(IBAction)listMyConfirmations:(id)sender;
-(void)refreshConfirmations;
-(void)initConfirmationsWithNumbers:(NSMutableArray*)myNumbers;
-(void)initConfirmationsWithNumbers:(NSMutableArray*)myNumbers andCustomerNames:(NSMutableArray*)myCustomerNames;
@end
