//
//  CSReportProblemViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 02.10.2012.
//
//

#import "CSReportProblemViewController.h"

@interface CSReportProblemViewController ()

@end

@implementation CSReportProblemViewController
@synthesize textView;
@synthesize isStandartText;

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
    
    [textView clearsContextBeforeDrawing];
    [textView setTextColor:[UIColor blackColor]];

    [textView setText:@"Lütfen bildirmek istediğiniz şikayeti girin."];
    
    isStandartText = YES;
    
    [[self navigationItem] setTitle:@"Şikayet Bildirme"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendReportToSap:(id)sender {
    if (![self checkFailureDescription] || [super isAnimationRunning]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorun Bildirme"
                                                    message:@"Şikayetinizi yetkili birime bildirmek istediğine emin misiniz ?"
                                                   delegate:self
                          
                                          cancelButtonTitle:@"İptal"
                                          otherButtonTitles:@"Onayla", nil];
    [alert setTag:1];
    [alert show];
}


- (BOOL)checkFailureDescription{
    if ([textView.text isEqualToString:@""] || isStandartText) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata"
                                                        message:@"Lütfen şikayeti yazınız"
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
    }
}

- (IBAction)ignoreKeyboard{
    
    [self.textView resignFirstResponder];
    //   [self resignFirstResponder   ];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    [super stopAnimationOnView];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    @try {
        arr = [ABHXMLHelper getValuesWithTag:@"E_RESULT" fromEnvelope:myResponse];
        
        if ([arr count] > 0) {
            NSString *str = [arr objectAtIndex:0];
            
            if ([str isEqualToString:@"T"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Başarılı"
                                                                message:@"Şikayet Bildirildi"
                                                               delegate:self
                                                      cancelButtonTitle:@"Tamam"
                                                      otherButtonTitles: nil];
                [[self navigationController] popViewControllerAnimated:YES];
                [alert setTag:2];
                [alert show];

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Başarısız"
                                                                message:@"Gönderim sırasında hata oluştu"
                                                               delegate:self
                                                      cancelButtonTitle:@"Tamam"
                                                      otherButtonTitles: nil];
                [[self navigationController] popViewControllerAnimated:YES];
                [alert setTag:2];

                [alert show];

            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
        
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch ([alertView tag]) {
        case 1:
            if (buttonIndex == 1) {
                
                if ([self checkFailureDescription]) {
                    
                    [super playAnimationOnView:self.view];
                    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
                    [sapHandler setDelegate:self];
                    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_SIKAYET_GIRIS"];//sogutucu alcak
                    [sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
                    [sapHandler addImportWithKey:@"I_TEXT" andValue:textView.text];
                    
                    [sapHandler prepCall];

                }
            }
            break;
        case 2:
            [[self navigationController] popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
}

@end
