//
//  CSLoginViewController.m
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSLoginViewController.h"

#import "CSConfirmationListViewController.h"
#import "CSInfoViewController.h"
#import "CSConfirmationSelectionViewController.h"
#import "CSDealerListViewController.h"
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
#import "ABHConnectionInfo.h"
#import "CSRegisterUserViewController.h"
#import "FileHelpers.h"
#import "CSApplicationProperties.h"
#import "CSProfileViewController.h"

@implementation CSLoginViewController
@synthesize username,password;
@synthesize activeField;
@synthesize crmServerIpList, crmSystemNumberList;
@synthesize crmServerIpCount, crmSystemNumberCount;
@synthesize loginEntity;
@synthesize isAdmin;

- (id)init {
    self = [super init];
    [[self navigationController] setDelegate:self];
    [[self navigationController] setNavigationBarHidden:NO];
    [[self navigationItem] setTitle:@"Oturum Açma"];
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Giriş" style:UIBarButtonSystemItemAction target:self action:@selector(login)];
    [[self navigationItem] setRightBarButtonItem:loginButton];
    
    crmSystemNumberList = [[NSMutableArray alloc] initWithObjects:@"00", @"01", @"02", nil];
    crmServerIpList = [[NSMutableArray alloc] initWithObjects:@"10.12.1.179", @"10.12.1.184", @"10.12.1.185", nil];
    crmSystemNumberCount = 0;
    crmServerIpCount = 0;
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


# pragma mark - Core Data Methods

- (void)addEvent:(NSString *)aUsername andPassword:(NSString *)aPassword andName:(NSString *)aName andSurname:(NSString *)aSurname andEmail:(NSString *)aEmail {
    
    CDOUser *login = (CDOUser *)[CoreDataHandler insertEntityData:@"CDOUser"];
    
    [login setUserMyk:aUsername];
    [login setPassword:aPassword];
    [login setName:[aName lowercaseString]];
    [login setSurname:aSurname];
    [login setEmail:aEmail];
    
    [CoreDataHandler saveEntityData];
}


//custom code
-(IBAction)login{
    [username resignFirstResponder];
    [password resignFirstResponder];
    //    if ([activityIndicator isAnimating]) {
    if([super isAnimationRunning]){
        return;
    }
    if ( [self isFieldEmpty:username] || [self isFieldEmpty:password]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Giriş Başarısız!"
                                                        message:@"Kullanıcı Adı ve Şifrenizi kontrol ediniz."
                                                       delegate:nil
                                              cancelButtonTitle:@"Tamam"
                                              otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    if( [self loginToSAPWithUserName:username.text andPassword:password.text]){
        [CSNewCoolerList    initNewCoolers];
        [CSTowerAndSpoutList initEquipments];
        return;
    }
    
    
}

-(BOOL)loginToSAPWithUserName:(NSString*)myUserName andPassword:(NSString*)myPassword {
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[crmServerIpList objectAtIndex:crmServerIpCount] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[crmSystemNumberList objectAtIndex:crmSystemNumberCount] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_LOGIN"];
    [sapHandler addImportWithKey:@"USERNAME" andValue:[self.username text]];
    [sapHandler addImportWithKey:@"PASSWORD" andValue:[self.password text]];
    [sapHandler addImportWithKey:@"VERSIYON" andValue:[CSApplicationProperties getVersionOfApplication]];
    [sapHandler addImportWithKey:@"SAPUSER" andValue:[[[self user] sapUser] uppercaseString]];
    
    [sapHandler addImportWithKey:@"I_ADMIN" andValue:isAdmin];
    [super playAnimationOnView:self.view];
    
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    
    return YES;
    
}

-(void)updateConnectionInfoWithCurrent{
    [ABHConnectionInfo setHostName:[crmServerIpList objectAtIndex:crmServerIpCount]];
    [ABHConnectionInfo setSystemNumeber:[crmSystemNumberList objectAtIndex:crmSystemNumberCount]];
}

-(IBAction) showInfo {
    if ([super isAnimationRunning]) {
        return;
    }
    //make some cool stuf too put logo vice versa
    CSInfoViewController *infoViewController = [[CSInfoViewController alloc] initWithUser:user];
    [[self navigationController] pushViewController:infoViewController animated:YES];
}

-(void) downloadUpdatedApp {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Efes Mobil uygulamasının yeni versiyonu mevcuttur. İndirmek ister misiniz?" delegate:self cancelButtonTitle:@"Daha sonra" otherButtonTitles:@"İndir", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.efespilsen.com.tr/crmmobile/"]];
        }
    }
    
    //    if (alertView.tag == 6) {
    //        if (buttonIndex == 0) {
    //            ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    //            [sapHandler setDelegate:self];
    //            [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_SIFREMI_UNUTTUM"];
    //            [sapHandler addImportWithKey:@"UNAME" andValue:[NSString stringWithFormat:@"%@",[self.username text]]];
    //            [super playAnimationOnView:self.view];
    //            [sapHandler prepCall];
    //        }
    //    }
}

