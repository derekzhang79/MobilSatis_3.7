//
//  CSRegisterUserViewController.m
//  CrmServis
//
//  Created by ABH on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSRegisterUserViewController.h"
#import "FileHelpers.h"

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

- (IBAction)makeKeyboardGoAway {
    [mykUserField resignFirstResponder];
    [mykPasswordField resignFirstResponder];
    [sapUserField resignFirstResponder];
    [sapPasswordField resignFirstResponder];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [scrollView setScrollEnabled:YES];
    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - 35);
    [scrollView setContentOffset:scrollPoint animated:YES];
    [scrollView setScrollEnabled:NO];
    //   }
}


-(IBAction)saveMail:(id)sender {
    
    if ([super isAnimationRunning]) {
        return;
    }
    
    if ([[mykUserField text] isEqualToString:@""] || [[mykPasswordField text] isEqualToString:@""] || [[sapUserField text] isEqualToString:@""] || [[sapPasswordField text] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Lütfen bütün bilgileri doldurun" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self sendUserDataToSAP:sender];
    }
}

-(void)sendUserDataToSAP:(id)sender {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_SAT_TEM_UPDATE"];
    
    [sapHandler addImportWithKey:@"MYK" andValue:[mykUserField text]];
    [sapHandler addImportWithKey:@"PASSWORD" andValue:[mykPasswordField text]];
    [sapHandler addImportWithKey:@"SAPUSER" andValue:[[sapUserField text] uppercaseString]];
    [sapHandler addImportWithKey:@"SAPPASSWORD" andValue:[sapPasswordField text]];
    [sapHandler addImportWithKey:@"DEVICE" andValue:@"IOS"];
    
    [sapHandler prepCall];
    [super playAnimationOnView:self.view];
}


-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"STATUS" fromEnvelope:myResponse];
    if ([[responses objectAtIndex:0 ] isEqualToString: @"T"]) {
        
        [[self user] setSapUser:[sapUserField text]];
        [[NSUserDefaults standardUserDefaults] setObject:[mykUserField text] forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:[sapUserField text] forKey:@"sapUser"];

        
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kayıt Tamamlandı"
                                           message:[NSString stringWithFormat:@"Kayıt işlemi başarılı.Tekrar giriş yapınız."]
                                          delegate:nil 
                 
                                 cancelButtonTitle:@"Tamam" 
                                 otherButtonTitles:nil,
                 nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata"
                                                        message:@"Kayıt sırasında hata alındı."
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
    [welcomeLabel setText:@"Hoşgeldiniz, "];
    [activeField setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[self navigationItem] setTitle:@"Oturum Açma"];
    
    [mykPasswordField setSecureTextEntry:YES];
    [sapPasswordField setSecureTextEntry:YES];
    [mykUserField setText:[user username]];
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
