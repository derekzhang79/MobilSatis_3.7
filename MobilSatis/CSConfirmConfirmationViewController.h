//
//  CSConfirmConfirmationViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSConfirmation.h"
#import "CSCooler.h"
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
#import "ABHConnectionInfo.h"
#import "CSBaseViewController.h"
@protocol CSConfirmConfirmationViewControllerDelegate;
@interface CSConfirmConfirmationViewController : CSBaseViewController<ABHSAPHandlerDelegate,UIAlertViewDelegate>{
    CSConfirmation *myConfirmation;
    IBOutlet UILabel *confirmationNumber;
    IBOutlet UILabel *customerName;
    IBOutlet UITableView *myTableView;
    NSString *selectedProcess;
     id<CSConfirmConfirmationViewControllerDelegate>delegate;
}
@property (nonatomic,retain)CSConfirmation *myConfirmation;
@property (nonatomic,retain)id<CSConfirmConfirmationViewControllerDelegate>delegate;
-(id)initWithConfirmation:(CSConfirmation*)aConfirmation;
-(id)initWithConfirmation:(CSConfirmation*)aConfirmation andItems:(NSMutableArray*)myItems;
-(IBAction)confirmConfirmation:(id)sender;
-(IBAction)cancelConfirmation;
-(IBAction)showActivityReason;
-(void)confirmConfirmationFromSap;
-(void)cancelConfirmationFromSap;
@end

@protocol CSConfirmConfirmationViewControllerDelegate
-(void)removeConfirmation:(CSConfirmation*)aConfirmation;
@end
