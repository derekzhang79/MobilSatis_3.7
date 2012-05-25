//
//  CSTowerAndSpotSelectionViewController.m
//  CrmServis
//
//  Created by ABH on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSTowerAndSpoutSelectionViewController.h"

@implementation CSTowerAndSpoutSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self = [super self];
    towers = [CSTowerAndSpoutList getTowers];
    spouts = [CSTowerAndSpoutList getSpouts];
    
    
    return self;
}
-(id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)myCustomer andSelectedCooler:(CSCooler *)myCooler{
    self = [self init];
    [self setUser:myUser];
    customer = myCustomer;
    selectedCooler = myCooler;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Custom code
-(IBAction)sendInstallationToSap{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kurulum Belgesi" 
                                                    message:[NSString stringWithFormat:@"%@ sogutucusu için kurulum belgesi yaratılıyor.",selectedCooler.description]
                                                   delegate:self 
                          
                                          cancelButtonTitle:@"İptal" 
                                          otherButtonTitles:@"Onayla", nil];
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([super isAnimationRunning]) {
        return;
    }
    
    if (buttonIndex == 1) {
        [super playAnimationOnView:self.view];
        CSTower *selectedTower = [towers objectAtIndex:selectedTowerIndex];
        ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
        [sapHandler setDelegate:self];
        [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CREATE_ACTIVITY_BY_SALES"];
        [sapHandler addImportWithKey:@"IP_TYPE" andValue:@"KURULUM"];
        [sapHandler addImportWithKey:@"IP_CUSTOMER" andValue:customer.kunnr];
        [sapHandler addImportWithKey:@"SOGUTUCU" andValue:selectedCooler.matnr];
        [sapHandler addImportWithKey:@"KULE" andValue:selectedTower.matnr];
        [sapHandler addImportWithKey:@"KULE_MIKTAR" andValue:[NSString stringWithFormat:@"%i",towerAmount ]];
        [sapHandler  addImportWithKey:@"MUSLUK_MIKTAR" andValue:[NSString stringWithFormat:@"%i",spoutAmount ]];
        [sapHandler addImportWithKey:@"KURULUM_TIPI" andValue:selectedCooler.type];
        [sapHandler addImportWithKey:@"USERNAME" andValue:user.username];
        [sapHandler prepCall];


    }
}
-(void)getResponseWithString:(NSString*)myResponse{
    [super stopAnimationOnView];
    NSString *setupNumber =  [[ABHXMLHelper getValuesWithTag:@"OBJECT_ID" fromEnvelope:myResponse] objectAtIndex:0];
    UIAlertView *alert;
    if(![setupNumber isEqualToString:@""]){
        
        
            alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" 
                                               message:[NSString stringWithFormat:@"%@ numaralı kurulum belgesi başarıyla yaratıldı.",setupNumber]
                                              delegate:nil
                     
                                     cancelButtonTitle:@"Tamam" 
                                     otherButtonTitles:nil, nil];
        [alert show];
        [[self navigationController] popViewControllerAnimated:YES];
    }else{
            alert = [[UIAlertView alloc] initWithTitle:@"Hatalı" 
                                               message:[NSString stringWithFormat:@"Kurulum belgesi yaratılamadı. Lütfen tekrar deneyiniz."]
                                              delegate:nil 
                     
                                     cancelButtonTitle:@"Tamam" 
                                     otherButtonTitles:nil, nil];  
        [alert show];
    }
}
#pragma mark - Delegate methods
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 260;
    }else{
        return 50;    
    }
    
}
//PickerViewController.m
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;
}

//PickerViewController.m
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        if (thePickerView == towerPicker) {
            return towers.count;
        }else{
            return spouts.count;
        }
    }
    return 10;
}
//PickerViewController.m
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CSTower *tempTower;
    if (thePickerView == towerPicker) {
        if (component == 0) {
            tempTower = [towers objectAtIndex:row];
            return [NSString stringWithFormat:@"%@",tempTower.desription];
        }
        else{
            return [NSString stringWithFormat:@"%i",row+1];
        }
    }
    if (thePickerView == spoutPicker) {
        CSSpout *tempSpout;
        if (component == 0) {
            tempSpout = [spouts objectAtIndex:row];
            return [NSString stringWithFormat:@"%@",tempSpout.desription];
        }
        else{
          //  return [NSString stringWithFormat:@"%@",row];
            return [NSString stringWithFormat:@"%i",row+1];
        }
    }
    return  @"alp";
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
 //   NSLog(@"Selected Color: %@. Index of selected color: %i", thePickerView, row);
    if (thePickerView == towerPicker) {
        if (component == 0) {
            selectedTowerIndex = row;
        }
        if (component == 1) {
            towerAmount = row + 1;
        }
    }
    
    if (thePickerView == spoutPicker) {
        if (component == 0) {
            selectedSpoutIndex = row;
        }
        if (component == 1) {
            spoutAmount = row + 1;
        }
    }
    
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //pickerView.showsSelectionIndicator = NO;
    // Do any additional setup after loading the view from its nib.
    towerPicker = [[UIPickerView alloc] init];
    towerPicker.frame = 	CGRectMake(0, 0, 320, 180);
    [towerPicker setDelegate:self];
    [towerPicker setDataSource:self];
    [towerPicker setShowsSelectionIndicator:YES];
//    [towerPicker setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
    [[self view] addSubview:towerPicker];
    
    spoutPicker = [[UIPickerView alloc] init];
    spoutPicker.frame = 	CGRectMake(0, 200, 320, 180);
    [spoutPicker setDelegate:self];
    [spoutPicker setDataSource:self];
    [spoutPicker setShowsSelectionIndicator:YES];
    [[self view] addSubview:spoutPicker];
    towerAmount = 1;
    spoutAmount = 1;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yarat" style:UIBarButtonItemStyleBordered target:self action:@selector(sendInstallationToSap)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
    [[self navigationItem] setTitle:@"Musluk-Kule"];
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
