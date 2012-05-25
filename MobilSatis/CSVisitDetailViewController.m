//
//  CSVisitDetailViewController.m
//  MobilSatis
//
//  Created by ABH on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSVisitDetailViewController.h"


@implementation CSVisitDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer{
    self = [super initWithUser:myUser];
    customer = selectedCustomer;
    return  self;
}

-(IBAction)ignoreKeyboard{
    
    [self->textView resignFirstResponder];
    //   [self resignFirstResponder   ];
}
-(IBAction)checkIn:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ziyaret Girişi" 
                                                message:[NSString stringWithFormat:@"%@ müştersine ziyaret girişi yapıyorsunuz. Emin misiniz?",customer.name1]
                                               delegate:self 
                      
                                      cancelButtonTitle:@"İptal" 
                                      otherButtonTitles:@"Onayla", nil];
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([super isAnimationRunning]) {
            return;
        }
        ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
        [sapHandler setDelegate:self];
        [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_ZIYARET_GIRIS"];
        [sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
        [sapHandler addImportWithKey:@"I_CUST" andValue:customer.kunnr];
        [sapHandler addImportWithKey:@"I_TYPE" andValue:@"G"];
        [sapHandler addImportWithKey:@"I_TEXT" andValue:textView.text];
        [sapHandler addTableWithName:@"T_RETURN" andColumns:[NSMutableArray arrayWithObjects:@"KUNNR",@"DATE",@"STATUS", nil]];
        [sapHandler prepCall];
        
        [super playAnimationOnView:self.view];
        
        
        
    }
}
-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
    NSLog(@"%@",myResponse);
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"T_RETURN" fromEnvelope:myResponse];
    UIAlertView *alert;
    @try {
        if ([[responses objectAtIndex:0 ] isEqualToString: @"T"]) {
            alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" message:[NSString stringWithFormat:@"%@ müşterisine başarıyla ziyaret girişiniz yapıldı.",customer.name1] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        }
        else{
            alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Sistemde hata oluştu.Tekrar deneyiniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil]; 
        }
    }
    @catch (NSException *exception) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Sistem bağlatısında hata oluştu.Daha sonra tekrar deneyiniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil]; 
    }

    @finally {
            [alert show];
    }
        

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [[self  navigationItem] setTitle:@"Ziyaret Girişi"];
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

@end
