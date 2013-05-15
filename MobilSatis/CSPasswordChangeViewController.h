//
//  CSPasswordChangeViewController.h
//  CrmServis
//
//  Created by ABH on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
@interface CSPasswordChangeViewController : CSBaseViewController{
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *oldPasswordTextField;
    IBOutlet UITextField *newPasswordTextField;
    IBOutlet UITextField *newPasswordTextField2;
    IBOutlet UILabel *usernameLabelField;
    IBOutlet UILabel *oldPasswordLabelField;
    IBOutlet UILabel *newPasswordLabelField;
    IBOutlet UILabel *newPasswordLabelField2;
    
}

-(void)changePasswordFromSap;
-(BOOL)checkDataOnScreen;
- (IBAction)makeKeyboardGoAway;
@end
