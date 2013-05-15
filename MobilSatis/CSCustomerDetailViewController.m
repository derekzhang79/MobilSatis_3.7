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
@synthesize sesGroup;
@synthesize isCityResponse;
@synthesize cityList;
@synthesize cityPickerList;
@synthesize countyList;
@synthesize cityRowPicked;
@synthesize countyRowPicked;
@synthesize doneButton;
@synthesize tableView;
@synthesize activePicker;
@synthesize customerFeature;
@synthesize customerPosition;
@synthesize locationGroup;
@synthesize isCustomerAvailable;
@synthesize taxOffice;
@synthesize newCoordinateLocationViewController;
@synthesize isCityPicked;
@synthesize isCountyPicked;
@synthesize locationGroupString;
@synthesize mapView;
@synthesize customerGroup;
@synthesize cancelPurpose;
@synthesize cancelInfoViewController;
@synthesize contractViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer isDealer:(BOOL)aIsDealer{
    self = [super initWithUser:myUser];
    self.myCustomer = aCustomer;
    isDealer = aIsDealer;
    isFieldsEditable = NO;
    return self;
}
- (void)initTextFields {
    
    mainStreet = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    street = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    doorNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    neighbour = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    postalCode = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    district = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    telNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    certificateOffice = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    certificateNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    metreSquare = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    cashRegister = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    openm2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    closedm2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    
    mainStreet.text = customerDetail.mainStreet;
    street.text = customerDetail.street;
    doorNumber.text = customerDetail.doorNumber;
    postalCode.text = customerDetail.postalCode;
    neighbour.text = customerDetail.neighbourhood;
    telNumber.text = customerDetail.telf1;
    certificateNumber.text = customerDetail.certificateNumber;
    certificateOffice.text = customerDetail.certificateOffice;
    openm2.text = customerDetail.openM2;
    metreSquare.text = customerDetail.m2;
    closedm2.text = customerDetail.closeM2;
    district.text = customerDetail.distrinct;
    cashRegister.text = customerDetail.cashRegister;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [textField superview];
    [tableView scrollToRowAtIndexPath:[tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    [certificateOffice resignFirstResponder];
    [certificateNumber resignFirstResponder];
    [metreSquare resignFirstResponder];
    [cashRegister resignFirstResponder];
    [openm2 resignFirstResponder];
    [closedm2 resignFirstResponder];
    [self releaseAllPickers];
    
}

- (IBAction)releaseAllPickers {
    [self.activePicker removeFromSuperview];
    [doneButton setEnabled:NO];
    [doneButton setHidden:YES];
    [tableView reloadData];
    
    if (isCityPicked) {
        isCityPicked = NO;
        
        [activePicker removeFromSuperview];
        [doneButton setEnabled:YES];
        [doneButton setHidden:NO];
        activePicker = countyList;
        [doneButton setTitle:@"İlçe Seç" forState:UIControlStateNormal];
        [self.view addSubview:countyList];
    }
    
    if (isCountyPicked) {
        isCountyPicked = NO;
        
        [self showCityList];
    }
}

- (IBAction)editFields:(id)sender{
    //[self sendDataOfCustomerToPanoramaWithCustomer:customerDetail];

    if (![self checkCustomerInScope:myCustomer]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müşteri için yetkiniz yoktur." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (isFieldsEditable) {
        [self saveButton];
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

- (IBAction)viewSalesChart:(id)sender {
    if (isDealer) {
        CSDealerSalesChartViewController *dealerSalesChartViewController = [[CSDealerSalesChartViewController alloc] initWithUser:[self user] andCustomer:[self myCustomer]];
        [[self navigationController] pushViewController:dealerSalesChartViewController animated:NO];
        return;
    }
    CSCustomerSalesChartViewController *customerSalesChartViewController = [[CSCustomerSalesChartViewController alloc] initWithUser:user andSelectedCustomer:myCustomer];
    [[self navigationController] pushViewController:customerSalesChartViewController animated:NO];
}

- (IBAction)viewCoolers{
    CSEquipmentViewController *equipmentViewController = [[CSEquipmentViewController alloc] initWithUser:user andCustomer:myCustomer];
    [[self navigationController] pushViewController:equipmentViewController animated:NO];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)editCoordinates:(id)sender{
//herkes koordinat degistirsin -alp
    //    if (!isFieldsEditable) {
//        return;
//    }
    if ([myCustomer locationCoordinate] != nil) {
        newCoordinateLocationViewController = [[CSNewCoordinateLocationViewController alloc] initWithUser:user andCustomer:myCustomer];
        [[self navigationController] pushViewController:newCoordinateLocationViewController animated:YES];
    }
    
}
- (BOOL)checkCustomerDistanceForVisit{
    if ([self getDistanceFromOldPointY:user.location.coordinate.latitude andOldPointX:user.location.coordinate.longitude andNewPointY:myCustomer.locationCoordinate.coordinate.latitude andNewPointX:myCustomer.locationCoordinate.coordinate.longitude]<= 250) {
        return YES;
        
    }
    return NO; //no for live yes for testing
    
}

- (double)getDistanceFromOldPointY:(double)old_lat andOldPointX:(double)old_lon andNewPointY:(double) new_lat andNewPointX:(double) new_lon{
    const int R =     6371;    
    double dLat = (new_lat - old_lat) * (M_PI/180);
    double dLon = (new_lon - old_lon) * (M_PI/180);
    old_lat = old_lat * (M_PI/180);
    new_lat = new_lat * (M_PI/180);
    double a = pow(sin(new_lat - old_lat), 2) + cos(new_lat)*cos(old_lat)*pow(sin(new_lon - old_lon), 2);
    
    a= pow(sin(dLat/2), 2) + cos(old_lat)*cos(new_lat)*pow(sin(dLon/2), 2);
    
    double b = 2 * a * pow(tan(2*(sqrt(a)-sqrt(1 - a))), 2);
    b = 2*atan2(sqrt(a),sqrt((1-a)));
    double c = R * b;
    
    
    return c*1000;
}
- (void)checkIn{
    if ([self checkCustomerDistanceForVisit]) {
        CSVisitDetailViewController *visitDetailViewController = [[CSVisitDetailViewController  alloc] initWithUser:user andSelectedCustomer:myCustomer];
        [[self navigationController]pushViewController:visitDetailViewController animated:YES]; 
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Ziyaret girişi yapabilmek için noktanın en az 250 mt. yakınında olmanız gerekmektedir." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
    }

}

- (void)viewVisitList {
    CSCustomerVisitListViewController *visitList = [[CSCustomerVisitListViewController alloc] initWithUser:user andSelectedCustomer:myCustomer];
    [[self navigationController] pushViewController:visitList animated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        if (buttonIndex == 1) {
            [self checkAllInformation];
        }
    }
    if ([alertView tag] == 2) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

-(void)sendDataOfCustomerToPanoramaWithCustomer:(CSCustomerDetail*)aCustomer {
    /*
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:int="http://integration.univera.com.tr">
    <soapenv:Header/>
    <soapenv:Body>
    <int:IntegrationSendEntitySetWithLogin>
    <!--Optional:-->
    <int:strUserName>WEBSERVICE</int:strUserName>
    <!--Optional:-->
    <int:strPassWord>WEBSERVICE</int:strPassWord>
    <int:bytFirmaKod>1</int:bytFirmaKod>
    <int:lngCalismaYili>2012</int:lngCalismaYili>
    <int:lngDistributorKod>545</int:lngDistributorKod>
    <!--Optional:-->
    <int:objPanIntEntityList>
    <!--Optional:-->
    <int:EfesMusteriler>
    <!--Zero or more repetitions:-->
    <int:clsEfesMusteriIntegration>
    <!--Optional:-->
    <int:MerkezKod>0002102663</int:MerkezKod>
    <int:Durum>1</int:Durum>
    <int:RuhsatDaire>İSTANBUL</int:RuhsatDaire>
    <int:RuhsatNo>45012758P</int:RuhsatNo>
    <int:VN>1234567890</int:VN>
    <int:VergiDairesiKod>480</int:VergiDairesiKod>
    <int:IptalNeden>3</int:IptalNeden>
    <int:KapiNo>8/A</int:KapiNo>
    <int:PostaKod>33970</int:PostaKod>
    <int:Mahalle>GÖKSU</int:Mahalle>
    <int:Cadde>OGUZ KAAN</int:Cadde>
    <int:Sokak>kalcak</int:Sokak>
    <int:DistReferans>20030</int:DistReferans>
    <int:MusteriGrupReferans>2000000031</int:MusteriGrupReferans>
    <int:MusteriEkGrupReferans>03</int:MusteriEkGrupReferans>
    <int:MerkezIlReferans>34</int:MerkezIlReferans>
    <int:MerkezIlceReferans> GAZİOSMANPAŞA </int:MerkezIlceReferans>
    <int:MerkezSemtTextKod> GAZİOSMANPAŞA </int:MerkezSemtTextKod>
    <int:MusOzel>03</int:MusOzel>
    <int:MusteriPO>01</int:MusteriPO>
    <int:MusteriKonumGrubu>01</int:MusteriKonumGrubu>
    <int:YazarKasa>2</int:YazarKasa>
    <int:AcikMetreKare>33</int:AcikMetreKare>
    <int:KapaliMKare>33</int:KapaliMKare>
    </int:clsEfesMusteriIntegration>
    </int:EfesMusteriler>
    
    </int:objPanIntEntityList>
    </int:IntegrationSendEntitySetWithLogin>
    </soapenv:Body>
    </soapenv:Envelope>
    */
    
  /*  CSPanoramaHandler *handler = [[CSPanoramaHandler alloc] initWithConnectionUrl:@"http://efesws.efespilsen.com.tr:9092/integrationwebservice.asmx"];
    [handler prepCallWithUsername:[ABHConnectionInfo getPanaromaUsername] andPassword:[ABHConnectionInfo getPanaromaPassword] andWorkYear:[ABHConnectionInfo getPanaromaWorkYear] andCompanyCode:[ABHConnectionInfo getPanaromaCompanyCode] andDistributionCode:[ABHConnectionInfo getPanaromaDistrubutionCode]];
    [handler addImportWithKey:@"MerkezKod" andValue:[[self myCustomer] kunnr]];
    [handler addImportWithKey:@"Durum" andValue:[NSString stringWithFormat:@"%i",[[self segmentedControl] selectedSegmentIndex]]];
    [handler addImportWithKey:@"RuhsatDaire" andValue:aCustomer.certificateOffice];
    [handler addImportWithKey:@"RuhsatNo" andValue:aCustomer.certificateNumber];
    [handler addImportWithKey:@"VN" andValue:aCustomer.taxNumber];
//    [handler addImportWithKey:@"VergiDairesiKod" andValue:aCustomer.taxOffice];
    [handler addImportWithKey:@"IptalNeden" andValue:cancelPurpose];
    [handler addImportWithKey:@"KapiNo" andValue:aCustomer.doorNumber];
    [handler addImportWithKey:@"PostaKod" andValue:aCustomer.postalCode];
    [handler addImportWithKey:@"Mahalle" andValue:aCustomer.neighbourhood];
    [handler addImportWithKey:@"Cadde" andValue:aCustomer.mainStreet];
    [handler addImportWithKey:@"Sokak" andValue:aCustomer.street];
//    [handler addImportWithKey:@"DistReferans" andValue:aCustomer.relationship];
//    [handler addImportWithKey:@"MusteriGrupReferans" andValue:cancelPurpose];
//    [handler addImportWithKey:@"MusteriEkGrupReferans" andValue:asd];
    [handler addImportWithKey:@"MerkezIlReferans" andValue:[aCustomer stateCode]];
    [handler addImportWithKey:@"MerkezIlceReferans" andValue:[aCustomer borough]];
    [handler addImportWithKey:@"MerkezSemtTextKod" andValue:aCustomer.distrinct];
    
    NSString *customerFeatureCode;
    for (int i = 0; i < [[[self cityList] musozList] count]; i++) {
        if ([[aCustomer customerFeature] isEqualToString:[[[cityList musozList] objectAtIndex:i] objectAtIndex:1]]) {
            customerFeatureCode = [[[cityList musozList] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (customerFeatureCode != nil) {
        [handler addImportWithKey:@"MusOzel" andValue:customerFeatureCode];
    }
    
    NSString *customerPositionCode;
    for (int i = 0; i < [[[self cityList] mupozList] count]; i++) {
        if ([[aCustomer customerPosition] isEqualToString:[[[cityList mupozList] objectAtIndex:i] objectAtIndex:1]]) {
            customerFeatureCode = [[[cityList mupozList] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (customerPositionCode != nil) {
        [handler addImportWithKey:@"MusteriPO" andValue:customerPositionCode];
    }

    NSString *locationGroupCode;
    for (int i = 0; i < [[[self cityList] locGroup] count]; i++) {
        if ([[aCustomer locationGroup] isEqualToString:[[[cityList locGroup] objectAtIndex:i] objectAtIndex:1]]) {
            locationGroupCode = [[[cityList locGroup] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (locationGroupCode != nil) {
        [handler addImportWithKey:@"MusteriKonumGrubu" andValue:locationGroupCode];
    }

    [handler addImportWithKey:@"YazarKasa" andValue:aCustomer.cashRegister];
    [handler addImportWithKey:@"AcikMetreKare" andValue:aCustomer.openM2];
    [handler addImportWithKey:@"KapaliMKare" andValue:aCustomer.closeM2];
   
   */
    
//    CSPanoramaHandler *handler = [[CSPanoramaHandler alloc] initWithConnectionUrl:@"http://efesws.efespilsen.com.tr:9092/integrationwebservice.asmx"];
  CSPanoramaHandler *handler = [[CSPanoramaHandler alloc] initWithConnectionUrl:@"http://172.17.1.174/integrationwebservice.asmx"];
    [handler setDelegate:self];
    [handler prepCallWithUsername:[ABHConnectionInfo getPanaromaUsername] andPassword:[ABHConnectionInfo getPanaromaPassword] andWorkYear:[ABHConnectionInfo getPanaromaWorkYear] andCompanyCode:[ABHConnectionInfo getPanaromaCompanyCode] andDistributionCode:[ABHConnectionInfo getPanaromaDistrubutionCode]];
    [handler addImportWithKey:@"MerkezKod" andValue:[[self myCustomer] kunnr]];
    
    NSString *statusCode;
    if ([customerDetail.status isEqualToString:@"Aktif"]) {
        statusCode = @"0";
    }else{
        if ([customerDetail.status isEqualToString:@"Pasif"]) {
        statusCode = @"1";
        }
        else{
        statusCode = @"2";
        }
    }
    
    [handler addImportWithKey:@"Durum" andValue:statusCode];
    [handler addImportWithKey:@"RuhsatDaire" andValue:[customerDetail certificateOffice]];
    [handler addImportWithKey:@"RuhsatNo" andValue:[customerDetail certificateNumber]];
    [handler addImportWithKey:@"VN" andValue:[customerDetail taxNumber]];
    //    [handler addImportWithKey:@"VergiDairesiKod" andValue:aCustomer.taxOffice];
    
    if (cancelPurpose != nil) {
        [handler addImportWithKey:@"IptalNeden" andValue:[self cancelPurpose]];
    }
    
    [handler addImportWithKey:@"KapiNo" andValue:[customerDetail doorNumber]];
    [handler addImportWithKey:@"PostaKod" andValue:[customerDetail postalCode]];
    [handler addImportWithKey:@"Mahalle" andValue:[customerDetail neighbourhood]];
    [handler addImportWithKey:@"Cadde" andValue:[customerDetail mainStreet]];
    [handler addImportWithKey:@"Sokak" andValue:[customerDetail street]];
    [handler addImportWithKey:@"DistReferans" andValue:[NSString stringWithFormat:@"%i",[[[customerDetail dealer] kunnr] intValue]]];
    [handler addImportWithKey:@"MerkezIlReferans" andValue:[customerDetail stateCode]];
    [handler addImportWithKey:@"MerkezIlceReferans" andValue:[customerDetail borough]];
    [handler addImportWithKey:@"MerkezSemtTextKod" andValue:[customerDetail distrinct]];
    
    NSString *customerFeatureCode;
    for (int i = 0; i < [[[self cityList] musozList] count]; i++) {
        if ([[customerDetail customerFeature] isEqualToString:[[[cityList musozList] objectAtIndex:i] objectAtIndex:1]]) {
            customerFeatureCode = [[[cityList musozList] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (customerFeatureCode != nil) {
        [handler addImportWithKey:@"MusOzel" andValue:customerFeatureCode];
    }
    
    NSString *customerPositionCode;
    for (int i = 0; i < [[[self cityList] mupozList] count]; i++) {
        if ([[customerDetail customerPosition] isEqualToString:[[[cityList mupozList] objectAtIndex:i] objectAtIndex:1]]) {
            customerPositionCode = [[[cityList mupozList] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (customerPositionCode != nil) {
        [handler addImportWithKey:@"MusteriPO" andValue:customerPositionCode];
    }
    
    NSString *locationGroupCode;
    for (int i = 0; i < [[[self cityList] locGroup] count]; i++) {
        if ([[customerDetail locationGroup] isEqualToString:[[[cityList locGroup] objectAtIndex:i] objectAtIndex:1]]) {
            locationGroupCode = [[[cityList locGroup] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (locationGroupCode != nil) {
        [handler addImportWithKey:@"MusteriKonumGrubu" andValue:locationGroupCode];
    }
   
    NSString *customerGroupNumber;
    for (int i = 0; i < [[[self cityList] name1List] count]; i++) {
        if ([[customerDetail customerGroup] isEqualToString:[[[cityList name1List] objectAtIndex:i] objectAtIndex:1]]) {
            customerGroupNumber = [[[cityList name1List] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (customerGroupNumber != nil) {
        [handler addImportWithKey:@"MusteriGrupReferans" andValue:customerGroupNumber];
    }

    
    NSString *customerExtraGroupNumber;
    for (int i = 0; i < [[[self cityList] sesGroup] count]; i++) {
        if ([[customerDetail sesGroup] isEqualToString:[[[cityList sesGroup] objectAtIndex:i] objectAtIndex:1]]) {
            customerExtraGroupNumber = [[[cityList sesGroup] objectAtIndex:i] objectAtIndex:0];
        }
    }
    if (customerExtraGroupNumber != nil) {
            [handler addImportWithKey:@"MusteriEkGrupReferans" andValue:customerExtraGroupNumber];
    }

    [handler addImportWithKey:@"YazarKasa" andValue:[customerDetail cashRegister]];
    [handler addImportWithKey:@"AcikMetreKare" andValue:[customerDetail openM2]];
    [handler addImportWithKey:@"KapaliMKare" andValue:[customerDetail closeM2]];
    
    [handler prepCall];
}
-(void)getPanoramaResponseWithString:(NSString*)myResponse{
    NSArray *arr = [ABHXMLHelper getValuesWithTag:@"IsSuccess" fromEnvelope:myResponse];
    
    if ([arr count] > 0) {
        if ([[arr objectAtIndex:0] isEqualToString:@"true"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Yaptığınız değişiklik tamamlanmıştır" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Yaptığınız değişiklik gerçekleştirelememiştir" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Yaptığınız değişiklik gerçekleştirelememiştir" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)saveButton {
    //[self sendDataOfCustomerToPanoramaWithCustomer:customerDetail];
    
    if (isFieldsEditable) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Uyarı"
                               
                                                         message:@"Müşteri anaverilerini güncelliyorsunuz. Emin misiniz?"
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
    [neighbour setEnabled:NO];
    [telNumber setEnabled:toggle];
    [certificateNumber setEnabled:toggle];
    [certificateOffice setEnabled:toggle];
    [openm2 setEnabled:toggle];
    [metreSquare setEnabled:toggle];
    [closedm2 setEnabled:toggle];
    [district setEnabled:toggle];
    [cashRegister setEnabled:toggle];
}
- (BOOL)checkCancelationStatus{
    return NO;
}
- (void)checkAllInformation {
    if ([mainStreet.text length] > 30) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri cadde bilgisi en fazla 30 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([street.text length] > 30) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri sokak bilgisi en fazla 30 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([doorNumber.text length] > 30) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri kapı numarası bilgisi en fazla 30 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([neighbour.text length] > 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri sokak bilgisi en fazla 50 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([postalCode.text length] > 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri posta kodu bilgisi en fazla 50 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([telNumber.text length] > 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri telefon numarası bilgisi en fazla 11 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([customerDetail.taxNumber length] > 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri vergi numarası bilgisi en fazla 11 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([certificateNumber.text length] > 25) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri ruhsat numarası bilgisi en fazla 25 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([certificateOffice.text length] > 25) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girdiğiniz müşteri ruhsat dairesi bilgisi en fazla 25 karakter olmalıdır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self saveAllInformation];
}

- (void)saveAllInformation {
        
    customerDetail.status = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    customerDetail.mainStreet = mainStreet.text;
    customerDetail.street = street.text;
    customerDetail.doorNumber = doorNumber.text;
    customerDetail.postalCode = postalCode.text;
    customerDetail.neighbourhood = neighbour.text;
    customerDetail.telf1 = telNumber.text;
    customerDetail.certificateNumber = certificateNumber.text;
    customerDetail.certificateOffice = certificateOffice.text;
    customerDetail.openM2 = openm2.text;
    customerDetail.m2 = metreSquare.text;
    customerDetail.closeM2 = closedm2.text;
    customerDetail.distrinct = district.text;
    customerDetail.cashRegister = cashRegister.text;
    
    [tableView reloadData];
    
    [self sendDataOfCustomerToPanoramaWithCustomer:customerDetail];
}

- (void)showRiskAnalysis {

}

- (void)sendCustomerInformation {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZCRM_MUSTERI_MASTER_DEGISIKLIK"];

    [sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
    [sapHandler addImportWithKey:@"I_NOKTA" andValue:myCustomer.kunnr];
    
    if (customerDetail.status != NULL) {
        [sapHandler addImportWithKey:@"I_DURUM" andValue:customerDetail.status];
    }
    if (customerDetail.mainStreet != NULL) {
        [sapHandler addImportWithKey:@"I_CADDE" andValue:customerDetail.mainStreet];

    }
    if (customerDetail.street != NULL) {
        [sapHandler addImportWithKey:@"I_SOKAK" andValue:customerDetail.street];

    }
    if (customerDetail.doorNumber != NULL) {
        [sapHandler addImportWithKey:@"I_KAPIN" andValue:customerDetail.doorNumber];
    }
    if (customerDetail.neighbourhood != NULL) {
        [sapHandler addImportWithKey:@"I_MAHKY" andValue:customerDetail.neighbourhood];
    }
    if (customerDetail.borough != NULL) {
        [sapHandler addImportWithKey:@"I_ILCEK" andValue:customerDetail.borough];
    }
    if (customerDetail.state != NULL) {
        [sapHandler addImportWithKey:@"I_ILKOD" andValue:customerDetail.state];
    }
    if (customerDetail.telf1 != NULL) {
        [sapHandler addImportWithKey:@"I_TELF1" andValue:customerDetail.telf1];
    }
    if (customerDetail.certificateOffice != NULL) {
        [sapHandler addImportWithKey:@"I_RUHDA" andValue:customerDetail.certificateOffice];
    }
    if (customerDetail.certificateNumber != NULL) {
        [sapHandler addImportWithKey:@"I_RUHNO" andValue:customerDetail.certificateNumber];
    }
    if (customerDetail.customerGroup != NULL) {
        [sapHandler addImportWithKey:@"I_MUSGR" andValue:customerDetail.customerGroup];
    }
    if (customerDetail.sesGroup != NULL) {
        [sapHandler addImportWithKey:@"I_SESGR" andValue:customerDetail.sesGroup];
    }
    if (customerDetail.customerManager != NULL) {
        [sapHandler addImportWithKey:@"I_MUSOZ" andValue:customerDetail.customerFeature];
    }
    if (customerDetail.customerPosition != NULL) {
        [sapHandler addImportWithKey:@"I_MUPOZ" andValue:customerDetail.customerPosition];
    }
    if (customerDetail.locationGroup != NULL) {
        [sapHandler addImportWithKey:@"I_KDGRP" andValue:customerDetail.locationGroup];
    }
    if (customerDetail.m2 != NULL) {
        [sapHandler addImportWithKey:@"I_MKARE" andValue:customerDetail.m2];
    }
    if (customerDetail.cashRegister != NULL) {
        [sapHandler addImportWithKey:@"I_YKASA" andValue:customerDetail.cashRegister];
    }
    if (customerDetail.openM2 != NULL) {
        [sapHandler addImportWithKey:@"I_AKARE" andValue:customerDetail.openM2];
    }
    if (customerDetail.closeM2 != NULL) {
        [sapHandler addImportWithKey:@"I_KKARE" andValue:customerDetail.closeM2];
    }
    if (customerDetail.closeM2 != NULL) {
        [sapHandler addImportWithKey:@"I_VERDA" andValue:customerDetail.taxOffice];
    }
    if (customerDetail.closeM2 != NULL) {
        [sapHandler addImportWithKey:@"I_VERNO" andValue:customerDetail.taxNumber];
    }
    
    if (customerDetail.postalCode != NULL) {
        [sapHandler addImportWithKey:@"I_PKODU" andValue:customerDetail.postalCode];
    }
    
    
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
}

-(BOOL)textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch ([pickerView tag]) {
        case 1:
            return [cityList.sesGroup count];
            break;
        case 2:
            return [cityList.musozList count];
            break;
        case 3:
            return [cityList.mupozList count];
            break;
        case 4:
            return [cityList.name1List count];
            break;
        case 5:
            return [cityList.locGroup count];
            break;
        case 6:
            return [cityList.cityList count];
            break;
        case 7:
            return [[[cityList.cityList objectAtIndex:([[customerDetail stateCode] intValue] - 1)] objectAtIndex:2] count];
            break;
        default:
            break;
    }  
    return 0;
}

- (void)showCityList {
    CSCityListViewController *cityListViewController = [[CSCityListViewController alloc] initWithInformation:[customerDetail stateCode] : [customerDetail boroughCode] : customerDetail];
    [[self navigationController] pushViewController:cityListViewController animated:YES];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch ([pickerView tag]) {
        case 1:
            return [[cityList.sesGroup objectAtIndex:row] objectAtIndex:1];
            break;
        case 2:
            return [[cityList.musozList objectAtIndex:row] objectAtIndex:1];
            break;
        case 3:
            return [[cityList.mupozList objectAtIndex:row] objectAtIndex:1];
            break;
        case 4:
            return [[cityList.name1List objectAtIndex:row] objectAtIndex:1];
            break;
        case 5:
            return [[cityList.locGroup objectAtIndex:row] objectAtIndex:1];
            break;
        case 6:
            return [[cityList.cityList objectAtIndex:row] objectAtIndex:0];
            break;
        case 7:
            return [[[[cityList.cityList objectAtIndex:([[customerDetail stateCode] integerValue] - 1)] objectAtIndex:2] objectAtIndex:row] objectAtIndex:0];
            break;
        default:
            break;
    }
    
    return @"";
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        return 650;   
    } 
    else{
        return 300;
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    
    switch ([thePickerView tag]) {
        case 1:
            customerDetail.sesGroup = [[cityList.sesGroup objectAtIndex:row] objectAtIndex:1];
            break;
        case 2:
            customerDetail.customerFeature = [[cityList.musozList objectAtIndex:row] objectAtIndex:1];
            break;
        case 3:
            customerDetail.customerPosition = [[cityList.mupozList objectAtIndex:row] objectAtIndex:1];
            break;
        case 4:
            customerDetail.customerGroup = [[cityList.name1List objectAtIndex:row] objectAtIndex:1];
            break;
        case 5:
            customerDetail.locationGroup = [[cityList.locGroup objectAtIndex:row] objectAtIndex:0];
            locationGroupString = [[cityList.locGroup objectAtIndex:row] objectAtIndex:1];
            break;
        case 6:
            [countyList reloadAllComponents];
            customerDetail.state = [[cityList.cityList objectAtIndex:row] objectAtIndex:0];
            customerDetail.stateCode = [[cityList.cityList objectAtIndex:row] objectAtIndex:1];
            isCityPicked = YES;
            break;
        case 7:
            customerDetail.borough = [[[[cityList.cityList objectAtIndex:([[customerDetail stateCode] intValue]- 1)] objectAtIndex:2] objectAtIndex:row] objectAtIndex:0];
             customerDetail.boroughCode = [[[[cityList.cityList objectAtIndex:([[customerDetail stateCode] intValue]- 1)] objectAtIndex:2] objectAtIndex:row] objectAtIndex:1];
            isCountyPicked = YES;
            break;
        default:
            break;
    }
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    
    if ([[me RFCNameLine] rangeOfString:@"ZCRM_MUSTERI_MASTER" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        if ([CoreDataHandler isInternetConnectionNotAvailable]) {
            
            [super stopAnimationOnView];
            
            NSArray *customerDetailArray = [CoreDataHandler fetchCustomerDetailByKunnr:[[self myCustomer] kunnr]];
        
            if ([customerDetailArray count] > 0) {
                CDOCustomerDetail *temp = [customerDetailArray objectAtIndex:0];
                customerDetail = [[CSCustomerDetail alloc] init];
            
                [customerDetail setSaleManager:[temp saleManager]];
                [customerDetail setSaleChief:[temp saleChief]];
                [customerDetail setCustomerManager:[temp customerManager]];
                [customerDetail setSalesRepresentative:[temp salesRepresentative]];
                [customerDetail setMarketDeveloper:[temp marketDeveloper]];
                [customerDetail setStatus:[temp status]];
                [customerDetail setTitle:[temp title]];
                [customerDetail setMainStreet:[temp mainStreet]];
                [customerDetail setStreet:[temp street]];
                [customerDetail setDoorNumber:[temp doorNumber]];
                [customerDetail setNeighbourhood:[temp neighbourhood]];
                [customerDetail setPostalCode:[temp postalCode]];
                [customerDetail setDistrinct:[temp distrinct]];
                [customerDetail setBorough:[temp borough]];
                [customerDetail setState:[temp state]];
                [customerDetail setTelf1:[temp telf1]];
                [customerDetail setTaxOffice:[temp taxOffice]];
                [customerDetail setTaxNumber:[temp taxNumber]];
                [customerDetail setCertificateNumber:[temp certificateNumber]];
                [customerDetail setCertificateOffice:[temp certificateOffice]];
                [customerDetail setCustomerGroup:[temp customerGroup]];
                [customerDetail setSesGroup:[temp sesGroup]];
                [customerDetail setCustomerFeature:[temp customerFeature]];
                [customerDetail setCustomerPosition:[temp customerPosition]];
                [customerDetail setEfesContract:[temp efesContract]];
                [customerDetail setLocationGroup:[temp locationGroup]];
                [customerDetail setM2:[temp m2]];
                [customerDetail setCashRegister:[temp cashRegister]];
                [customerDetail setOpenM2:[temp openM2]];
                [customerDetail setCloseM2:[temp closeM2]];
            
                [self initTextFields];
            
                [tableView reloadData];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Girmiş olduğunuz müşteri çevrimdışı destek için cihazınızda kayıtlı değildir." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setTag:2];
                [alert show];
            }
        }
    else
    {
        if (isCustomerAvailable == NO) {
            
            isCustomerAvailable = YES;
            [self initCustomerDetails:myResponse];
            
        }

        }
    }
    if ([[me RFCNameLine] rangeOfString:@"ZCRM_MUSTERI_MASTER_DEGISIKLIK" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSArray *arr = [ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse];
        NSString *boolValue;
        
        if ([arr count] > 0) {
            boolValue = [arr objectAtIndex:0];
            if ([boolValue isEqualToString:@"T"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müşteri bilgileri için yaptığınız değişiklik başarılıyla tamamlanmıştır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müşteri bilgileri için yaptığınız değişiklik başarısız olmuştur." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
                [alert show];
            }
        }

    }
    
}

- (void)initCustomerDetails:(NSString*)aResponse {
    
    
    customerDetail = [[CSCustomerDetail alloc] init];
    
    NSArray *arr = [ABHXMLHelper getValuesWithTag:@"SATMD" fromEnvelope:aResponse];
    
    if (!([arr count] > 0)) {
        return;
    }
    
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
    [customerDetail setEfesContract:[[ABHXMLHelper getValuesWithTag:@"EFSOZ" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setLocationGroup:[[ABHXMLHelper getValuesWithTag:@"KGRUP" fromEnvelope:aResponse] objectAtIndex:0]];
    locationGroupString = customerDetail.locationGroup;
    [customerDetail setM2:[[ABHXMLHelper getValuesWithTag:@"MKARE" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCashRegister:[[ABHXMLHelper getValuesWithTag:@"YKASA" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setOpenM2:[[ABHXMLHelper getValuesWithTag:@"AKARE" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setCloseM2:[[ABHXMLHelper getValuesWithTag:@"KKARE" fromEnvelope:aResponse] objectAtIndex:0]];
    CSDealer *dealer = [[CSDealer alloc] init];
    dealer.name1 = [[ABHXMLHelper getValuesWithTag:@"BADIT" fromEnvelope:aResponse] objectAtIndex:0];
    dealer.kunnr = [[ABHXMLHelper getValuesWithTag:@"BADIS" fromEnvelope:aResponse] objectAtIndex:0];
    customerDetail.dealer = dealer;
    
    [tableView reloadData];
    
    if ([customerDetail.status isEqualToString:@"Aktif"]) {
        [segmentedControl setSelectedSegmentIndex:0];
    }else{
        if ([customerDetail.status isEqualToString:@"Pasif"]) {
            [segmentedControl setSelectedSegmentIndex:1];
        }
        else{
            [segmentedControl setSelectedSegmentIndex:2];
        }
    }
    
    NSArray *arr2 = [ABHXMLHelper getValuesWithTag:@"EX_RETURN" fromEnvelope:aResponse];
    
    if([arr2 count] > 0)
    {
        NSString *boolValue = [arr2 objectAtIndex:0];
        if ([boolValue isEqualToString:@"T"]) {
            canEditCustomer = YES;
        }
        else
            canEditCustomer = NO;
    }
    
    [customerDetail setStateCode:[[ABHXMLHelper getValuesWithTag:@"E_ILKOD" fromEnvelope:aResponse] objectAtIndex:0]];
    [customerDetail setBoroughCode:[[ABHXMLHelper getValuesWithTag:@"E_ILCEKOD" fromEnvelope:aResponse] objectAtIndex:0]];

    [self initTextFields];
    
    [self saveCustomerDetailToCoreData:customerDetail];

}

# pragma mark - Navigation methods

- (void)navigateToCustomer {
    
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver >= 6.0) {
        // Only executes on version 3 or above.
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        
        [locationManager setDelegate:self];
        
        [locationManager startUpdatingLocation];
        
        MKMapItem *currentLocationItem = [MKMapItem mapItemForCurrentLocation];
        
        if (myCustomer.locationCoordinate.coordinate.latitude == 0 || myCustomer.locationCoordinate.coordinate.longitude == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Seçtiğiniz müşteri için navigasyon özelliği yoktur." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:myCustomer.locationCoordinate.coordinate addressDictionary:nil];
            
            MKMapItem *destinamtionLocItem = [[MKMapItem alloc] initWithPlacemark:place];
            
            destinamtionLocItem.name = [myCustomer name1];
            
            NSArray *mapItemsArray = [NSArray arrayWithObjects:currentLocationItem, destinamtionLocItem, nil];
            
            NSDictionary *dictForDirections = [NSDictionary dictionaryWithObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
            
            [MKMapItem openMapsWithItems:mapItemsArray launchOptions:dictForDirections];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Seçtiğiniz özelliği kullanabilmek için, versiyon güncellemesi yapmanız gerekmektedir." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


# pragma mark - Core Data methods

- (void)saveCustomerDetailToCoreData:(CSCustomerDetail *)aCustomerDetail {
    
    NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[myCustomer kunnr]];
    
    if ([arr count] > 0) {
        return;
    }
    
    CDOCustomerDetail *cust = (CDOCustomerDetail *)[CoreDataHandler insertEntityData:@"CDOCustomerDetail"];
    
    [cust setSaleManager:[aCustomerDetail saleManager]];
    [cust setSaleChief:[aCustomerDetail saleChief]];
    [cust setCustomerManager:[aCustomerDetail customerManager]];
    [cust setSalesRepresentative:[aCustomerDetail salesRepresentative]];
    [cust setMarketDeveloper:[aCustomerDetail marketDeveloper]];
    [cust setStatus:[aCustomerDetail status]];
    [cust setTitle:[aCustomerDetail title]];
    [cust setMainStreet:[aCustomerDetail mainStreet]];
    [cust setStreet:[aCustomerDetail street]];
    [cust setDoorNumber:[aCustomerDetail doorNumber]];
    [cust setNeighbourhood:[aCustomerDetail neighbourhood]];
    [cust setPostalCode:[aCustomerDetail postalCode]];
    [cust setDistrinct:[aCustomerDetail distrinct]];
    [cust setDistrinctCode:[aCustomerDetail distrinctCode]];
    [cust setBorough:[aCustomerDetail borough]];
    [cust setBoroughCode:[aCustomerDetail boroughCode]];
    [cust setState:[aCustomerDetail state]];
    [cust setStateCode:[aCustomerDetail stateCode]];
    [cust setTelf1:[aCustomerDetail telf1]];
    [cust setTaxOffice:[aCustomerDetail taxOffice]];
    [cust setTaxNumber:[aCustomerDetail taxNumber]];
    [cust setCertificateOffice:[aCustomerDetail certificateOffice]];
    [cust setCertificateNumber:[aCustomerDetail certificateNumber]];
    [cust setCustomerGroup:[aCustomerDetail customerGroup]];
    [cust setSesGroup:[aCustomerDetail sesGroup]];
    [cust setCustomerFeature:[aCustomerDetail customerFeature]];
    [cust setCustomerPosition:[aCustomerDetail customerPosition]];
    [cust setLocationGroup:[aCustomerDetail locationGroup]];
    [cust setEfesContract:[aCustomerDetail efesContract]];
    [cust setM2:[aCustomerDetail m2]];
    [cust setCashRegister:[aCustomerDetail cashRegister]];
    [cust setOpenM2:[aCustomerDetail openM2]];
    [cust setCloseM2:[aCustomerDetail closeM2]];
    
    [cust setKunnr:[myCustomer kunnr]];
    [cust setName1:[myCustomer name1]];
    
    [CoreDataHandler saveEntityData];
}


- (UITableViewCell *)dealerTableView:(int)row andCell:(UITableViewCell *)cell {
    
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    switch (row) {
        
        case 0:
            cell.textLabel.text = @"Müşteriye Götür";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.textLabel.text = @"Müşteri Satışları";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            break;
        case 2:
            cell.textLabel.text = @"Soğutucular";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 3:
            cell.textLabel.text = @"Nokta Ziyaret Listesi";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
//        case 4:
//            cell.textLabel.text = @"Finansal Yapı";
//            cell.detailTextLabel.text = @"";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            break;
        case 4:
            cell.textLabel.text = @"Satış Müdürlüğü";
            cell.detailTextLabel.text = customerDetail.saleManager;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            break;
        case 5:
            cell.textLabel.text = @"Satış Şefliği";
            cell.detailTextLabel.text = customerDetail.saleChief;
            cell.accessoryType=UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            break;
        case 6:
            cell.textLabel.text = @"Nokta Yöneticisi";
            cell.detailTextLabel.text = customerDetail.customerManager;
            cell.accessoryType=UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            break;
        case 7:
            cell.textLabel.text = @"Bayi/Dist.";
            cell.detailTextLabel.text = customerDetail.dealer.name1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            break;
        case 8:
            cell.textLabel.text = @"Durum";
            //cell.detailTextLabel.text = customerDetail.status;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.accessoryView = segmentedControl;
            break;
        case 9:
            cell.textLabel.text = @"Cadde";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            mainStreet.delegate = self;
            mainStreet.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            mainStreet.textAlignment = UITextAlignmentLeft;

            cell.accessoryView = mainStreet;
            //mainStreet.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            // return cell;
            break;
        case 10:
            cell.textLabel.text = @"Sokak";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            street.delegate = self;
            street.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            street.textAlignment = UITextAlignmentRight;
        
            cell.accessoryView = street;
            break;
        case 11:
            cell.textLabel.text = @"Mahalle/Köy";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            neighbour.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            neighbour.textAlignment = UITextAlignmentRight;

            neighbour.delegate = self;
            cell.accessoryView = neighbour;
            break;
        case 12:
            cell.textLabel.text = @"Semt";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = customerDetail.distrinct;
            district.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            district.textAlignment = UITextAlignmentRight;
            district.text = customerDetail.distrinct;
            
            district.delegate = self;
            break;
        case 13:
            cell.textLabel.text = @"İl";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = [customerDetail state];
            break;
        case 14:
            cell.textLabel.text = @"Telf.1";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            telNumber.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            telNumber.textAlignment = UITextAlignmentRight;
            
            
            telNumber.delegate = self;
            [telNumber setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = telNumber;
            break;
        case 15:
            cell.textLabel.text = @"Ver. Dairesi";
            cell.detailTextLabel.text = customerDetail.taxOffice;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 16:
            cell.textLabel.text = @"Ver. No";
            cell.detailTextLabel.text = customerDetail.taxNumber;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        default:
            break;
    }
    
    return cell;
}
#pragma mark - Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    if (isDealer) {
        return 17;
    }
    else
        return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    else {
        [[cell detailTextLabel] setText:@""];
        [cell setAccessoryView:nil];
        [[cell textLabel] setText:@""];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (isDealer) {
       cell = [self dealerTableView:row andCell:cell];
    }
    if (section == 0 && !isDealer) {
        
        int sayac = 0;
        
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        if (sayac == indexPath.row) {
            cell.textLabel.text = @"Müşteriye Götür";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müşteri Satışları";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Soğutucular";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Nokta Ziyaret Listesi";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Satış Müdürlüğü";
            cell.detailTextLabel.text = customerDetail.saleManager;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Satış Şefliği";
            cell.detailTextLabel.text = customerDetail.saleChief;
            cell.accessoryType=UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Nokta Yöneticisi";
            cell.detailTextLabel.text = customerDetail.customerManager;
            cell.accessoryType=UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Satış Temsilcisi";
            cell.detailTextLabel.text = customerDetail.salesRepresentative;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Pazar Geliştirme";
            cell.detailTextLabel.text = customerDetail.marketDeveloper;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Bayi/Dist.";
            cell.detailTextLabel.text = customerDetail.dealer.name1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Durum";
            //cell.detailTextLabel.text = customerDetail.status;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.accessoryView = segmentedControl;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Ünvan";
            cell.detailTextLabel.text = customerDetail.title;
            cell.accessoryView = nil;
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Cadde";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            mainStreet.delegate = self;
            mainStreet.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            mainStreet.textAlignment = UITextAlignmentRight;

            cell.accessoryView = mainStreet;
            //mainStreet.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Sokak";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            street.delegate = self;
            street.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            street.textAlignment = UITextAlignmentRight;

            cell.accessoryView = street;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Kapı No";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [doorNumber setKeyboardType:UIKeyboardTypeNumberPad];
            doorNumber.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            doorNumber.textAlignment = UITextAlignmentRight;

            doorNumber.delegate = self;
            cell.accessoryView = doorNumber;
            
            // return cell;
        }
        sayac++;
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Mahalle/Köy";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            neighbour.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            neighbour.textAlignment = UITextAlignmentRight;

            neighbour.delegate = self;
            cell.accessoryView = neighbour;    
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Posta Kodu";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            postalCode.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            postalCode.textAlignment = UITextAlignmentRight;

            [postalCode setKeyboardType:UIKeyboardTypeNumberPad];
            postalCode.delegate = self;
            cell.accessoryView = postalCode;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Semt";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = customerDetail.distrinct;
            district.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            district.textAlignment = UITextAlignmentRight;

            
            district.text = customerDetail.distrinct;
            
            district.delegate = self;
            //ata bu değişicek!
            //cell.accessoryView = district;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"İlçe";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = [customerDetail borough];
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"İl";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = [customerDetail state];
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Telf.1";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            telNumber.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            telNumber.textAlignment = UITextAlignmentRight;

            
            telNumber.delegate = self;
            [telNumber setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = telNumber;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Ver. Dairesi";
            cell.detailTextLabel.text = customerDetail.taxOffice;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Ver. No";
            cell.detailTextLabel.text = customerDetail.taxNumber;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Ruh Daire";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            certificateOffice.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            certificateOffice.textAlignment = UITextAlignmentRight;

            certificateOffice.delegate = self;
            cell.accessoryView = certificateOffice;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Ruh. No";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            certificateNumber.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            certificateNumber.textAlignment = UITextAlignmentRight;

            certificateNumber.delegate = self;
            cell.accessoryView = certificateNumber;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müş. Grubu";
            cell.detailTextLabel.text = customerDetail.customerGroup;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"SES Grubu";
            cell.detailTextLabel.text = customerDetail.sesGroup;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müş. Özelliği";
            cell.detailTextLabel.text = customerDetail.customerFeature;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Müşteri Po";
            cell.detailTextLabel.text = customerDetail.customerPosition;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Konum Grubu";
            cell.detailTextLabel.text = locationGroupString;/// ata?
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Efes Söz.";
            cell.detailTextLabel.text = customerDetail.efesContract;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            cell.textLabel.text = @"Metrekare";
            cell.selectionStyle = UITableViewCellSelectionStyleNone; 
            metreSquare.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            metreSquare.textAlignment = UITextAlignmentRight;
            
            metreSquare.delegate = self;
            [metreSquare setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.detailTextLabel setText:customerDetail.m2];
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Yazarkasa";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cashRegister.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            cashRegister.textAlignment = UITextAlignmentRight;

            cashRegister.delegate = self;
            [cashRegister setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = cashRegister;
            
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Açık M2";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            openm2.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            openm2.textAlignment = UITextAlignmentRight;

            openm2.delegate = self;
            [openm2 setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = openm2;
            // return cell;
        }
        sayac++;
        
        if(sayac == indexPath.row)
        {
            
            cell.textLabel.text = @"Kapalı M2";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            closedm2.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            closedm2.textAlignment = UITextAlignmentRight;

            
            closedm2.delegate = self;
            [closedm2 setKeyboardType:UIKeyboardTypeNumberPad];
            cell.accessoryView = closedm2;
            
            // return cell;
        }
        sayac++;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    
    if (row == 0 && ![CoreDataHandler isInternetConnectionNotAvailable]) {
        [self navigateToCustomer];
    }
    
    if (row == 1) {
        [self viewSalesChart:self];
        return;
    }
    if (row == 2) {
        [self viewCoolers];
        return;
    }
    if (row == 3) {
        [self viewVisitList];
        return;
    }
//    if (row == 4 && isDealer) {
//        [self showRiskAnalysis];
//    }
//    if (isDealer)
//        row--;
    
    if (isFieldsEditable == YES) {
        switch (row) {
//            case 17:
//                [self showCityList];
//                break;
//            case 18:
//                [activePicker removeFromSuperview];
//                [doneButton setEnabled:YES];
//                [doneButton setHidden:NO];
//                activePicker = countyList;
//                [doneButton setTitle:@"İl Seç" forState:UIControlStateNormal];
//                [self.view addSubview:countyList];
//                break;
//            case 19:
//                [activePicker removeFromSuperview];
//                [doneButton setEnabled:YES];
//                [doneButton setHidden:NO];
//                activePicker = cityPickerList;
//                [doneButton setTitle:@"İlçe Seç" forState:UIControlStateNormal];
//                [self.view addSubview:cityPickerList];
//                break;
//            case 19:
//            {
//                taxOffice.taxNumber = customerDetail.taxNumber;
//                taxOffice.taxOffice = customerDetail.taxOffice;
//                taxOffice.flag = NO;
//                [self.navigationController pushViewController:taxOffice animated:YES];
//                break;
//            }
            case 25:
                [activePicker removeFromSuperview];
                [doneButton setEnabled:YES];
                [doneButton setHidden:NO];
                activePicker = customerGroup;
                [self.view addSubview:customerGroup];
                break;
            case 26:
                [activePicker removeFromSuperview];
                [doneButton setEnabled:YES];
                [doneButton setHidden:NO];
                activePicker = sesGroup;
                [self.view addSubview:sesGroup];
                break;
            case 27:
                [activePicker removeFromSuperview];
                [doneButton setEnabled:YES];
                [doneButton setHidden:NO];
                activePicker = customerFeature;
                [self.view addSubview:customerFeature];
                break;
            case 28:
                [activePicker removeFromSuperview];
                [doneButton setEnabled:YES];
                [doneButton setHidden:NO];
                activePicker = customerPosition;
                [self.view addSubview:customerPosition];
                break;
            case 29:
                [activePicker removeFromSuperview];
                [doneButton setEnabled:YES];
                [doneButton setHidden:NO];
                activePicker = locationGroup;
                [self.view addSubview:locationGroup];
                break;
            default:
                break;
        }
    }
    
    if (row == 30 && !([customerDetail.efesContract isEqualToString:@"Analiz yok"])) {
        
        contractViewController = [[CSContractAnalysisViewController alloc] initWithUser:user andSelectedCustomer:myCustomer];
        
        [self.navigationController pushViewController:contractViewController animated:YES];
    }

}

- (void)CSCityListCompleted {
    [super stopAnimationOnView];
}

- (BOOL)checkCustomerInScope:(CSCustomer*)aCustomer {
   /*
    if (!([user.customers count] > 0)) {
        
    }
    
    for (int sayac = 0 ; sayac < [user.customers count]; sayac++) {
        CSCustomer *tempCust = [user.customers objectAtIndex:sayac];
        if ([myCustomer.kunnr isEqualToString:tempCust.kunnr] ) {
            return  YES;
        }
    }
    return NO;
    */
    if (isDealer)
        return NO;
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        return NO;
    }
    
    return canEditCustomer;
}

- (void)getCustomerDetails:(CSCustomer*)aCustomer{
    //ZCRM_MUSTERI_MASTER
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZCRM_MUSTERI_MASTER"];
    // [sapHandler addImportWithKey:@"I_UNAME" andValue:[user.username]];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:[myCustomer kunnr]];
 //   [sapHandler addImportWithKey:@"I_EDITABLE" andValue:@"X"];
    [super playAnimationOnView:self.view];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    customerDetail = [[CSCustomerDetail alloc] init];
    [self getCustomerDetails:myCustomer];
    [name1Label setText:myCustomer.name1];
    //[name1Label setTextColor:[CSApplicationProperties getUsualTextColor]];
    [kunnrLabel setText:myCustomer.kunnr];
    //[kunnrLabel setTextColor:[CSApplicationProperties getUsualTextColor]];
    [doneButton setBackgroundColor:[CSApplicationProperties getEfesBlueColor]];
    [doneButton setEnabled:NO];
    [doneButton setHidden:YES];
    
    isCustomerAvailable = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CSCityListCompleted) name:@"cityListCompleted" object:nil];

    if (![CoreDataHandler isInternetConnectionNotAvailable]) {
        if (![super isAnimationRunning]) {
            [super playAnimationOnView:[self view]];
        }
        
        cityList = [CSCityList getCityList];
    
        if ([cityList.cityList count] < 1) {
            [cityList allocateMethods];
        }
        else
        {
            [super stopAnimationOnView];
        }
    }
    
    int row = 2;
    
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;
    if (myCustomer.locationCoordinate != nil) {
        [mapView setHidden:NO];
        MKAnnotationView *ann = [[MKAnnotationView alloc] initWithAnnotation:[myCustomer locationCoordinate] reuseIdentifier:@""];
        [self->mapView addAnnotation:ann];
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
                         @"İptal",
                         nil]];
    [segmentedControl addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    
    sesGroup = [[UIPickerView alloc]init];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        sesGroup.frame = 	CGRectMake(0, 775, 800, 180);   
    } 
    else{
        sesGroup.frame = 	CGRectMake(0, 240, 320, 180);
    }
    
    sesGroup.tag = 1;
    sesGroup.delegate = self;
    sesGroup.showsSelectionIndicator = YES;
    
    
    
    customerFeature = [[UIPickerView alloc]init];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        customerFeature.frame = 	CGRectMake(0, 775, 800, 180);   
    } 
    else{
        customerFeature.frame = 	CGRectMake(0, 240, 320, 180);
    }
    
    customerFeature.tag = 2;
    customerFeature.delegate = self;
    customerFeature.showsSelectionIndicator = YES;
    
    
    
    customerPosition = [[UIPickerView alloc]init];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        customerPosition.frame = 	CGRectMake(0, 775, 800, 180);   
    } 
    else{
        customerPosition.frame = 	CGRectMake(0, 240, 320, 180);
    }
    
    customerPosition.tag = 3;
    customerPosition.delegate = self;
    customerPosition.showsSelectionIndicator = YES;
    
    customerGroup = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        customerGroup.frame = 	CGRectMake(0, 775, 800, 180);   
    } 
    else{
        customerGroup.frame = 	CGRectMake(0, 240, 320, 180);
    }
    
    customerGroup.tag = 4;
    customerGroup.delegate = self;
    customerGroup.showsSelectionIndicator = YES;

    locationGroup = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        locationGroup.frame = 	CGRectMake(0, 775, 800, 180);   
    } 
    else{
        locationGroup.frame = 	CGRectMake(0, 240, 320, 180);
    }
    
    locationGroup.tag = 5;
    locationGroup.delegate = self;
    locationGroup.showsSelectionIndicator = YES;
    
    cityPickerList = [[UIPickerView alloc]init];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        cityPickerList.frame = 	CGRectMake(0, 775, 800, 180);   
    } 
    else{
        cityPickerList.frame = 	CGRectMake(0, 240, 320, 180);
    }
    cityPickerList.tag = 6;
    cityPickerList.delegate = self;
    cityPickerList.showsSelectionIndicator = YES;
    
    countyList = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 240, 320, 200)];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        countyList.frame = 	CGRectMake(0, 775, 800, 180);   
    } 
    else{
        countyList.frame = 	CGRectMake(0, 240, 320, 180);
    }
    countyList.tag = 7;
    countyList.delegate = self;
    countyList.showsSelectionIndicator = YES;
    
    [segmentedControl setSelectedSegmentIndex:2];
    
    activePicker = cityPickerList;
    
    [self toggleFields:NO];
    
    taxOffice = [[CSTaxOfficeViewController alloc] initWithNibName:@"CSTaxOfficeViewController" bundle:[NSBundle mainBundle]];
    
     newCoordinateLocationViewController = [[CSNewCoordinateLocationViewController alloc] initWithUser:user andCustomer:myCustomer];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //burayi sabit stringle yapcaz
    MKAnnotationView *annotationView = nil;
    annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"musteri"];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"musteri"];
    }
    [annotationView setImage:[UIImage imageNamed:[self getAnnotationPngNameFromCustomer:myCustomer]]];
    
    
    return annotationView;   
}
- (NSString*) getAnnotationPngNameFromCustomer:(CSCustomer*)activeCustomer{
    if ([activeCustomer.other isEqualToString:@"03"]) {
        return @"greenCustomerIconSmall.png";
    }
    if ([activeCustomer.relationship isEqualToString:@"04"] || [activeCustomer.relationship isEqualToString:@"05"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            
            return @"sariEv.png";
        }else{
           
            return @"maviEvIcon.png";
        }
    }
    
    if ([activeCustomer.type isEqualToString:@"acik"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return@"iconYellowOpen.png";
        }
        else{
            return@"beerIcon.png";
        }
    }
    else if ([activeCustomer.type isEqualToString:@"kapali"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return @"iconYellowClosed.png";
        }
        else{
            return @"iconKapali.png";
        }
    }
    else if ([activeCustomer.type isEqualToString:@"bira"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return @"iconYellowBeer.png";
        }
        else{
            return @"iconBira.png";
        }
    }else if ([activeCustomer.type isEqualToString:@"ekomini"]) {
        if ([activeCustomer.hasPlan isEqualToString:@"X"]) {
            return @"ekominiKucukSari.png";
        }
        else{
            return @"ekominiKucukMavi";
        }
    }
}

- (void)segmentValueChanged {
    if ([segmentedControl selectedSegmentIndex]== 2) {
        cancelInfoViewController = [[CSCancelationInfoViewController alloc] initWithNibName:@"CSCancelationInfoViewController" bundle:[NSBundle mainBundle]];
        cancelInfoViewController.customerViewController = self;
        [self.navigationController pushViewController:cancelInfoViewController animated:YES];
    }     
}
- (void)viewWillAppear:(BOOL)animated{
    //when returning from charting view
    
//    CGRect temp = self.navigationController.view.frame;//w320h480
//    CGRect temp2 = self.tabBarController.navigationController.view.frame;//w320h480
//    CGRect temp3 = self.navigationController.navigationBar.frame;
//    CGRect temp4 = [[self mapView] frame];
//    
//    if (temp.size.height == 500 || temp.size.height == 1200) {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        self.tabBarController.navigationController.view.frame = CGRectMake(0,0,768,1024);
//        self.navigationController.view.frame = CGRectMake(0,0,768,1024);
//        self.navigationController.navigationBar.frame = CGRectMake(0,20,768,44);
//    }
//    else {
//        self.tabBarController.navigationController.view.frame = CGRectMake(0,0,320,480);
//        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
//        self.navigationController.view.frame = CGRectMake(0, 0, 320, 480);
//        
//        CGRect temp = mapView.frame;
//        temp.origin.y = temp.origin.y - 30;
//        [mapView setFrame:temp];
//    }
//    }
    
    if (taxOffice.flag == YES) {
        customerDetail.taxNumber = taxOffice.changedText;
        [tableView reloadData];
    }
    
    if (newCoordinateLocationViewController.flag == 1) {
        newCoordinateLocationViewController.flag = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" message:@"Müşteri lokasyonu için yaptığınız değişiklik başarılıyla tamamlanmıştır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
    }
    if (newCoordinateLocationViewController.flag == 2) {
        newCoordinateLocationViewController.flag = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müşteri lokasyonu için yaptığınız değişiklik başarısız olmuştur." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
    }
    [[self  navigationItem] setTitle:@"Müşterim"];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Ziyaret Girişi" style:UIBarButtonItemStyleBordered target:self action:@selector(checkIn)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
    
    [[self tableView] reloadData];
    
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