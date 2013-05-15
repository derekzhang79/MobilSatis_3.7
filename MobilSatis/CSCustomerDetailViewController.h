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
#import "CSCityList.h"
#import "CSTaxOfficeViewController.h"
#import "CSCancelationInfoViewController.h"
#import "CSContractAnalysisViewController.h"
#import "CSCustomerVisitListViewController.h"
#import "CSPanoramaHandler.h"
#import "CSCityListViewController.h"
#import "CSDealerSalesChartViewController.h"

@class CSCancelationInfoViewController;
@class CSContractAnalysisViewController;

@interface CSCustomerDetailViewController : CSBaseViewController<MKMapViewDelegate, UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UITextFieldDelegate, CSPanoramaHandlerDelegate, CLLocationManagerDelegate>  {
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
    UITextField *doorNumber;
    UITextField *postalCode;
    UITextField *telNumber;
    UITextField *metreSquare;
    UITextField *cashRegister;
    UITextField *openm2;
    UITextField *closedm2;
    UITextField *certificateOffice;
    UITextField *certificateNumber;
    UIPickerView *sesGroup;
    UIPickerView *customerFeature;
    UIPickerView *customerPosition;
    UIPickerView *locationGroup;
    UIPickerView *cityPickerList;
    UIPickerView *countyList;
    BOOL isCityResponse;
    CSCityList *cityList;
    int cityRowPicked;
    int countyRowPicked;
    UIButton *doneButton;
    UIPickerView *activePicker;
    BOOL isCustomerAvailable;
    CSTaxOfficeViewController *taxOffice;
    CSNewCoordinateLocationViewController *newCoordinateLocationViewController;
    BOOL isCityPicked;
    BOOL isCountyPicked;
    NSString *locationGroupString;
    UIPickerView *customerGroup;
    NSString *cancelPurpose;
    CSCancelationInfoViewController *cancelInfoViewController;
    CSContractAnalysisViewController *contractViewController;
    BOOL isDealer;
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
@property (nonatomic, retain) UITextField *district;
@property (nonatomic, retain) UITextField *certificateOffice;
@property (nonatomic, retain) UITextField *certificateNumber;
@property (nonatomic, retain) UIPickerView *sesGroup;
@property (nonatomic, retain) UIPickerView *customerFeature;
@property (nonatomic, retain) UIPickerView *customerPosition;
@property (nonatomic, retain) UIPickerView *locationGroup;
@property BOOL isCityResponse;
@property (nonatomic, retain) CSCityList *cityList;
@property (nonatomic, retain) UIPickerView *cityPickerList;
@property (nonatomic, retain) UIPickerView *countyList;
@property int cityRowPicked;
@property int countyRowPicked;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIPickerView *activePicker;
@property BOOL isCustomerAvailable;
@property (nonatomic, retain) CSTaxOfficeViewController *taxOffice;
@property (nonatomic, retain) CSNewCoordinateLocationViewController *newCoordinateLocationViewController;
@property BOOL isCityPicked;
@property BOOL isCountyPicked;
@property (nonatomic, retain) NSString *locationGroupString;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIPickerView *customerGroup;
@property (nonatomic, retain) NSString *cancelPurpose;
@property (nonatomic, retain) CSCancelationInfoViewController *cancelInfoViewController;
@property (nonatomic, retain) CSContractAnalysisViewController *contractViewController;

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer isDealer:(BOOL)aIsDealer;
- (IBAction)makeKeyboardGoAway;
- (IBAction)editFields:(id)sender;
- (IBAction)viewSalesChart:(id)sender;
- (IBAction)viewCoolers;
- (IBAction)editCoordinates:(id)sender;
- (void)saveButton;
- (void)checkIn;
- (void)saveAllInformation;
- (void)toggleFields:(BOOL)toggle;
- (IBAction)numberpadResigner;
- (IBAction)releaseAllPickers;
- (void)initTextFields;
- (void)segmentValueChanged;
- (void)showRiskAnalysis;
@end
