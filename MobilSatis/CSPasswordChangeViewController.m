//
//  CSPasswordChangeViewController.m
//  CrmServis
//
//  Created by ABH on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSPasswordChangeViewController.h"

@implementation CSPasswordChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)checkDataOnScreen{
    if([usernameTextField.text length] == 0 || [oldPasswordTextField.text length] == 0 || [newPasswordTextField.text length] == 0 || [newPasswordTextField2.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata!" 
                                                        message:@"Bütün alanları doldurunuz."
                                                       delegate:nil 
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
        
    }
    if (![newPasswordTextField.text isEqualToString:newPasswordTextField2.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata!" 
                                                        message:@"Yeni şifreleriniz aynı olmalı."
                                                       delegate:nil 
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if(newPasswordTextField.text.length < 5 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata!" 
                                                        message:@"Yeni şifreleriniz en az 5 karakter olmalı."
                                                       delegate:nil 
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(void)changePasswordFromSap{
    if ([super isAnimationRunning]) {
        return;
    }else{
        if([self checkDataOnScreen]){
            ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
            [sapHandler setDelegate:self];
            [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_SATIS_TEM_SIFRE_DEGISTIR"];
            [sapHandler addImportWithKey:@"USERNAME" andValue:[usernameTextField text]];
            [sapHandler addImportWithKey:@"ESKI_SIFRE" andValue:[oldPasswordTextField text]];
            [sapHandler addImportWithKey:@"YENI_SIFRE" andValue:[newPasswordTextField text]];
            [sapHandler addImportWithKey:@"YENI_SIFRE2" andValue:[newPasswordTextField2 text]];
            [sapHandler prepCall];
            //[activityIndicator startAnimating];
            [super playAnimationOnView:self.view];
        }
    }
}


-(void)getResponseWithString:(NSString *)myResponse{
    
    [super stopAnimationOnView];
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"STATUS" fromEnvelope:myResponse];
      NSString *message = [NSString stringWithFormat:@"%@", [[ABHXMLHelper getValuesWithTag:@"MSG" fromEnvelope:myResponse] objectAtIndex:0]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata!" 
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"Tamam" 
                                          otherButtonTitles: nil];
    if ([[responses objectAtIndex:0 ] isEqualToString: @"T"]) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    [alert show];
    
      
    
}
- (IBAction)makeKeyboardGoAway{
    [usernameTextField resignFirstResponder];
    [oldPasswordTextField resignFirstResponder];
    [newPasswordTextField resignFirstResponder];
    [newPasswordTextField2 resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    usernameTextField.text = user.username;
    [usernameLabelField setTextColor:[CSApplicationProperties getUsualTextColor]];
    [oldPasswordLabelField setTextColor:[CSApplicationProperties getUsualTextColor]];
    [newPasswordLabelField setTextColor:[CSApplicationProperties getUsualTextColor]];
    [newPasswordLabelField2 setTextColor:[CSApplicationProperties getUsualTextColor]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Değiştir" style:UIBarButtonSystemItemAction target:self action:@selector(changePasswordFromSap)]];
    [[self navigationItem] setTitle:@"Şifre Değiştir"];
    // Do any additional setup asfter loading the view from its nib.
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
