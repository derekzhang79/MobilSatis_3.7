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
- (id)init{
    self = [super init];
    [[self navigationController] setDelegate:self];
    [[self navigationController] setNavigationBarHidden:NO];
    [[self navigationItem] setTitle:@"Oturum Açma"];
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Giriş" style:UIBarButtonSystemItemAction target:self action:@selector(login)];
    [[self navigationItem] setRightBarButtonItem:loginButton];
    user =[NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(@"User.data")];
    if (user == nil) {
        user = [[CSUser alloc] init];
    }
     
    
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




-(BOOL)loginToSAPWithUserName:(NSString*)myUserName andPassword:(NSString*)myPassword{
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_LOGIN"];
    [sapHandler addImportWithKey:@"USERNAME" andValue:[self.username text]];
        [sapHandler addImportWithKey:@"PASSWORD" andValue:[self.password text]];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
    

    return YES;
    
    
}

-(IBAction)showInfo{
    if ([super isAnimationRunning]) {
        return;
    }
    //make some cool stuf too put logo vice versa
    CSInfoViewController *infoViewController = [[CSInfoViewController alloc] init];
    [[self navigationController] pushViewController:infoViewController animated:YES];
}

-(void)getResponseWithString:(NSString *)myResponse{

    [super stopAnimationOnView];
//    NSLog(@"Envelope that recieved: %@",myResponse);
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"LOGGEDIN" fromEnvelope:myResponse];
    if ([[responses objectAtIndex:0 ] isEqualToString: @"T"]) {    
    //first of all set init user object
        [user setUsername:username.text];
        [NSKeyedArchiver archiveRootObject:user toFile:pathInDocumentDirectory(@"User.data")];
        [user setName:[[ABHXMLHelper getValuesWithTag:@"NAME" fromEnvelope:myResponse] objectAtIndex:0]];
        [user setSurname:[[ABHXMLHelper getValuesWithTag:@"SURNAME" fromEnvelope:myResponse] objectAtIndex:0]];
        [user setUsername:[[self username] text]];
        //register check
        if([self checkUserRegisterationWithResponse:myResponse]){
        //the flow
    UITabBarController *tabBarController =[[UITabBarController alloc] init];
    
    
    //prepare tabbarViewConroller
    //first tab
        CSDealerListViewController *dealerListViewController = [[CSDealerListViewController alloc] initWithUser:user];
        [[dealerListViewController tabBarItem] setTitle:@"İş Emirleri"];
            [[dealerListViewController tabBarItem] setImage:[UIImage imageNamed:@"isemiricon.png"]];
            CSProfileViewController *profileViewController = [[CSProfileViewController alloc] initWithUser:[self user]];
//        CSConfirmationListViewController *confirmationListViewController = [[CSConfirmationListViewController alloc] initWithUser:[self user]];  
           // [[confirmationListViewController tabBarItem] setImage:[UIImage imageNamed:@"teyit_ikon.png"]];
   // [[confirmationListViewController tabBarItem] setTitle:@"Teyit Onaylama"];
            [[profileViewController tabBarItem] setTitle:@"Ben"];
            CSLoctionHandlerViewController *locationHandlerViewController = [[CSLoctionHandlerViewController alloc] initWithUser:[self user]];
            [[locationHandlerViewController tabBarItem] setTitle:@"Nerdeyim"];
            [[locationHandlerViewController tabBarItem] setImage:[UIImage imageNamed:@"world.png"]];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:dealerListViewController,profileViewController, locationHandlerViewController , nil]];
    ///go!
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


-(BOOL)checkUserRegisterationWithResponse:(NSString*)myResponse{
    
    NSMutableArray *registerStatusResponse = [ABHXMLHelper getValuesWithTag:@"DURUM" fromEnvelope:myResponse];
    if ([[registerStatusResponse objectAtIndex:0]isEqualToString:@"X"]) {
        return true;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yeni Kullanici!" 
                                                    message:@"Sisteme ilk girişiniz. Lütfen Efes Pilsen mail adresinizi giriniz."
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

-(IBAction)changeUserPassword:(id)sender{
    if ([super isAnimationRunning]) {
        return; 
    }
    [user setUsername:username.text];
    CSPasswordChangeViewController  *passwordChangeViewController = [[CSPasswordChangeViewController alloc] initWithUser:user] ;
    [[self navigationController] pushViewController:passwordChangeViewController animated:YES];
    
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
    scrollView.contentSize = CGSizeMake(320, 370);
//    [activityIndicator setHidesWhenStopped:YES];
    //only for demo purposes
   
    if (user != nil) {
        [username setText:user.username];
    }else{
 //   [username setText:@"31305001"];
    }
    
    [usernameLabel setTextColor:[CSApplicationProperties getUsualTextColor]];
    [passwordLabel setTextColor:[CSApplicationProperties getUsualTextColor]];
    // [password setText:@"123456"];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [username resignFirstResponder];
    [username setText:@"313010"];
    [password setText:@"123456"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
