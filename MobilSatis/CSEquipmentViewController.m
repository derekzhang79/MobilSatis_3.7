//
//  CSEquipmentViewController.m
//  MobilSatis
//
//  Created by ABH on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "CSEquipmentViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CSEquipmentViewController ()

@end

@implementation CSEquipmentViewController
@synthesize coolers;
@synthesize other_coolers;
@synthesize table;
@synthesize customer;
@synthesize efesOtherSegmentControl;
@synthesize isEfesActive;
@synthesize barButton;
@synthesize resultText;
@synthesize resultImage;
@synthesize isStockTakingActive;
@synthesize stockTakingArray;
@synthesize selectedRow;
@synthesize selectedCooler;
@synthesize barcodeText;
@synthesize isStockTakingTime;
@synthesize isCoolerAddition;
@synthesize textField;
@synthesize otherCoolerList;
@synthesize pickerView;
@synthesize pickerViewButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer{
    self  = [super initWithUser:myUser];
    customer = aCustomer;
    isEfesActive = YES;
    return self;
}

- (IBAction)segmentTapped:(id)sender{
        
    UISegmentedControl *myControl = (UISegmentedControl*) sender;
    if ([myControl selectedSegmentIndex] == 0) {
        self.isEfesActive = YES;
        [table  reloadData];
    }
    if ([myControl selectedSegmentIndex] == 1) {
        self.isEfesActive = NO;
        [table  reloadData];
    }
}

