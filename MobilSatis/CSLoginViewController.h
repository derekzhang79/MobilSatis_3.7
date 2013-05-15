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

@interface CSLoginViewController : CSBaseViewController<UINavigationControllerDelegate,ABHSAPHandlerDelegate, UITextFieldDelegate>{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *infoButton;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *passwordLabel;
    UITextField *activeField;
    CDOUser *loginEntity;
}

@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) NSMutableArray *crmServerIpList;
@property (nonatomic, retain) NSMutableArray *crmSystemNumberList;
@property (nonatomic, retain) CDOUser *loginEntity;
@property int crmServerIpCount;
@property int crmSystemNumberCount;
@property (nonatomic, retain) NSString *isAdmin;

-(IBAction)login;
-(IBAction)showInfo;
-(IBAction)forgotMyPassword;
-(BOOL)loginToSAPWithUserName:(NSString*)myUserName andPassword:(NSString*)myPassword;
-(BOOL)checkUserRegisterationWithResponse:(NSString*)myResponse;
- (IBAction)makeKeyboardGoAway;
-(IBAction)changeUserPassword:(id)sender;
- (void)downloadUpdatedApp;
@end

@protocol LoginDelegate<NSObject>

@end
