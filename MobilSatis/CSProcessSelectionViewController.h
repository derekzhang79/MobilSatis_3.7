//
//  CSProcessSelectionViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCustomer.h"
#import "CSUser.h"
#import "CSBaseViewController.h"
#import "ABHSAPHandler.h"
#import "CSNewCoolerListViewController.h"

@interface CSProcessSelectionViewController : CSBaseViewController<UIAlertViewDelegate,ABHSAPHandlerDelegate,UIAlertViewDelegate>{
    
    CSCustomer *customer;
    NSString *selectedProcess;
	CSProcessType *processType;
}


@property (nonatomic,retain)CSCustomer *customer;
@property CSProcessType *processType;

-(id)initWithCustomer:(CSCustomer*)myCustomer andUser:(CSUser*)myUser;
-(IBAction)sendInstallation:(id)sender;
-(IBAction)takeAwayCooler:(id)sender;
-(IBAction)reportFailure:(id)sender;
-(BOOL)checkCustomerForProcess:(NSString*)selectedProcess;
-(void)getCoolersFromSap;
-(void)sendTakeAwayOrderToSap;
-(void)handleTakeAwayResponseFromSap:(NSString*)myResponse;
- (BOOL)isCustomerDealer:(CSCustomer*)aCustomer;



@end