- (void)getCoolersFromSap {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_COOLERS_OF_CUSTOMER"];
    
    [sapHandler addImportWithKey:@"CUSTOMER" andValue:customer.kunnr];
    [sapHandler addImportWithKey:@"P_DIGER" andValue:@"X"];
    [sapHandler addImportWithKey:@"P_ADD" andValue:@"X"];
    [sapHandler addTableWithName:@"COOLERS" andColumns:[NSMutableArray arrayWithObjects:@"TANIM",@"SERIAL_NUMBER",@"TYPE", nil]];
    [sapHandler addTableWithName:@"OTHER_COOLERS" andColumns:[NSMutableArray arrayWithObjects:@"PRODUCT_ID", @"TANIM",@"MIKTAR", nil]];
    [sapHandler addTableWithName:@"OTHER_COOLER_LIST" andColumns:[NSMutableArray arrayWithObjects:@"URUNID", @"TANIM", @"TIP", nil]];
    [super playAnimationOnView:self.view];

    [sapHandler prepCall];
    //[activityIndicator startAnimating];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    [super stopAnimationOnView];

    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        
        coolers = [[NSMutableArray alloc] init];
        other_coolers = [[NSMutableArray alloc] init];
        
        NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
        CDOCustomerDetail *tempCust;
        
        if ([arr count] > 0) {
            tempCust = [arr objectAtIndex:0];
        }
        
        for (CDOCooler *tempCooler in [tempCust coolers]) {
            CSCooler *temp = [[CSCooler alloc] init];
            
            [temp setSernr:[tempCooler sernr]];
            [temp setDescription:[tempCooler desc]];
            [temp setType:[tempCooler type]];
            
            [coolers addObject:temp];
        }
        
        for (CDOCooler *tempCooler in [tempCust otherCoolers]) {
            CSCooler *temp = [[CSCooler alloc] init];
            
            [temp setDescription:[tempCooler desc]];
            [temp setQuantity:[tempCooler quantity]];
            [temp setSernr:[tempCooler sernr]];
            
            [other_coolers addObject:temp];
        }
        
        [table reloadData];
    }
    else
    {
        if ([[me RFCNameLine] rangeOfString:@"ZMOB_GET_COOLERS_OF_CUSTOMER" options:NSCaseInsensitiveSearch].location != NSNotFound) {
       
            NSString *stockTime = [[ABHXMLHelper getValuesWithTag:@"EX_RETURN" fromEnvelope:myResponse] objectAtIndex:0];
        
            if ([stockTime isEqualToString:@"S"]) {
                [self stockTakingTime];
            }
        
            [self initEfesCoolersWithEnvelope:[[ABHXMLHelper getValuesWithTag:@"ZMOB_TEYIT_ITM_STR" fromEnvelope:myResponse] objectAtIndex:0]];
            [self initOtherCoolersWithEnvelope:[[ABHXMLHelper getValuesWithTag:@"ZMOB_OTHR_COOLER" fromEnvelope:myResponse] objectAtIndex:0]];
            [self initOtherCoolerListWithEnvelope:[[ABHXMLHelper getValuesWithTag:@"ZMOB_COOLER_STR" fromEnvelope:myResponse] objectAtIndex:0]];
            [self checkExistingCoreDataToDelete];
            [self saveCoolerListToCoreData];
        }
    
        else if ([[me RFCNameLine] rangeOfString:@"ZMOB_COOLER_UPDATE" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
            NSString *buff = [[ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse] objectAtIndex:0];
                
            if ([buff isEqualToString:@"T"])
            {
                [self coolerStockConfirm:YES];
                if (!isStockTakingTime) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"İşlem Başarılı." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                }
            }
            else if ([buff isEqualToString:@"N"])
            {
                NSString *name1 = [[ABHXMLHelper getValuesWithTag:@"E_NAME1" fromEnvelope:myResponse] objectAtIndex:0];
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:[NSString stringWithFormat:@"Ekleyemeye çalıştığınız soğutucu %@ isimli müşteriye ait. Değiştirmek istediğinize emin misiniz ?",name1] delegate:self cancelButtonTitle:@"İptal" otherButtonTitles:@"Onayla", nil];
                alert.tag = 5;
                [alert show];
            
            }
            else
            {
                [self coolerStockConfirm:NO];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"İşlem Başarısız." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                alert.tag = 2;
                [alert show];
            }
            if (isStockTakingTime) {
                BOOL checker = [self isAllCoolerStockConfirm];
            
                if (checker) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"Bütün Soğutucular sayıldı." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                    [[self navigationItem] setHidesBackButton:NO animated:YES];
                }
            }

        }
    
        else if ([[me RFCNameLine] rangeOfString:@"ZMOB_SET_OTHER_COOLERS" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSString *otherBuff = [[ABHXMLHelper getValuesWithTag:@"E_OTHER_RETURN" fromEnvelope:myResponse] objectAtIndex:0];
        
            if ([otherBuff isEqual:@"T"])
            {
                if (isCoolerAddition)
                {
                    isCoolerAddition = NO;
                }
                else
                    [self coolerStockConfirm:YES];
            
                if (!isStockTakingTime)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"İşlem Başarılı." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"İşlem Başarısız." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                alert.tag = 2;
                [alert show];
            }
            if (isStockTakingTime) {
                BOOL checker = [self isAllCoolerStockConfirm];
            
                if (checker) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"Bütün Soğutucular sayıldı." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                    [[self navigationItem] setHidesBackButton:NO animated:YES];
                }
            }

        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [otherCoolerList count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([otherCoolerList count] > 0) 
        return [[otherCoolerList objectAtIndex:row] description];
    
    return @"";
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [selectedCooler setDescription:[[otherCoolerList objectAtIndex:row] description]];
    [selectedCooler setSernr:[[otherCoolerList objectAtIndex:row] sernr]];
}


- (void)stockTakingTime {
    
    if (!isStockTakingTime) {
        self.isStockTakingTime = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"Sayım dönemi açılmıştır. Bütün soğutucuları saymak istediğinize emin misin ?" delegate:self cancelButtonTitle:@"Geri" otherButtonTitles:@"Tamam", nil];
        alert.tag = 3;
        [alert show];
    }
}

- (void)initEfesCoolersWithEnvelope:(NSString*)envelope{
    
    NSMutableArray *item_count = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *descriptions = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:envelope];
    NSMutableArray *serial_number = [ABHXMLHelper getValuesWithTag:@"SERIAL_NUMBER" fromEnvelope:envelope];
    NSMutableArray *type = [ABHXMLHelper getValuesWithTag:@"TYPE" fromEnvelope:envelope];
    
    for (int i = 0; i < [item_count count]; i++) {
        
        CSCooler *cooler = [[CSCooler alloc] init];
        
        [cooler setDescription:[descriptions objectAtIndex:i]];
        [cooler setSernr:[serial_number objectAtIndex:i]];
        [cooler setType:[type objectAtIndex:i]];
        
        [coolers addObject:cooler];
    }
    [table  reloadData];
}

