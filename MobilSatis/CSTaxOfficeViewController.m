//
//  CSTaxOfficeViewController.m
//  MobilSatis
//
//  Created by Alp Keser on 6/14/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import "CSTaxOfficeViewController.h"

@interface CSTaxOfficeViewController ()

@end

@implementation CSTaxOfficeViewController
@synthesize taxOffice,taxNumber;
@synthesize pickerView;
@synthesize tableView;
@synthesize selectedIndex;
@synthesize tcNo;
@synthesize taxNo;
@synthesize flag;
@synthesize taxNoWithoutKDV;
@synthesize changedText;
@synthesize normal;
@synthesize foreignCitizen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)releaseKeyboards:(id)sender {
    [tcNo resignFirstResponder];
    [taxNo resignFirstResponder];
    [taxNoWithoutKDV resignFirstResponder];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 5;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (row) {
        case 0:
            return @"Normal";
            break;
        case 1:
            return @"KDV Muaf";
            break;
        case 2:
            return @"Gerçek Kişi";
            break;
        case 3:
            return @"Tüzel Kişi";
            break;
        case 4:
            return @"Yabancı Uyruk";
            break;
        default:
            break;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (row) {
        case 0:
            selectedIndex = 0;
            [tableView  reloadData];
            break;
        case 1:
            selectedIndex = 1;
            [tableView  reloadData];
            break;
        case 2:
            selectedIndex = 2;
            [tableView  reloadData];
            break;
        case 3:
            selectedIndex = 3;
            [tableView reloadData];
            break;
        case 4:
            selectedIndex = 4;
            [tableView reloadData];
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    int section = [indexPath section];
    
    if (section == 0) {
        
        cell.textLabel.text = self.taxOffice;
        cell.detailTextLabel.text = self.taxNumber;
    }
    else {
        switch (selectedIndex) {
            case 0:
                cell.textLabel.text = @"Vergi Numarası";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = normal;
                break;
            case 1:
                cell.textLabel.text = @"Vergi Numarası";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = taxNoWithoutKDV;
                break;
            case 2:
                cell.textLabel.text = @"T.C. Kimlik No";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = tcNo;
                break;
            case 3:
                cell.textLabel.text = @"Vergi Numarası";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = taxNo;
                break;
            case 4:
                cell.textLabel.text = @"Pasaport Numarası";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = foreignCitizen;
                break;
            default:
                break;
        }
    }
    
    return cell;
    
}

-(void) saveInformation {
    flag = YES;
    switch (selectedIndex) {
        case 0:
            changedText = normal.text;
            break;
        case 1:
            changedText = taxNoWithoutKDV.text;
            break;
        case 2:
            changedText = tcNo.text;
            break;
        case 3:
            changedText = taxNo.text;
            break;
        case 4:
            changedText = foreignCitizen.text;
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedIndex = 0;
    taxNo = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    tcNo = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    taxNoWithoutKDV = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    foreignCitizen = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    normal = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    taxNo.keyboardType = UIKeyboardTypeNumberPad;
    tcNo.keyboardType = UIKeyboardTypeNumberPad;
    taxNoWithoutKDV.keyboardType = UIKeyboardTypeNumberPad;
    normal.keyboardType = UIKeyboardTypeNumberPad;
    foreignCitizen.keyboardType = UIKeyboardTypeNumberPad;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(saveInformation)];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
