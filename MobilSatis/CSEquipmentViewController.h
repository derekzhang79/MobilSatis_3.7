//
//  CSEquipmentViewController.h
//  MobilSatis
//
//  Created by ABH on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
@interface CSEquipmentViewController : CSBaseViewController<ABHSAPHandlerDelegate>{
    IBOutlet UISegmentedControl *efesOtherSegmentControl;
    CSCustomer *customer;
    NSMutableArray *coolers;
    
    
}
- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer;
- (IBAction)refreshData;
- (IBAction)segmentTapped:(id)sender;
- (void)getCoolersFromSap;

@end