- (void)initOtherCoolersWithEnvelope:(NSString*)envelope{
    
    NSMutableArray *item_count = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *product_id = [ABHXMLHelper getValuesWithTag:@"PRODUCT_ID" fromEnvelope:envelope];
    NSMutableArray *descriptions = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:envelope];
    NSMutableArray *miktar = [ABHXMLHelper getValuesWithTag:@"MIKTAR" fromEnvelope:envelope];
    
    for (int i = 0; i < [item_count count]; i++) {
        
        CSCooler *cooler = [[CSCooler alloc] init];
        
        [cooler setDescription:[descriptions objectAtIndex:i]];
        [cooler setSernr:[NSString stringWithFormat:@"%@",[ABHXMLHelper correctNumberValue:[product_id objectAtIndex:i]]]];
        [cooler setQuantity:[miktar objectAtIndex:i]];
        
        [other_coolers addObject:cooler];
    }
    
}

- (void)initOtherCoolerListWithEnvelope:(NSString*)envelope {
    NSMutableArray *item_count = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *product_id = [ABHXMLHelper getValuesWithTag:@"URUNID" fromEnvelope:envelope];
    NSMutableArray *descriptions = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:envelope];

    for (int i = 0; i < [item_count count]; i++) {
        
        CSCooler *cooler = [[CSCooler alloc] init];
        
        [cooler setDescription:[descriptions objectAtIndex:i]];
        [cooler setSernr:[NSString stringWithFormat:@"%@",[ABHXMLHelper correctNumberValue:[product_id objectAtIndex:i]]]];
        
        [otherCoolerList addObject:cooler];
    }
}

- (void)beginStockTaking {
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        return;
    }
    isStockTakingActive = YES;
    [[self navigationItem] setRightBarButtonItem:nil];

    [table reloadData];
}

- (void)sendUpdatedCoolerInformation:(NSString *)kunnr{
    
    //ZCRM_MUSTERI_MASTER
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_COOLER_UPDATE"];
    
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:kunnr];
    [sapHandler addImportWithKey:@"I_BARKOD_BOZUK" andValue:selectedCooler.barcodeFailed];
    if (isCoolerAddition) {
        [sapHandler addImportWithKey:@"I_SERNR" andValue:@" "];
        [sapHandler addImportWithKey:@"I_ADD" andValue:@"X"];
        isCoolerAddition = NO;
    }
    else
        [sapHandler addImportWithKey:@"I_SERNR" andValue:[selectedCooler sernr]];
    
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
    
}

- (void)sendOtherCoolerInformation:(NSString *)kunnr:(NSString *) quantity{
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_SET_OTHER_COOLERS"];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:kunnr];
    [sapHandler addImportWithKey:@"I_MATNR" andValue:[selectedCooler sernr]];
    [sapHandler addImportWithKey:@"I_QUANTITY" andValue:quantity];
    
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
    
}

- (IBAction)selectOtherCooler:(id)sender {
    [pickerView setHidden:YES];
    [pickerViewButton setHidden:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:[NSString stringWithFormat:@"Seçtiğiniz soğutucu %@, eğer sisteme kaydetmek istiyorsanız sayısını belirtiniz.",[selectedCooler description]] delegate:self cancelButtonTitle:@"Geri" otherButtonTitles:@"Tamam", nil];
    alert.tag = 7;
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [efesOtherSegmentControl addTarget:self
                                action:@selector(segmentTapped:)
                      forControlEvents:UIControlEventValueChanged];
    
    table.backgroundColor = [UIColor clearColor];
    table.opaque = YES;
    table.backgroundView = nil;
    
     textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    [textField setHidden:YES];

    self.isEfesActive = YES;
    self.isStockTakingActive = NO;
    self.isStockTakingTime = NO;
    self.isCoolerAddition = NO;
    
    coolers = [[NSMutableArray alloc] init];
    other_coolers = [[NSMutableArray alloc] init];
    otherCoolerList = [[NSMutableArray alloc] init];
    
    [self getCoolersFromSap];
    
}

