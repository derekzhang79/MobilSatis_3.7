//
//  CSTakeAwayDetailViewController.h
//  CrmServis
//
//  Created by ABH on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
@interface CSTakeAwayDetailViewController : CSBaseViewController<UIAlertViewDelegate,UITextViewDelegate>{
    CSCustomer *customer;
    IBOutlet UITextView *textView;
    BOOL *isStandartText;
}
@property (nonatomic ,retain) UITextView *textView;
-(id)initWithCustomer:(CSCustomer*)aCustomer andUser:(CSUser *)myUser;
-(IBAction)sendTakeAwayToSap:(id)sender;
-(BOOL)checkFailureDescription;
-(IBAction)ignoreKeyboard;


@end
