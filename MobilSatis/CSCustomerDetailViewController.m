//
//  CSCustomerDetailViewController.m
//  MobilSatis
//
//  Created by ABH on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "CSCustomerDetailViewController.h"


@implementation CSCustomerDetailViewController
@synthesize myCustomer;
@synthesize segmentedControl;
@synthesize postalCode;
@synthesize doorNumber;
@synthesize telNumber;
@synthesize metreSquare;
@synthesize cashRegister;
@synthesize openm2;
@synthesize closedm2;
@synthesize street;
@synthesize mainStreet;
@synthesize neighbour;
@synthesize name1Label;
@synthesize district;
@synthesize certificateNumber;
@synthesize certificateOffice;
@synthesize taxNumber;
@synthesize taxOffice;
@synthesize sesGroup;
@synthesize isCityResponse;
@synthesize cityList;
@synthesize cityPickerList;
@synthesize countyList;
@synthesize cityRowPicked;
@synthesize countyRowPicked;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer{
    self = [super initWithUser:myUser];
    self.myCustomer = aCustomer;
    isFieldsEditable = NO;
    return self;
}

- (IBAction)makeKeyboardGoAway{
    //buraya tum editable fieldler gelcek -ata.
    [adressTextView resignFirstResponder];
    [saleAmount resignFirstResponder];
    [doorNumber resignFirstResponder];
    [postalCode resignFirstResponder];
    [telNumber resignFirstResponder];
    [openm2 resignFirstResponder];
    [metreSquare resignFirstResponder];
    [closedm2 resignFirstResponder];
    [cashRegister resignFirstResponder];
    [mainStreet resignFirstResponder];
    [street resignFirstResponder];
    [doorNumber resignFirstResponder];
    [neighbour resignFirstResponder];
    [postalCode resignFirstResponder];
    [district resignFirstResponder];
    [telNumber resignFirstResponder];
    [taxOffice resignFirstResponder];
    [taxNumber resignFirstResponder];
    [certificateOffice resignFirstResponder];
    [certificateNumber resignFirstResponder];
    [metreSquare resignFirstResponder];
    [cashRegister resignFirstResponder];
    [openm2 resignFirstResponder];
    [closedm2 resignFirstResponder];

}

- (IBAction)editFields:(id)sender{
    if (![self checkCustomerInScope:myCustomer]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müşteri için yetkiniz yoktur." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (isFieldsEditable) {
        isFieldsEditable = NO;
        [adressTextView setEditable:NO];
        [saleAmount setEnabled:NO];
        [editSaveButton setTitle:@"Düzenle" forState:UIControlStateNormal];
        [self toggleFields:NO];
        
        
        
    }else{
        isFieldsEditable = YES;
        
        [editSaveButton setTitle:@"Kaydet" forState:UIControlStateNormal];
        [adressTextView setEditable:YES];
        [saleAmount setEnabled:YES];
        [self toggleFields:YES];
    }
    
    
    
    
    
    
}
- (IBAction)viewSalesChart:(id)sender{
    CSCustomerSalesChartViewController *customerSalesChartViewController = [[CSCustomerSalesChartViewController alloc] initWithUser:user andSelectedCustomer:myCustomer];
    [[self navigationController] pushViewController:customerSalesChartViewController animated:YES];
}
- (IBAction)viewCoolers{
    CSEquipmentViewController *equipmentViewController = [[CSEquipmentViewController alloc] initWithUser:user andCustomer:myCustomer];
    [[self navigationController] pushViewController:equipmentViewController animated:YES];
}
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)disabelEditOnLoad{
    
    
    
}
- (IBAction)editCoordinates:(id)sender{
    if (!isFieldsEditable) {
        return;
    }
    CSNewCoordinateLocationViewController *newCoordinateLocationViewController = [[CSNewCoordinateLocationViewController alloc] initWithUser:user andCustomer:myCustomer];
    [[self navigationController] pushViewController:newCoordinateLocationViewController animated:YES];
}
- (void)checkIn{
    CSVisitDetailViewController *visitDetailViewController = [[CSVisitDetailViewController  alloc] initWithUser:user andSelectedCustomer:myCustomer];
    [[self navigationController]pushViewController:visitDetailViewController animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (alertView.tag == 1) {
        
        
        
        if (buttonIndex == 1) {
            [self saveAllInformation];
        }
        
        
        
    }
    
    
    
}



- (IBAction)saveButton:(id)sender {
    
    
    
    UIButton *but = (UIButton *)sender;
    
    
    
    if ([[but titleLabel] text] == @"Düzenle") {
        
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Uyarı"

                                                         message:@"Müşteri Anaverilerini güncelliyorsunuz. Emin misiniz?"
                                            delegate:self
                                               cancelButtonTitle:@"İptal"
                                               otherButtonTitles:@"Evet", nil];
        alert.tag = 1;
        [alert show];
    }
    
}

