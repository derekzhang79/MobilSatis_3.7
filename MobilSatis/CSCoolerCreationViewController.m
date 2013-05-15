//
//  CSCoolerCreationViewController.m
//  MobilSatis
//
//  Created by Ata Cengiz on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSCoolerCreationViewController.h"

@interface CSCoolerCreationViewController ()

@end

@implementation CSCoolerCreationViewController
@synthesize textView;
@synthesize createButton;
@synthesize towerViewController;
@synthesize isStandartText;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isStandartText = YES;
    [[self  navigationItem] setTitle:@"Kurulum Notu"];

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

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (isStandartText) {
        isStandartText = NO;
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
}

- (IBAction)makeKeyboardGoAway{
    [self.textView resignFirstResponder];
}

-(BOOL)checkFailureDescription{
    if ([textView.text isEqualToString:@""] || isStandartText) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata"
                                                        message:[NSString stringWithFormat:@"Kurulum notu girilmesi zorunludur!"]
                                                       delegate:nil
                                              cancelButtonTitle:@"Tamam"
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
        
    }
    return YES;
}

- (IBAction)sendToSAP {
    BOOL checker = [self checkFailureDescription];
    
    if (!checker) {
        return;
    }
    
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kurulum Belgesi" 
     message:[NSString stringWithFormat:@"%@ sogutucusu için kurulum belgesi yaratılıyor.",towerViewController.selectedCooler.description]
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
        CSTower *selectedTower = [self.towerViewController.towers objectAtIndex:self.towerViewController.selectedTowerIndex];
        ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
        [sapHandler setDelegate:self];
        [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CREATE_ACTIVITY_BY_SALES"];
        [sapHandler addImportWithKey:@"IP_TYPE" andValue:@"KURULUM"];
        [sapHandler addImportWithKey:@"IP_CUSTOMER" andValue:self.towerViewController.customer.kunnr];
        [sapHandler addImportWithKey:@"SOGUTUCU" andValue:self.towerViewController.selectedCooler.matnr];
        [sapHandler addImportWithKey:@"KULE" andValue:selectedTower.matnr];
        [sapHandler addImportWithKey:@"KULE_MIKTAR" andValue:[NSString stringWithFormat:@"%i",self.towerViewController.towerAmount ]];
        [sapHandler  addImportWithKey:@"MUSLUK_MIKTAR" andValue:[NSString stringWithFormat:@"%i",self.towerViewController.spoutAmount ]];
        [sapHandler addImportWithKey:@"KURULUM_TIPI" andValue:self.towerViewController.selectedCooler.type];
        [sapHandler addImportWithKey:@"USERNAME" andValue:user.username];
        [sapHandler addImportWithKey:@"ARIZA_NEDENI" andValue:textView.text];
        [sapHandler prepCall];
        
    }
}

-(void)getResponseWithString:(NSString*)myResponse andSender:(ABHSAPHandler *)me{
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
        //[[self navigationController] popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        alert = [[UIAlertView alloc] initWithTitle:@"Hatalı" 
                                           message:[NSString stringWithFormat:@"Kurulum belgesi yaratılamadı. Lütfen tekrar deneyiniz."]
                                          delegate:nil 
                 
                                 cancelButtonTitle:@"Tamam" 
                                 otherButtonTitles:nil, nil];  
        [alert show];
    }
}


@end
