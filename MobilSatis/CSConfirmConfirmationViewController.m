//
//  CSConfirmConfirmationViewController.m
//  CrmServisPrototype
//
//  Created by ABH on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSConfirmConfirmationViewController.h"
#import "ABHSAPHandler.h"
@implementation CSConfirmConfirmationViewController
@synthesize myConfirmation,delegate;
-(id)init{
    self  = [super init];
    
    
    return self;
}
-(id)initWithConfirmation:(CSConfirmation*)aConfirmation{
    
    self = [self init];
    selectedProcess = [[NSString alloc] init];
    myConfirmation = aConfirmation;
    return self;
}
-(id)initWithConfirmation:(CSConfirmation*)aConfirmation andItems:(NSMutableArray*)myItems{
    self = [self initWithConfirmation:aConfirmation];
    [myConfirmation setItems:myItems];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    return [myConfirmation.items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //create row
    
    CSCooler *tempCooler = [[self.myConfirmation items] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    [[cell textLabel] setText:[tempCooler description]];
    [[cell detailTextLabel] setText:[tempCooler sernr]];
    //    //    [[cell detailTextLabel] setHighlighted:YES];
    
    return cell;
}



-(IBAction)confirmConfirmation:(id)sender{
        selectedProcess = [NSString stringWithFormat:@"confirm"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Teyit Onaylanıyor" 
                                                    message:[NSString stringWithFormat:@"%@ numaralı teyiti onaylıyorsunuz. Emin misiniz?",myConfirmation.confirmationNumber]
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
        [super playAnimationOnView:self.view];
        if ([selectedProcess isEqualToString:@"confirm"]) {
                    [self  confirmConfirmationFromSap];
        }else{
                  [self  cancelConfirmationFromSap];
        }

    }
    
}
-(IBAction)showActivityReason{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aktivite Nedeni" 
                                                    message:[NSString stringWithFormat:@"%@",myConfirmation.activityReason]
                                                   delegate:nil
                          
                                          cancelButtonTitle:@"Tamam" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    
}
-(void)confirmConfirmationFromSap{

    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CONFIRM_CONFIRMATION"];
    [sapHandler addImportWithKey:@"OBJECTID" andValue:[myConfirmation confirmationNumber]];
    [sapHandler addImportWithKey:@"STATUS" andValue:@"E0004"];
    [sapHandler prepCall];
    
    
}
-(IBAction)cancelConfirmation{
    selectedProcess = [NSString stringWithFormat:@"cancel"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Teyit İptali" 
                                                    message:[NSString stringWithFormat:@"%@ numaralı teyiti iptal ediyorsunuz. Emin misiniz?",myConfirmation.confirmationNumber]
                                                   delegate:self 
                          
                                          cancelButtonTitle:@"İptal" 
                                          otherButtonTitles:@"Onayla", nil];
    [alert show];
}
-(void)cancelConfirmationFromSap{

    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CONFIRM_CONFIRMATION"];
    [sapHandler addImportWithKey:@"OBJECTID" andValue:[myConfirmation confirmationNumber]];
    [sapHandler addImportWithKey:@"STATUS" andValue:@"E0003"];
    [sapHandler prepCall];    
}
-(void)getResponseWithString:(NSString*)myResponse{
    NSMutableArray *status =  [ABHXMLHelper getValuesWithTag:@"CONFIRMSTATUS" fromEnvelope:myResponse];
    UIAlertView *alert;
    if([[status objectAtIndex:0] isEqualToString:@"T"]){
        
        if ([selectedProcess isEqualToString:@"confirm"]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Onay Durumu" 
                                           message:[NSString stringWithFormat:@"%@ numaralı teyit başarıyla onaylandı.",myConfirmation.confirmationNumber]
                                          delegate:nil
                 
                                 cancelButtonTitle:@"Tamam" 
                                 otherButtonTitles:nil, nil];
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"İptal Durumu" 
                                               message:[NSString stringWithFormat:@"%@ numaralı teyit başarıyla iptal edildi.",myConfirmation.confirmationNumber]
                                              delegate:nil 
                     
                                     cancelButtonTitle:@"Tamam" 
                                     otherButtonTitles:nil, nil];    
        }
        //now remove that current confirmation
        [delegate removeConfirmation:myConfirmation];
        
    }else{
        if ([selectedProcess isEqualToString:@"confirm"]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Onay Durumu" 
                                           message:[NSString stringWithFormat:@"%@ numaralı teyit onaylanamadı. Belge hatalı.",myConfirmation.confirmationNumber]
                                          delegate:nil 
                 
                                 cancelButtonTitle:@"Tamam" 
                                 otherButtonTitles:nil,
                 nil];
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"Onay Durumu" 
                                               message:[NSString stringWithFormat:@"%@ numaralı teyit iptal edilemedi. Belge hatalı.",myConfirmation.confirmationNumber]
                                              delegate:nil 
                     
                                     cancelButtonTitle:@"Tamam" 
                                     otherButtonTitles:nil,
                     nil];    
        }
    }
    [alert show];
        [[self navigationController] popViewControllerAnimated:YES];
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
    // Do any additional setup after loading the view from its nib.
    [confirmationNumber setText:[myConfirmation confirmationNumber]];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    [customerName setText:[[myConfirmation customer] name1]];
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
