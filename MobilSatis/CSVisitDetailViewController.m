//
//  CSVisitDetailViewController.m
//  MobilSatis
//
//  Created by ABH on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSVisitDetailViewController.h"


@implementation CSVisitDetailViewController
@synthesize segment;
@synthesize imageView;
@synthesize newMedia;
@synthesize textView;
@synthesize mailList;
@synthesize popOver;

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
    if ([self checkTextField]) {
        [self showWarning];
        return;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Ziyaret açıklaması yapılması zorunludur." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
    }

    
    
}

- (void) showWarning {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ziyaret Girişi" 
                                                    message:[NSString stringWithFormat:@"%@ müştersine ziyaret girişi yapıyorsunuz. Emin misiniz?",customer.name1]
                                                   delegate:self 
                          
                                          cancelButtonTitle:@"İptal" 
                                          otherButtonTitles:@"Onayla", nil];
    [alert show];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) sendMailwithVisit {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Seç" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Çık" otherButtonTitles:@"Kamera", @"Dosya", nil];
    [action showInView:self.view];
}

- (void)composeMail {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    [picker setSubject:[NSString stringWithFormat:@"%@(%@) noktası ziyareti hk.",customer.name1,customer.kunnr]];
    if (imageView.image != nil) {
        UIImage *roboPic = imageView.image;
        NSData *imageData = UIImageJPEGRepresentation(roboPic, 1);
        [picker addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"ziyaretFoto.jpg"];
    }
    
    @try {
        if ([segment selectedSegmentIndex] == 1 ) {
                [picker setToRecipients:[NSArray arrayWithObjects:user.mail, nil]];
            }else{
                [picker setToRecipients:mailList];
         }
        [picker setCcRecipients:[NSArray arrayWithObject:@"saziye.ceylan@tr.anadoluefes.com"]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    NSString *emailBody = textView.text;
    [picker setMessageBody:emailBody isHTML:YES];
    
    [self presentModalViewController:picker animated:YES];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
   if (buttonIndex == 1) {
       [self useCamera];
    } 
     else if (buttonIndex == 2) {
         [self useCameraRoll];
     }
     else
     {
         [self composeMail];
     }
}

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *)kUTTypeImage,
                                  nil];
        
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = YES;
        
    }
}

- (void) useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
            
            popOver = [[UIPopoverController alloc] initWithContentViewController: imagePicker];
            
            popOver.delegate = self;
            
            [self.popOver presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        else {
            [self presentModalViewController:imagePicker animated:YES];
        }
        newMedia = NO;
    }
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    imageView = [[UIImageView alloc] initWithImage:image];
        
    // Dismiss the camera
    [self dismissModalViewControllerAnimated:YES];
    
    [self performSelector:@selector(composeMail) withObject:nil afterDelay:1.0];
    
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)sendVisitDetail {
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        [self sendVisitDetailViaCoreData];
    }
    else
    {
        ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
        [sapHandler setDelegate:self];
        [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_ZIYARET_GIRIS"];
        [sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
        [sapHandler addImportWithKey:@"I_CUST" andValue:customer.kunnr];
        [sapHandler addImportWithKey:@"I_TYPE" andValue:@"G"];
        [sapHandler addImportWithKey:@"I_TEXT" andValue:textView.text];
        [sapHandler addTableWithName:@"T_RETURN" andColumns:[NSMutableArray arrayWithObjects:@"KUNNR",@"DATE",@"STATUS", nil]];
        [sapHandler addTableWithName:@"T_MAIL" andColumns:[NSMutableArray arrayWithObjects:@"SMTP_ADDR", nil]];
        if ([segment selectedSegmentIndex] == 1 || [segment selectedSegmentIndex] == 2) {
            [sapHandler addImportWithKey:@"I_MAIL" andValue:@"X"];
        }
        [sapHandler prepCall];
        
        [super playAnimationOnView:self.view];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 5) {
        switch([segment selectedSegmentIndex]) 
        {
            case 1:
                [self performSelector:@selector(sendMailwithVisit) withObject:nil afterDelay:1.0];
                break;
            case 2:
                [self performSelector:@selector(sendMailwithVisit) withObject:nil afterDelay:1.0];
                break;
        }
    }
    
    if (buttonIndex == 1) {
        if ([super isAnimationRunning]) {
            return;
        }
        [self sendVisitDetail];
    }
}

- (void) sendNoteToSelf {
    
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    
//    picker.mailComposeDelegate = self;
//    [picker setSubject:[NSString stringWithFormat:@"%@ numaralı nokta ziyareti hk.",customer.kunnr]];
//    
//    @try {
//
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
//       
//    NSString *emailBody = textView.text;
//    [picker setMessageBody:emailBody isHTML:YES];
//    
//    [self presentModalViewController:picker animated:YES];
}

- (void)initMailList:(NSString *)envelope {
    
    self.mailList = [ABHXMLHelper getValuesWithTag:@"SMTP_ADDR" fromEnvelope:envelope];
    
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    
    [self initMailList:myResponse];
    
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse];
    UIAlertView *alert;
    @try {
        if ([[responses objectAtIndex:0 ] isEqualToString: @"T"]) {
            responses = [ABHXMLHelper getValuesWithTag:@"OBJ_ID" fromEnvelope:myResponse];
            alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" message:[NSString stringWithFormat:@"%@ müşterisine yapılan ziyarete istinaden %@ numarali belge yaratıldı.",customer.name1, [responses objectAtIndex:0]] delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            alert.tag = 5;

            
        }
        else if([[responses objectAtIndex:0 ] isEqualToString: @"Y"])
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Rekabet mevzuatı ve Rekabet Kurulu kararları gereği, metne dikkat ediniz." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            alert.tag = 6;

        }
        else{
            alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Sistemde hata oluştu.Tekrar deneyiniz." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            alert.tag = 5;

        }
    }
    @catch (NSException *exception) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Sistem bağlatısında hata oluştu.Daha sonra tekrar deneyiniz." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        alert.tag = 5;
    }
    
    @finally {
        [alert show];
    }
    
    
}

-(BOOL)checkTextField{
    if (textView.text.length == 0) {
        return NO;
    }else{
        return YES;
    }
}

# pragma mark - Core Data

- (void)sendVisitDetailViaCoreData {
    
    CDOVisitDetail *visitDetail = (CDOVisitDetail *)[CoreDataHandler insertEntityData:@"CDOVisitDetail"];

    [visitDetail setCustomerNumber:[customer kunnr]];
    [visitDetail setUserMyk:[user username]];
    [visitDetail setText:[textView text]];
    
    [CoreDataHandler saveEntityData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mailList = [[NSMutableArray alloc] init];
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
