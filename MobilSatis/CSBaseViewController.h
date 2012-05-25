//
//  CSBaseViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSUser.h"
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
#import "ABHConnectionInfo.h"
typedef enum { offline,online } CSProcessType;
typedef enum { acik,kapali,biraSokagi } CSCustomerType;
@interface CSBaseViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate>{
    CSUser *user;
//    IBOutlet UIActivityIndicatorView *activityIndicator;
    UIImageView *animationView;
    BOOL *isAnimationRunning;
   
}
@property (nonatomic,retain) CSUser *user;
-(id)initWithUser:(CSUser*)myUser;
- (BOOL)isFieldEmpty:(UITextField *)field;
- (BOOL)isNumber:(UITextField *)field;
- (void)playAnimationOnView:(UIView*)myView;
- (void)stopAnimationOnView;
- (BOOL)isAnimationRunning;

@end