- (void)toggleFields:(BOOL)toggle {
    
    [segmentedControl setEnabled:toggle];
    [mainStreet setEnabled:toggle];
    mainStreet.enabled = toggle;
    [street setEnabled:toggle];
    [doorNumber setEnabled:toggle];
    [postalCode setEnabled:toggle];
    [neighbour setEnabled:toggle];
    [telNumber setEnabled:toggle];
    [certificateNumber setEnabled:toggle];
    [certificateOffice setEnabled:toggle];
    [taxNumber setEnabled:toggle];
    [taxOffice setEnabled:toggle];
    [openm2 setEnabled:toggle];
    [metreSquare setEnabled:toggle];
    [closedm2 setEnabled:toggle];
    [district setEnabled:toggle];
    [cashRegister setEnabled:toggle];
}






- (void)saveAllInformation {
    
    customerDetail.status = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    customerDetail.mainStreet = mainStreet.text;
    customerDetail.street = street.text;
    customerDetail.doorNumber = doorNumber.text;
    customerDetail.postalCode = postalCode.text;
    customerDetail.neighbourhood = neighbour.text;
    //customerDetail.borough = borough.text;
    //customerDetail.state = state.text;
    customerDetail.telf1 = telNumber.text;
    customerDetail.certificateNumber = certificateNumber.text;
    customerDetail.certificateOffice = certificateOffice.text;
    customerDetail.taxNumber = taxNumber.text;
    customerDetail.taxOffice = taxOffice.text;
    customerDetail.openM2 = openm2.text;
    customerDetail.m2 = metreSquare.text;
    customerDetail.closeM2 = closedm2.text;
    customerDetail.distrinct = district.text;
    customerDetail.cashRegister = cashRegister.text;
}









-(BOOL)textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    switch ([pickerView tag]) {
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 2;
            break;
        case 6:
            return [cityList.cityList count];
            break;
        case 7:
            NSLog(@"City Count %i",[[[cityList.cityList objectAtIndex:cityRowPicked] objectAtIndex:1] count]);
            return [[[cityList.cityList objectAtIndex:cityRowPicked] objectAtIndex:1] count];
            break;
        default:
            break;
    }  
    return 0;
}



// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}



// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    switch ([pickerView tag]) {
        case 1:
            return [NSString stringWithFormat:@"%@ %i",@"ses",row];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@ %i",@"feature",row];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@ %i",@"position",row];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@ %i",@"location",row];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@ %i",@"efes",row];
            break;
        case 6:
            return [[cityList.cityList objectAtIndex:row] objectAtIndex:0];
            break;
        case 7:
            return [[[cityList.cityList objectAtIndex:cityRowPicked] objectAtIndex:1] objectAtIndex:row];
            break;
        default:
            break;
    }

    return @"";
}






// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return 300;
}



- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    
    switch ([thePickerView tag]) {
        case 1:
            [thePickerView removeFromSuperview];
            break;
        case 2:
            [thePickerView removeFromSuperview];
            break;
        case 3:
            [thePickerView removeFromSuperview];
            break;
        case 4:
            [thePickerView removeFromSuperview];
            break;
        case 5:
            [thePickerView removeFromSuperview];
            break;
        case 6:
            cityRowPicked = row;
            [countyList reloadAllComponents];
            [thePickerView removeFromSuperview];
            break;
        case 7:
            countyRowPicked = row;
            [thePickerView removeFromSuperview];
            break;
        default:
            break;
    }
    
    
    
}