- (IBAction)forgotMyPassword{
    CSRegisterUserViewController *registerUserViewController = [[CSRegisterUserViewController alloc] initWithUser:user];
    [[self navigationController]pushViewController:registerUserViewController animated:YES];
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [self stopAnimationOnView];
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        if ([[loginEntity userMyk] isEqualToString:username.text] && [[loginEntity password] isEqualToString:password.text]) {
            [user setUsername:[loginEntity userMyk]];
            [user setName:[loginEntity name]];
            [user setSurname:[loginEntity surname]];
            [user setMail:[loginEntity email]];
            
            UITabBarController *tabBarController = [[UITabBarController alloc] init];
            //prepare tabbarViewConroller
            //first tab
            CSDealerListViewController *dealerListViewController = [[CSDealerListViewController alloc] initWithUser:user];
            [[dealerListViewController tabBarItem] setTitle:@"Müşterilerim"];
            [[dealerListViewController tabBarItem] setImage:[UIImage imageNamed:@"isemir.png"]];
            CSProfileViewController *profileViewController = [[CSProfileViewController alloc] initWithUser:[self user]];
            //        CSConfirmationListViewController *confirmationListViewController = [[CSConfirmationListViewController alloc] initWithUser:[self user]];
            // [[confirmationListViewController tabBarItem] setImage:[UIImage imageNamed:@"teyit_ikon.png"]];
            // [[confirmationListViewController tabBarItem] setTitle:@"Teyit Onaylama"q];
            [[profileViewController tabBarItem] setTitle:@"Profilim"];
            [[profileViewController tabBarItem] setImage:[UIImage imageNamed:@"profilim.png"]];
            CSLoctionHandlerViewController *locationHandlerViewController = [[CSLoctionHandlerViewController alloc] initWithUser:[self user]];
            [[locationHandlerViewController tabBarItem] setTitle:@"Neredeyim"];
            [[locationHandlerViewController tabBarItem] setImage:[UIImage imageNamed:@"neredeyim.png"]];
            [tabBarController setViewControllers:[NSArray arrayWithObjects:dealerListViewController,profileViewController, locationHandlerViewController , nil]];
            ///go!
            [tabBarController setSelectedIndex:1];
            
            [[self navigationController] pushViewController:tabBarController animated:YES];
            
            return;
        }
        else
        {
            [super stopAnimationOnView];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Giriş Başarısız!"
                                                            message:@"Kullanıcı Adı ve Şifrenizi kontrol ediniz."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Tamam"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    if ([[me RFCNameLine] rangeOfString:@"ZMOB_LOGIN" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"LOGGEDIN" fromEnvelope:myResponse];
        
        if (!([responses count] > 0)) {
            if (crmSystemNumberCount == 2)
            {
                crmSystemNumberCount = 0;
                crmServerIpCount++;
            }
            else if (crmServerIpCount == 2)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bağlantı Hatası"
                                                                message:@"Efes Mobil bakımdadır. Lütfen satış sistemleri ile irtibata geçiniz."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Tamam"
                                                      otherButtonTitles: nil];
                alert.tag = 2;
                [alert show];
                return;
            }
            else
                crmSystemNumberCount++;
            
            
            [self loginToSAPWithUserName:username.text andPassword:password.text];
            return;
        }
        
        if ([[responses objectAtIndex:0 ] isEqualToString: @"T"]) {
            //first of all set init user object
            [self updateConnectionInfoWithCurrent];
            [user setUsername:username.text];
            [user setSapUser:[[ABHXMLHelper getValuesWithTag:@"E_SAPUSER" fromEnvelope:myResponse] objectAtIndex:0]];
            [user setName:[[ABHXMLHelper getValuesWithTag:@"NAME" fromEnvelope:myResponse] objectAtIndex:0]];
            [user setSurname:[[ABHXMLHelper getValuesWithTag:@"SURNAME" fromEnvelope:myResponse] objectAtIndex:0]];
            [user setUsername:[[self username] text]];
            [user setMail:[[ABHXMLHelper getValuesWithTag:@"MAIL" fromEnvelope:myResponse] objectAtIndex:0]];
            [user setJavaPassword:[[ABHXMLHelper getValuesWithTag:@"E_PASSKEY" fromEnvelope:myResponse] objectAtIndex:0]];
            
            NSString *str = [[ABHXMLHelper getValuesWithTag:@"UPDATE" fromEnvelope:myResponse] objectAtIndex:0];
            
            if (loginEntity == nil) {
                [self addEvent:[user username] andPassword:password.text andName:[user name] andSurname:[user surname] andEmail:[user mail]];
            }
            else if (![[loginEntity userMyk] isEqualToString:[username text]]) {
                [CoreDataHandler dropAllTables];
                [self addEvent:[user username] andPassword:password.text andName:[user name] andSurname:[user surname] andEmail:[user mail]];
            }
            
            if ([str isEqual:@"X"]) {
                [self downloadUpdatedApp];
            }
            
            //register check
            if([self checkUserRegisterationWithResponse:myResponse]){
                //the flow
                UITabBarController *tabBarController =[[UITabBarController alloc] init];
                
                
                //prepare tabbarViewConroller
                //first tab
                CSDealerListViewController *dealerListViewController = [[CSDealerListViewController alloc] initWithUser:user];
                [[dealerListViewController tabBarItem] setTitle:@"Müşterilerim"];
                [[dealerListViewController tabBarItem] setImage:[UIImage imageNamed:@"isemir.png"]];
                CSProfileViewController *profileViewController = [[CSProfileViewController alloc] initWithUser:[self user]];
                //        CSConfirmationListViewController *confirmationListViewController = [[CSConfirmationListViewController alloc] initWithUser:[self user]];
                // [[confirmationListViewController tabBarItem] setImage:[UIImage imageNamed:@"teyit_ikon.png"]];
                // [[confirmationListViewController tabBarItem] setTitle:@"Teyit Onaylama"q];
                [[profileViewController tabBarItem] setTitle:@"Profilim"];
                [[profileViewController tabBarItem] setImage:[UIImage imageNamed:@"profilim.png"]];
                CSLoctionHandlerViewController *locationHandlerViewController = [[CSLoctionHandlerViewController alloc] initWithUser:[self user]];
                [[locationHandlerViewController tabBarItem] setTitle:@"Neredeyim"];
                [[locationHandlerViewController tabBarItem] setImage:[UIImage imageNamed:@"neredeyim.png"]];
                [tabBarController setViewControllers:[NSArray arrayWithObjects:dealerListViewController,profileViewController, locationHandlerViewController , nil]];
                ///go!
                [tabBarController setSelectedIndex:1];
                
                [[self navigationController] pushViewController:tabBarController animated:YES];
            }else{
                
                CSRegisterUserViewController *registerUserViewController = [[CSRegisterUserViewController alloc] initWithUser:user];
                [[self navigationController]pushViewController:registerUserViewController animated:YES];
            }
        }else{
            //error messages vice versa
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Giriş Başarısız!"
                                                            message:@"Kullanıcı Adı ve Şifrenizi kontrol ediniz."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Tamam"
                                                  otherButtonTitles: nil];
            [alert show];
            
        }
    }
}



