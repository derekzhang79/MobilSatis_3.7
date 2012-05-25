//
//  CSLoginViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSUser.h"
#import "ABHSAPHandler.h"
#import "CSNewCoolerList.h"
#import "CSTowerAndSpoutList.h"
#import "CSPasswordChangeViewController.h"
#import "CSLoctionHandlerViewController.h"
@interface CSLoginViewController : CSBaseViewController<UINavigationControllerDelegate,ABHSAPHandlerDelegate>{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *infoButton;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *passwordLabel;
    

}

@property (nonatomic, retain)UITextField *username;
@property (nonatomic, retain)UITextField *password;
-(IBAction)login;
-(IBAction)showInfo;
-(BOOL)loginToSAPWithUserName:(NSString*)myUserName andPassword:(NSString*)myPassword;
-(BOOL)checkUserRegisterationWithResponse:(NSString*)myResponse;
- (IBAction)makeKeyboardGoAway;
-(IBAction)changeUserPassword:(id)sender;
@end

@protocol LoginDelegate<NSObject>

@end
