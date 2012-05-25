//
//  CSCustomerDetailViewController.h
//  MobilSatis
//
//  Created by ABH on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import "CSCustomerDetail.h"
#import "CSCustomerSalesChartViewController.h"
#import "CSNewCoordinateLocationViewController.h"
#import "CSVisitDetailViewController.h"
#import "CSEquipmentViewController.h"
@interface CSCustomerDetailViewController : CSBaseViewController<MKMapViewDelegate, UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate>  {
        BOOL canEditCustomer;
    CSCustomer *myCustomer;
    CSCustomerDetail *customerDetail;
    IBOutlet UILabel *name1Label;
    IBOutlet UILabel *kunnrLabel;
    IBOutlet UIScrollView *scrollView;
    IBOutlet MKMapView *mapView;
    IBOutlet UITextView *adressTextView;
    IBOutlet UITextField *saleAmount;
    IBOutlet UIButton *editSaveButton;
    IBOutlet UITableView *tableView;
    BOOL isFieldsEditable;
    UISegmentedControl *segmentedControl;
    UITextField *mainStreet;
    UITextField *street;
    UITextField *neighbour;
    UITextField *district;
    UITextField *state;
    UITextField *borough;
    UITextField *doorNumber;
    UITextField *postalCode;
    UITextField *telNumber;
    UITextField *metreSquare;
    UITextField *cashRegister;
    UITextField *openm2;
    UITextField *closedm2;
    UITextField *taxOffice;
    UITextField *taxNumber;
    UITextField *certificateOffice;
    UITextField *certificateNumber;
    UIPickerView *sesGroup;
    UIPickerView *customerFeature;
    UIPickerView *customerPosition;
    UIPickerView *locationGroup;
    UIPickerView *efesContract;
    
}
@property (nonatomic,retain) CSCustomer *myCustomer;
@property (nonatomic,retain) UILabel *name1Label;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UITextField *doorNumber;
@property (nonatomic, retain) UITextField *postalCode;
@property (nonatomic, retain) UITextField *telNumber;
@property (nonatomic, retain) UITextField *metreSquare;
@property (nonatomic, retain) UITextField *cashRegister;
@property (nonatomic, retain) UITextField *openm2;
@property (nonatomic, retain) UITextField *closedm2;
@property (nonatomic, retain) UITextField *mainStreet;
@property (nonatomic, retain) UITextField *street;
@property (nonatomic, retain) UITextField *neighbour;
@property (nonatomic, retain) UITextField *state;
@property (nonatomic, retain) UITextField *borough;
@property (nonatomic, retain) UITextField *district;
@property (nonatomic, retain) UITextField *certificateOffice;
@property (nonatomic, retain) UITextField *certificateNumber;
@property (nonatomic, retain) UITextField *taxOffice;
@property (nonatomic, retain) UITextField *taxNumber;
@property (nonatomic, retain) UIPickerView *sesGroup;
@property (nonatomic, retain) UIPickerView *customerFeature;
@property (nonatomic, retain) UIPickerView *customerPosition;
@property (nonatomic, retain) UIPickerView *locationGroup;
@property (nonatomic, retain) UIPickerView *efesContract;

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer;
- (IBAction)makeKeyboardGoAway;
- (IBAction)editFields:(id)sender;
- (IBAction)viewSalesChart:(id)sender;
- (IBAction)viewCoolers;
- (IBAction)editCoordinates:(id)sender;
- (IBAction)saveButton:(id)sender;
- (void)checkIn;
- (void)saveAllInformation;
- (void)toggleFields:(BOOL)toggle;
- (IBAction)numberpadResigner;

@end