-(BOOL)checkUserRegisterationWithResponse:(NSString*)myResponse{
    
    NSMutableArray *registerStatusResponse = [ABHXMLHelper getValuesWithTag:@"DURUM" fromEnvelope:myResponse];
    if ([[registerStatusResponse objectAtIndex:0]isEqualToString:@"X"]) {
        return true;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yeni Kullanici!"
                                                    message:@"Sisteme ilk girişiniz. Lütfen gerekli bilgileri giriniz."
                                                   delegate:nil
                                          cancelButtonTitle:@"Tamam"
                                          otherButtonTitles: nil];
    [alert show];
    return false;
}

- (IBAction)makeKeyboardGoAway{
    [username resignFirstResponder];
    [password resignFirstResponder];
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
    password.delegate = self;
    username.delegate = self;
    [[[self navigationController] navigationBar] setTintColor:[CSApplicationProperties getEfesBlueColor]];
    scrollView.contentSize = CGSizeMake(320, 370);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    if (user != nil) {
        [username setText:user.username];
    }
    else{
        //   [username setText:@"31305001"];
    }

    // AATAC BURAYI DEĞİŞTİRMEYI UNUTMA
//    isAdmin = @"X";
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
    
    CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y);
    [scrollView setContentOffset:scrollPoint animated:YES];
    [scrollView setScrollEnabled:NO];
    //   }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [username resignFirstResponder];
    
    NSArray *eventsArray = [CoreDataHandler fetchExistingEntityData:@"CDOUser" sortingParameter:@"userMyk" objectContext:[CoreDataHandler getManagedObject]];
    
    if ([eventsArray count] > 0)
    {
        self.loginEntity = (CDOUser *)[eventsArray objectAtIndex:0];
    }
    
    user = [[CSUser alloc] init];
    user.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    user.sapUser  = [[NSUserDefaults standardUserDefaults] stringForKey:@"sapUser"];
    
    [username setText:[user username]];
    [password setText:@""];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
