//
//  CSTaxOfficeViewController.h
//  MobilSatis
//
//  Created by Alp Keser on 6/14/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCustomerDetail.h"

@interface CSTaxOfficeViewController : UIViewController <UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSString *taxNumber;
    NSString *taxOffice;
    UIPickerView *pickerView;
    UITableView *tableView;
    int selectedIndex;
    UITextField *tcNo;
    UITextField *taxNo;
    UITextField *taxNoWithoutKDV;
    UITextField *normal;
    UITextField *foreignCitizen;
    NSString *changedText;
    BOOL flag;
}

@property (nonatomic, retain) NSString *taxNumber;
@property (nonatomic, retain) NSString *taxOffice;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property int selectedIndex;
@property (nonatomic, retain) UITextField *tcNo;
@property (nonatomic, retain) UITextField *taxNo;
@property (nonatomic, retain) UITextField *taxNoWithoutKDV;
@property (nonatomic, retain) NSString *changedText;
@property BOOL flag;
@property (nonatomic, retain) UITextField *normal;
@property (nonatomic, retain) UITextField *foreignCitizen;

-(IBAction) releaseKeyboards:(id)sender;
-(void) saveInformation;

@end
