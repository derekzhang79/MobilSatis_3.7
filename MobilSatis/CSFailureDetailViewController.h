//
//  CSFailureDetailViewController.h
//  CrmServis
//
//  Created by ABH on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCooler.h"
#import "CSCustomer.h"
#import "CSBaseViewController.h"
@interface CSFailureDetailViewController : CSBaseViewController<UIAlertViewDelegate,UITextViewDelegate>{
    CSCustomer *customer;
    CSCooler *cooler;
    IBOutlet UITextView *textView;
    BOOL *isStandartText;

    
}
@property (nonatomic ,retain) UITextView *textView;
-(id)initWithCooler:(CSCooler*)aCooler andCustomer:(CSCustomer*)aCustomer andUser:(CSUser*)myUser;
-(IBAction)sendFailureToSap:(id)sender;
-(BOOL)checkFailureDescription;
-(IBAction)ignoreKeyboard;
@end
