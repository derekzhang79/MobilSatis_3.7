//
//  CSTakeAwayDetailViewController.m
//  CrmServis
//
//  Created by ABH on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSTakeAwayDetailViewController.h"

@implementation CSTakeAwayDetailViewController
@synthesize textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCustomer:(CSCustomer *)aCustomer andUser:(CSUser *)myUser{
    self = [super init];
    customer = aCustomer;
    user = myUser;
    return self;
}

-(IBAction)sendTakeAwayToSap:(id)sender{
    if (![self checkFailureDescription] || [super isAnimationRunning]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Arıza Belgesi" 
                                                    message:[NSString stringWithFormat:@"%@ müşterisi için sökme belgesi yaratılıyor. Emin misiniz?",customer.name1]
                                                   delegate:self 
                          
                                          cancelButtonTitle:@"İptal" 
                                          otherButtonTitles:@"Onayla", nil];
    [alert show];
}


-(BOOL)checkFailureDescription{
    if ([textView.text isEqualToString:@""] || isStandartText) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" 
                                                        message:[NSString stringWithFormat:@"Sökme nedeni girilmesi zorunludur!"]
                                                       delegate:nil
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
        
    }
    return YES;
}


- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (isStandartText) {
        isStandartText = NO;
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
}

-(IBAction)ignoreKeyboard{
    
    [self.textView resignFirstResponder];
    //   [self resignFirstResponder   ];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [super playAnimationOnView:self.view];
        ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
        [sapHandler setDelegate:self];
        [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CREATE_ACTIVITY_BY_SALES"];//sogutucu alcak
        [sapHandler addImportWithKey:@"IP_TYPE" andValue:@"SOKME"];
        [sapHandler addImportWithKey:@"IP_CUSTOMER" andValue:customer.kunnr];
        [sapHandler addImportWithKey:@"ARIZA_NEDENI" andValue:textView.text];
        [sapHandler addImportWithKey:@"USERNAME" andValue:user.username];
        [sapHandler prepCall];
    }
}
-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
    NSString *takeAwayOrderNumber = [[NSString alloc] init];
    
    takeAwayOrderNumber = [[ABHXMLHelper getValuesWithTag:@"OBJECT_ID" fromEnvelope:myResponse] objectAtIndex:0];
    if([takeAwayOrderNumber isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" 
                                                        message:[NSString stringWithFormat:@"Sökme belgesi yaratılamadı. Lütfen tekrar deneyiniz."]
                                                       delegate:nil
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" 
                                                        message:[NSString stringWithFormat:@"%@  numarali belge yaratildi.", takeAwayOrderNumber]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [[self navigationController] popViewControllerAnimated:YES];
        [alert show];
    }

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
    isStandartText = YES;
    // Do any additional setup after loading the view from its nib.
    [textView clearsContextBeforeDrawing];
    [textView setText:[NSString stringWithFormat:@"%@müşterisindeki soğutucu barkodu ve açıklaması giriniz.",customer.name1]];
    [textView setTextColor:[UIColor blueColor]];
    // [textView setText:[NSString stringWithFormat:@"%@ barkodlu %@ soğutucusu için arıza nedeni giriniz.",cooler.sernr,cooler.description]];
    [[self navigationItem] setTitle:@"Sökme Nedeni"];
    // Do any additional setup after loading the view from its nib.
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
