//
//  CSFailureDetailViewController.m
//  CrmServis
//
//  Created by ABH on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSFailureDetailViewController.h"

@implementation CSFailureDetailViewController
@synthesize textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
} 
-(id)initWithCooler:(CSCooler*)aCooler andCustomer:(CSCustomer *)aCustomer andUser:(CSUser *)myUser{
    self = [super init];
    cooler  = aCooler;
    customer = aCustomer;
    user = myUser;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(BOOL)checkFailureDescription{
    if ([textView.text isEqualToString:@""] || isStandartText) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" 
                                                        message:[NSString stringWithFormat:@"Arıza nedeni girilmesi zorunludur!"]
                                                       delegate:nil
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
        
    }
    return YES;
}
-(IBAction)sendFailureToSap:(id)sender{
    if ([super isAnimationRunning] || ![self checkFailureDescription] ) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Arıza Belgesi" 
                                                    message:[NSString stringWithFormat:@"%@ barkodlu soğutucu için ariza belgesi yaratılıyor. Emin misiniz?",cooler.sernr]
                                                   delegate:self 
                          
                                          cancelButtonTitle:@"İptal" 
                                          otherButtonTitles:@"Onayla", nil];
    [alert show];

    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CREATE_ACTIVITY_BY_SALES"];//sogutucu alcak
    [sapHandler addImportWithKey:@"IP_TYPE" andValue:@"ARIZA"];
    [sapHandler addImportWithKey:@"IP_CUSTOMER" andValue:customer.kunnr];//customer.kunnr"1001225"]
    [sapHandler addImportWithKey:@"ARIZA_NEDENI" andValue:textView.text];
    [sapHandler addImportWithKey:@"SERNR" andValue:cooler.sernr];
        [sapHandler addImportWithKey:@"USERNAME" andValue:user.username];
//NSLog(@"%@",user.username);
        [sapHandler prepCall];
    [super playAnimationOnView:self.view];
        
    }
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    [super stopAnimationOnView];
    NSString *takeAwayOrderNumber = [[NSString alloc] init];
    
    takeAwayOrderNumber = [[ABHXMLHelper getValuesWithTag:@"OBJECT_ID" fromEnvelope:myResponse] objectAtIndex:0];
    if([takeAwayOrderNumber isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" 
                                                        message:[NSString stringWithFormat:@"Arıza belgesi yaratılamadı. Lütfen tekrar deneyiniz."]
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
        [alert show];
    }

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

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[[self tabBarController ]navigationItem] setTitle:@"Arıza Açıklama"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isStandartText = YES;
    // Do any additional setup after loading the view from its nib.
    [textView clearsContextBeforeDrawing];
    [textView setText:[NSString stringWithFormat:@"%@ barkodlu %@ soğutucusu için arıza nedeni giriniz.",cooler.sernr,cooler.description]];
    [textView setTextColor:[UIColor blueColor]];
    [[self navigationItem] setTitle:@"Arıza Nedeni"];
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
