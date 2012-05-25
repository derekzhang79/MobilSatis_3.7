//
//  CSVisitDetailViewController.h
//  MobilSatis
//
//  Created by ABH on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
@interface CSVisitDetailViewController : CSBaseViewController<UIAlertViewDelegate,UITextViewDelegate>{
    CSCustomer *customer;
    IBOutlet UITextView *textView;
    BOOL *isStandartText;
    
}

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer;
-(IBAction)ignoreKeyboard;
-(IBAction)checkIn:(id)sender;

@end
