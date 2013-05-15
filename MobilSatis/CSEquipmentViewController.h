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
#import "CSFailureDetailViewController.h"


@interface CSEquipmentViewController : CSBaseViewController<ABHSAPHandlerDelegate,UITableViewDataSource,UITableViewDelegate, ZBarReaderDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    
    IBOutlet UISegmentedControl *efesOtherSegmentControl;
    CSCustomer *customer;
    NSMutableArray *coolers;
    NSMutableArray *other_coolers;
    UITableView *table;
    BOOL isEfesActive;
    UIBarButtonItem *barButton;
    UIImageView *resultImage;
    NSString *resultText;
    BOOL isStockTakingActive;
    NSMutableArray *stockTakingArray;
    CSCooler *selectedCooler;
    NSString *barcodeText;
    BOOL isStockTakingTime;
    BOOL isCoolerAddition;
    UITextField *textField;
    NSMutableArray *otherCoolerList;
    UIPickerView *pickerView;
    UIButton *pickerViewButton;
}

@property (nonatomic, retain) NSMutableArray *coolers;
@property (nonatomic, retain) NSMutableArray *other_coolers;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) CSCustomer *customer;
@property (nonatomic, retain) IBOutlet UISegmentedControl *efesOtherSegmentControl;
@property (nonatomic, retain) UIBarButtonItem *barButton;
@property (nonatomic, retain) NSString *resultText;
@property (nonatomic, retain) UIImageView *resultImage;
@property BOOL isEfesActive;
@property BOOL isStockTakingActive;
@property (nonatomic, retain) NSMutableArray *stockTakingArray;
@property (nonatomic, retain) CSCooler *selectedCooler;
@property (nonatomic, retain) NSString *barcodeText;
@property int selectedRow;
@property BOOL isStockTakingTime;
@property BOOL isCoolerAddition;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) NSMutableArray *otherCoolerList;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *pickerViewButton;


- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer;
- (IBAction)segmentTapped:(id)sender;
- (IBAction)addCoolerToSystem:(id)sender;
- (void)getCoolersFromSap;
- (void)barcodeReader;
- (void)beginStockTaking;
- (void)checkBarcode;
- (IBAction)getUpdatedCoolerQuantity;
- (IBAction)selectOtherCooler:(id)sender;

@end