-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
    NSLog(@"%@",myResponse);
    
    [self initCustomerDetails:myResponse];

    canEditCustomer = [self checkCustomerInScope:myCustomer];
}

- (void)initCustomerDetails:(NSString*)aResponse{
    customerDetail = [[CSCustomerDetail alloc] init];
    [customerDetail setSaleManager:[[ABHXMLHelper getValuesWithTag:@"SATMD" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setSaleChief:[[ABHXMLHelper getValuesWithTag:@"SATSF" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCustomerManager:[[ABHXMLHelper getValuesWithTag:@"NOKYT" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setSalesRepresentative:[[ABHXMLHelper getValuesWithTag:@"SATTT" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setMarketDeveloper:[[ABHXMLHelper getValuesWithTag:@"PAZGT" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setStatus:[[ABHXMLHelper getValuesWithTag:@"DURUM" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setTitle:[[ABHXMLHelper getValuesWithTag:@"UNVAN" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setMainStreet:[[ABHXMLHelper getValuesWithTag:@"CADDE" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setStreet:[[ABHXMLHelper getValuesWithTag:@"SOKAK" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setDoorNumber:[[ABHXMLHelper getValuesWithTag:@"KAPIN" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setNeighbourhood:[[ABHXMLHelper getValuesWithTag:@"MAHKY" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setPostalCode:[[ABHXMLHelper getValuesWithTag:@"PKODU" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setDistrinct:[[ABHXMLHelper getValuesWithTag:@"SEMTX" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setBorough:[[ABHXMLHelper getValuesWithTag:@"ILCEK" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setState:[[ABHXMLHelper getValuesWithTag:@"ILKOD" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setTelf1:[[ABHXMLHelper getValuesWithTag:@"TELF1" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setTaxOffice:[[ABHXMLHelper getValuesWithTag:@"VERDA" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setTaxNumber:[[ABHXMLHelper getValuesWithTag:@"VERNO" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCertificateOffice:[[ABHXMLHelper getValuesWithTag:@"RUHDA" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCertificateNumber:[[ABHXMLHelper getValuesWithTag:@"RUHNO" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCustomerGroup:[[ABHXMLHelper getValuesWithTag:@"MUSGR" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setSesGroup:[[ABHXMLHelper getValuesWithTag:@"SESGR" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCustomerFeature:[[ABHXMLHelper getValuesWithTag:@"MUSOZ" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCustomerPosition:[[ABHXMLHelper getValuesWithTag:@"MUPOZ" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setLocationGroup:[[ABHXMLHelper getValuesWithTag:@"KDGRP" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setEfesContract:[[ABHXMLHelper getValuesWithTag:@"EFSOZ" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setM2:[[ABHXMLHelper getValuesWithTag:@"MKARE" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCashRegister:[[ABHXMLHelper getValuesWithTag:@"YKASA" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setOpenM2:[[ABHXMLHelper getValuesWithTag:@"AKARE" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCloseM2:[[ABHXMLHelper getValuesWithTag:@"KKARE" fromEnvelope:aResponse] objectAtIndex:0]];
    [tableView reloadData];
}



#pragma mark - Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    return 33;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    else {
        [[cell detailTextLabel] setText:@""];
        [cell setAccessoryView:nil];
    }
    
    
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        
        int sayac = 0;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müşteri Satışları";
            cell.detailTextLabel.text = @"";
            cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
            //cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Soğutucular";
            cell.detailTextLabel.text = @"";
            cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Satış Müdürlüğü";
            cell.detailTextLabel.text = customerDetail.saleManager;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Satış Şefliği";
            cell.detailTextLabel.text = customerDetail.saleChief;
            cell.accessoryType=UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Nokta Yöneticisi";
            cell.detailTextLabel.text = customerDetail.customerManager;
            cell.accessoryType=UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Satış Temsilcisi";
            cell.detailTextLabel.text = customerDetail.salesRepresentative;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Pazar Geliştirme";
            cell.detailTextLabel.text = customerDetail.marketDeveloper;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Bayi/Dist.";
            cell.detailTextLabel.text = myCustomer.dealer.name1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Durum";
            //cell.detailTextLabel.text = customerDetail.status;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            if ([customerDetail.status isEqualToString:@"Aktif"]) {
                            [segmentedControl setSelectedSegmentIndex:0];
            }else{
                            [segmentedControl setSelectedSegmentIndex:1];
            }
 // Burda customerDetail statusden cekmek lazım
            cell.accessoryView = segmentedControl;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Ünvan";
            cell.detailTextLabel.text = customerDetail.title;
            cell.accessoryView = nil;
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Cadde";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            mainStreet.text = customerDetail.mainStreet;
            
            mainStreet.delegate = self;
            cell.accessoryView = mainStreet;
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Sokak";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            street.text = customerDetail.street;
            
            street.delegate = self;
            cell.accessoryView = street;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Kapı No";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            doorNumber.text = customerDetail.doorNumber;
            
            [doorNumber setKeyboardType:UIKeyboardTypeNumberPad];
            doorNumber.delegate = self;
            cell.accessoryView = doorNumber;
            
            return cell;
        }
        sayac++;
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Mahalle/Köy";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            neighbour.text = customerDetail.neighbourhood;
            
            neighbour.delegate = self;
            cell.accessoryView = neighbour;    
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Posta Kodu";
            //cell.detailTextLabel.text = customerDetail.doorNumber;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            postalCode.text = customerDetail.postalCode;
            
            [postalCode setKeyboardType:UIKeyboardTypeNumberPad];
            postalCode.delegate = self;
            cell.accessoryView = postalCode;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Semt";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            district.text = customerDetail.distrinct;
            
            district.delegate = self;
            cell.accessoryView = district;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"İlçe";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.detailTextLabel.text = customerDetail.borough;
        
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"İl";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.detailTextLabel.text = customerDetail.state;
            
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Telf.1";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            telNumber.text = customerDetail.telf1;
            
            telNumber.delegate = self;
            [telNumber setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = telNumber;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Ver. Dairesi";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            taxOffice.text = customerDetail.taxOffice;
            
            taxOffice.delegate = self;
            cell.accessoryView = taxOffice;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Ver. No";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            taxNumber.text = customerDetail.taxNumber;
            
            taxNumber.delegate = self;
            cell.accessoryView = taxNumber;
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Ruh Daire";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            certificateOffice.text = customerDetail.certificateOffice;
            
            certificateOffice.delegate = self;
            cell.accessoryView = certificateOffice;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Ruh. No";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            certificateNumber.text = customerDetail.certificateNumber;
            
            certificateNumber.delegate = self;
            cell.accessoryView = certificateNumber;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müş. Grubu";
            cell.detailTextLabel.text = customerDetail.customerGroup;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"SES Grubu";
            cell.detailTextLabel.text = customerDetail.sesGroup;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müş. Özeti";
            cell.detailTextLabel.text = customerDetail.customerFeature;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müşteri Po";
            cell.detailTextLabel.text = customerDetail.customerPosition;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Konum Grubu";
            cell.detailTextLabel.text = customerDetail.locationGroup;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Efes Söz.";
            cell.detailTextLabel.text = customerDetail.efesContract;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Metrekare";
            cell.selectionStyle = UITableViewCellSelectionStyleNone; 
            
            metreSquare.text = customerDetail.m2;
            
            metreSquare.delegate = self;
            [metreSquare setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = metreSquare;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Yazarkasa";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            cashRegister.text = customerDetail.cashRegister;
            
            cashRegister.delegate = self;
            [cashRegister setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = cashRegister;
            
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Açık M2";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            openm2.text = customerDetail.openM2;
            
            openm2.delegate = self;
            [openm2 setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = openm2;
            return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Kapalı M2";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            closedm2.text = customerDetail.closeM2;
            
            closedm2.delegate = self;
            [closedm2 setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = closedm2;
            
            return cell;
        }
        sayac++;
        
    }
    else{
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
        cell.textLabel.numberOfLines = 2; 
        
        cell.textLabel.text = @"ss";
        cell.detailTextLabel.text = @"%Adet";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        [self viewSalesChart:self];
        return;
    }
    if (row == 1) {
        [self viewCoolers];
        return;
    }
    if (isFieldsEditable == YES) {
        switch (row) {
            case 16:
                [self.view addSubview:countyList];
                break;
            case 17:
                [self.view addSubview:cityPickerList];
                break;
            case 22:
                [self.view addSubview:sesGroup];
                break;
            case 23:
                [self.view addSubview:customerFeature];
                break;
            case 24:
                [self.view addSubview:customerPosition];
                break;
            case 25:
                [self.view addSubview:locationGroup];
                break;
            case 26:
                [self.view addSubview:efesContract];
                break;
            default:
                break;
        }
    }
}


- (BOOL)checkCustomerInScope:(CSCustomer*)aCustomer{
    for (int sayac = 0 ; sayac < [user.customers count]; sayac++) {
        CSCustomer *tempCust = [user.customers objectAtIndex:sayac];
        if ([myCustomer.kunnr isEqualToString:tempCust.kunnr] ) {
            return  YES;
        }
    }
    //return NO;
    //for test purposes
    return YES;
}






- (void)getCustomerDetails:(CSCustomer*)aCustomer{
    //ZCRM_MUSTERI_MASTER
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZCRM_MUSTERI_MASTER"];
    // [sapHandler addImportWithKey:@"I_UNAME" andValue:[user.username]];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:[myCustomer kunnr]];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
}





#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    customerDetail = [[CSCustomerDetail alloc] init];
    [self getCustomerDetails:myCustomer];
    [name1Label setText:myCustomer.name1];
    [name1Label setTextColor:[CSApplicationProperties getUsualTextColor]];
    [kunnrLabel setText:myCustomer.kunnr];
    [kunnrLabel setTextColor:[CSApplicationProperties getUsualTextColor]];
    
    cityList = [CSCityList getCityList];
    
    if ([cityList.cityList count] < 1) {
        [cityList allocateMethods];
    }
    
    cityRowPicked = 1;
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;
    if (myCustomer.locationCoordinate != nil) {
        [mapView setHidden:NO];
        [mapView addAnnotation:[myCustomer locationCoordinate]];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([myCustomer locationCoordinate].coordinate, 250,250);
        [mapView setRegion:region];
    }else{
        [mapView setHidden:YES];
        [scrollView setBackgroundColor:[UIColor clearColor]];
    }
    segmentedControl = [[UISegmentedControl alloc] initWithItems:
                        [NSArray arrayWithObjects:
                         @"Aktif",
                         @"Pasif",
                         nil]];
    mainStreet = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    street = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    doorNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    neighbour = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    postalCode = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    district = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    telNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    taxOffice = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    taxNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    certificateOffice = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    certificateNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    metreSquare = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    cashRegister = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    openm2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    closedm2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    
    
    
    sesGroup = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    sesGroup.tag = 1;
    sesGroup.delegate = self;
    sesGroup.showsSelectionIndicator = YES;
    
    
    
    customerFeature = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    customerFeature.tag = 2;
    customerFeature.delegate = self;
    customerFeature.showsSelectionIndicator = YES;
    
    
    
    customerPosition = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    customerPosition.tag = 3;
    customerPosition.delegate = self;
    customerPosition.showsSelectionIndicator = YES;
    
    
    
    efesContract = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    efesContract.tag = 4;
    efesContract.delegate = self;
    efesContract.showsSelectionIndicator = YES;
    
    
    
    locationGroup = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    locationGroup.tag = 5;
    locationGroup.delegate = self;
    locationGroup.showsSelectionIndicator = YES;
    
    cityPickerList = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    cityPickerList.tag = 6;
    cityPickerList.delegate = self;
    cityPickerList.showsSelectionIndicator = YES;
    
    countyList = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    countyList.tag = 7;
    countyList.delegate = self;
    countyList.showsSelectionIndicator = YES;
    
    
    [self toggleFields:NO];
}






- (void)viewWillAppear:(BOOL)animated{
    [self disabelEditOnLoad];
        [[[self tabBarController] navigationItem] setTitle:@"Müşterim"];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Ziyaret Girişi" style:UIBarButtonItemStyleBordered target:self action:@selector(checkIn)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end