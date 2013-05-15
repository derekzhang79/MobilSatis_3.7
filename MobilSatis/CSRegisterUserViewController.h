//
//  CSRegisterUserViewController.h
//  CrmServis
//
//  Created by ABH on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
@interface CSRegisterUserViewController : CSBaseViewController <UIAlertViewDelegate, ABHSAPHandlerDelegate, UIScrollViewDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *mykUserField;
    IBOutlet UITextField *mykPasswordField;
    IBOutlet UITextField *sapUserField;
    IBOutlet UITextField *sapPasswordField;
    
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UIScrollView *scrollView;
    UITextField *activeField;
}

-(void)sendUserDataToSAP:(id)sender;
-(void)updateUserInSap;
- (IBAction)makeKeyboardGoAway;

@end
