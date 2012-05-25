//
//  CSRegisterUserViewController.m
//  CrmServis
//
//  Created by ABH on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSRegisterUserViewController.h"

@implementation CSRegisterUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)makeKeyboardGoAway{
    [mailField resignFirstResponder];
}

-(IBAction)saveMail:(id)sender{
    if ([super isAnimationRunning]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kayit İşlemi" 
                                                    message:[NSString stringWithFormat:@"%@ %@ mail adresinizi %@ olarak girdiniz. Onaylıyor musunuz?",user.name, user.surname,mailField.text]
                                                   delegate:self 
                            
                                          cancelButtonTitle:@"İptal" 
                                          otherButtonTitles:@"Onayla", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [user setMail:[NSString stringWithFormat:mailField.text]];
        [self updateUserInSap];
    }
}

-(void)updateUserInSap{
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_SAT_TEM_UPDATE"];
    [sapHandler addImportWithKey:@"UNAME" andValue:user.username];
    [sapHandler addImportWithKey:@"MAIL" andValue:user.mail];
    [sapHandler addImportWithKey:@"DEVICE" andValue:@"IOS"];
    [sapHandler prepCall];
    [super playAnimationOnView:self.view];
}
-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"STATUS" fromEnvelope:myResponse];
    if ([[responses objectAtIndex:0 ] isEqualToString: @"T"]) {    
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kayıt Tamamlandı" 
                                           message:[NSString stringWithFormat:@"Kayıt işlemi başarılı.Tekrar giriş yapınız."]
                                          delegate:nil 
                 
                                 cancelButtonTitle:@"Tamam" 
                                 otherButtonTitles:nil,
                 nil];
            [alert show];
    }

    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [welcomeLabel setText:[NSString stringWithFormat:@"Hosgeldiniz, %@ %@",[user name], [user surname]]];
//        [activityIndicator setHidesWhenStopped:YES];
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
