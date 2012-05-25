//
//  CSTowerAndSpotSelectionViewController.h
//  CrmServis
//
//  Created by ABH on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCooler.h"
#import "CSBaseViewController.h"
#import "CSTowerAndSpoutList.h"
#import "CSCustomer.h"
@interface CSTowerAndSpoutSelectionViewController : CSBaseViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>{
    CSCooler *selectedCooler;
    NSMutableArray *towers;
    NSMutableArray *spouts;
    IBOutlet UIPickerView *towerPicker;
    IBOutlet UIPickerView * spoutPicker;
    int selectedTowerIndex, selectedSpoutIndex,towerAmount,spoutAmount;
    CSCustomer *customer;
}
-(id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)myCustomer andSelectedCooler:(CSCooler*)myCooler;
-(IBAction)sendInstallationToSap;
@end