- (void)barcodeReader {
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsZBarControls = NO;
    reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    [reader setSupportedOrientationsMask:0];
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    /*[self presentModalViewController: reader
                            animated: YES];*/
    
    
    [self.navigationController pushViewController:reader animated:YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{

    reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;

    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText = [NSString stringWithFormat:@"%@",symbol.data];
    
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
        // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [self.navigationController popViewControllerAnimated:YES];
   
    self.barcodeText = resultText;

    [self checkBarcode];
}

- (void)checkBarcode {
    if (!isCoolerAddition) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:[NSString stringWithFormat:@"Seçilen barkod : %@ Okutulan barkod %@",[selectedCooler sernr], self.barcodeText] delegate:self cancelButtonTitle:@"Yeniden Dene" otherButtonTitles:@"Onayla", nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:[NSString stringWithFormat:@"Okutulan barkod %@", self.barcodeText] delegate:self cancelButtonTitle:@"Yeniden Dene" otherButtonTitles:@"Onayla", nil];
        alert.tag = 4;
        [selectedCooler setSernr:barcodeText];
        [alert show];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [[self  navigationItem] setTitle:@"Soğutucular"];
        
    if (!isStockTakingActive) {
        barButton = [[UIBarButtonItem alloc] initWithTitle:@"Ekipman Sayımı" style:UIBarButtonSystemItemAction target:self action:@selector(beginStockTaking)];
        [[self navigationItem] setRightBarButtonItem:barButton];
    }

}

- (IBAction)addCoolerToSystem:(id)sender{
    if ([self isAnimationRunning]) {
        return;
    }
    if (isEfesActive) {
        isCoolerAddition = YES;
        selectedCooler = [[CSCooler alloc] init];
        [selectedCooler setSernr:@" "];
        [self barcodeReader];
    }
    else {
        isCoolerAddition = YES;
        selectedCooler = [[CSCooler alloc] init];
        [selectedCooler setSernr:@""];
        [pickerView reloadAllComponents];
        [self showOtherCoolerList];
    }
}

- (BOOL)isAllCoolerStockConfirm {
    
    for (int i = 0; i < [coolers count]; i++) {
        if (!([[coolers objectAtIndex:i] stockTaking]))
            return NO;
        }
    
    for (int i = 0; i < [other_coolers count]; i++) 
        if (!([[other_coolers objectAtIndex:i] stockTaking]))
            return NO;
        
    
    return YES;
}

- (void)showOtherCoolerList {
    [pickerView setHidden:NO];
    [pickerViewButton setHidden:NO];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self barcodeReader];
                break;
            case 1:
                [self sendUpdatedCoolerInformation:@" "];
                break;
            case 2:
                [selectedCooler setBarcodeFailed:@"X"];
                [self sendUpdatedCoolerInformation:[self.customer kunnr]];
                break;
            case 3:
            
                break;
            default:
                break;
        }
    }
    else if (actionSheet.tag == 2) {
        switch (buttonIndex) {
            case 0:
                [self sendOtherCoolerInformation:[[self customer] kunnr] :[selectedCooler quantity]];
                break;
            case 1:
                [textField setText:@""];
                [self.view addSubview:textField];
                [textField becomeFirstResponder];
                break;
            case 2:
                [self sendOtherCoolerInformation:[[self customer] kunnr] :@"0"];
                break;
            case 3:
                
                break;
            default:
                break;
        }
    }
}

- (void)coolerStockConfirm:(BOOL)vote {
    if (isEfesActive)
        [[coolers objectAtIndex:selectedRow] setStockTaking:vote];
    else
        [[other_coolers objectAtIndex:selectedRow] setStockTaking:vote];
    
    [table reloadData];

}

- (IBAction)getUpdatedCoolerQuantity {
    [textField resignFirstResponder];
    [pickerView setHidden:YES];
    [pickerViewButton setHidden:YES];
    
    if (textField.text != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:[NSString stringWithFormat:@"Seçtiğiniz rakam %@. Göndermek istediğinize emin misiniz ? ", textField.text] delegate:self cancelButtonTitle:@"Geri" otherButtonTitles:@"Tamam", nil];
        alert.tag = 6;
        [alert show];
    }
}

#pragma mark - Core Data methods

- (void)saveCoolerListToCoreData {
    
    NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
    CDOCustomerDetail *cust;
    
    if ([arr count] > 0) {
        cust = [arr objectAtIndex:0];
    }
    
    for (CSCooler *temp in coolers) {
        CDOCooler *cooler = (CDOCooler *)[CoreDataHandler insertEntityData:@"CDOCooler"];
        [cooler setDesc:[temp description]];
        [cooler setType:[temp type]];
        [cooler setSernr:[temp sernr]];
        
        [cust addCoolersObject:cooler];
    }
    
    for (CSCooler *temp in other_coolers)
    {
        CDOCooler *cooler = (CDOCooler *)[CoreDataHandler insertEntityData:@"CDOCooler"];
        [cooler setDesc:[temp description]];
        [cooler setQuantity:[temp quantity]];
        [cooler setSernr:[temp sernr]];
        
        [cust addOtherCoolersObject:cooler];
    }
    
    [CoreDataHandler saveEntityData];
}

