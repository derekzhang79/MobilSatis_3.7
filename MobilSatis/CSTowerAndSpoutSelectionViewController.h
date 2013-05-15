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
#import "CSCoolerCreationViewController.h"

@class CSCoolerCreationViewController;

@interface CSTowerAndSpoutSelectionViewController : CSBaseViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>{
    CSCooler *selectedCooler;
    NSMutableArray *towers;
    NSMutableArray *spouts;
    IBOutlet UIPickerView *towerPicker;
    IBOutlet UIPickerView * spoutPicker;
    int selectedTowerIndex, selectedSpoutIndex,towerAmount,spoutAmount;
    CSCustomer *customer;
    CSCoolerCreationViewController *coolerViewController;
}
@property (nonatomic, retain) CSCoolerCreationViewController *coolerViewController;
@property (nonatomic, retain) CSCooler *selectedCooler;
@property int selectedTowerIndex, selectedSpoutIndex, towerAmount, spoutAmount;
@property CSCustomer *customer;
@property (nonatomic, retain) NSMutableArray *towers;
@property (nonatomic, retain) NSMutableArray *spouts;

-(id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)myCustomer andSelectedCooler:(CSCooler*)myCooler;
-(IBAction)sendInstallationToSap;
@end
