//
//  CSRegisterUserViewController.h
//  CrmServis
//
//  Created by ABH on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
@interface CSRegisterUserViewController : CSBaseViewController<UIAlertViewDelegate>{
    IBOutlet UITextField *mailField;
    IBOutlet UILabel *welcomeLabel;
}
-(IBAction)saveMail:(id)sender;
-(void)updateUserInSap;
- (IBAction)makeKeyboardGoAway;
@end