- (void)checkExistingCoreDataToDelete {
    
    NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
    CDOCustomerDetail *customerDetail;
    
    if ([arr count] > 0)
        customerDetail = [arr objectAtIndex:0];
    
    
    for (CDOCooler *temp in [customerDetail coolers])
        [[CoreDataHandler getManagedObject] deleteObject:temp];
    
    for (CDOCooler *temp in [customerDetail otherCoolers])
         [[CoreDataHandler getManagedObject] deleteObject:temp];

    [customerDetail setCoolers:nil];
    [customerDetail setOtherCoolers:nil];
    
    [CoreDataHandler saveEntityData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ([alertView tag] == 1) {
        switch (buttonIndex) {
            case 0:
                [self barcodeReader];
                break;
            case 1:
                @try {
                    if ([[selectedCooler sernr] isEqualToString:self.barcodeText]) {
                        [self sendUpdatedCoolerInformation:[self.customer kunnr]];
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ekipman Sayımı" message:@"Seçilen barkod ile okutulan barkod aynı değildir." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                        alert.tag = 2;
                        [alert show];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            break;
        default:
            break;
    }
    }
    else if ([alertView tag] == 3) {
        switch (buttonIndex) {
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 1:
                [[self navigationItem] setHidesBackButton:YES animated:YES];
                break;
            default:
                break;
        }
    }
    else if ([alertView tag] == 4) {
        switch (buttonIndex) {
            case 0:
                [self barcodeReader];
                break;
            case 1:
                [self sendUpdatedCoolerInformation:customer.kunnr];
                break;
            default:
                break;
        }
    }
    else if ([alertView tag] == 5) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [self sendUpdatedCoolerInformation:customer.kunnr];
                break;
            default:
                break;
        }
    }
    else if ([alertView tag] == 6)
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [self sendOtherCoolerInformation:[customer kunnr] : textField.text];
                break;
            default:
                break;
        }
    else if ([alertView tag] == 7)
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [textField setText:@""];
                [self.view addSubview:textField];
                [textField becomeFirstResponder];
                break;
            default:
                break;
        }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isEfesActive == YES) {
        return [coolers count];
    }
    else {
        return [other_coolers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
       
    [[cell textLabel] setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
    NSInteger row = [indexPath row];
    
    cell.imageView.image = nil;
    CSCooler *activeCooler = [[CSCooler alloc] init];
    
    if (self.isEfesActive == YES) {
        activeCooler = [coolers objectAtIndex:row];
        cell.textLabel.text = activeCooler.description;
        cell.detailTextLabel.text = activeCooler.sernr;
    }
    else {
        activeCooler = [other_coolers objectAtIndex:row];
        cell.textLabel.text = activeCooler.description;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Adet", activeCooler.quantity];;
    }
    
    if (self.isStockTakingActive == YES) {
        if (activeCooler.stockTaking == NO)
            cell.imageView.image = [UIImage imageNamed:@"siyahappiconlar-06.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"siyahappiconlar-05.png"];
        }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isEfesActive && !isStockTakingActive) {
        CSFailureDetailViewController *failureDetailViewController = [[CSFailureDetailViewController alloc] initWithCooler:[coolers objectAtIndex:indexPath.row] andCustomer:customer andUser:user];
        [[self navigationController] pushViewController:failureDetailViewController animated:YES];
    }
    else if (isEfesActive && isStockTakingActive) {
        selectedRow = [indexPath row];
        
        if (isEfesActive) 
            selectedCooler = [coolers objectAtIndex:selectedRow];
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Ekipman Sayımı" delegate:self cancelButtonTitle:@"Geri" destructiveButtonTitle:nil otherButtonTitles:@"Barkod Tanıt", @"Soğutucu Yok", @"Barkod Bozuk", nil];
        action.tag = 1;
        
        [action showInView:self.view];
    }
    else if (!isEfesActive && isStockTakingActive) {
        selectedRow = [indexPath row];
        
        selectedCooler = [other_coolers objectAtIndex:selectedRow];
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Ekipman Sayımı" delegate:self cancelButtonTitle:@"Geri" destructiveButtonTitle:nil otherButtonTitles:@"Soğutucu Var", @"Sayısı Farklı", @"Soğutucu Yok", nil];
        action.tag  = 2;
        
        [action showInView:self.view];
    }
}

@end

