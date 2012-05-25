//
//  CSProcessSelectionViewController.m
//  MobilSatis
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __ABH__. All rights reserved.
//

#import "CSProcessSelectionViewController.h"
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
#import "ABHConnectionInfo.h"
#import "CSCooler.h"
#import "CSCoolerSelectionViewController.h"
#import "CSTakeAwayDetailViewController.h"
@implementation CSProcessSelectionViewController
@synthesize customer,processType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self = [super init];
    customer = [[CSCustomer alloc] init];
    user = [[CSUser alloc] init];
    
    return self;
}

-(id)initWithCustomer:(CSCustomer*)myCustomer andUser:(CSUser *)myUser{ 
    self = [self init];
    [self setCustomer:myCustomer];
    [self setUser:myUser];
    return self;
}

-(id)initWithCustomer:(CSCustomer*)myCustomer andUser:(CSUser *)myUser andProcessType:(CSProcessType*)aProcessType{ 
    self = [self initWithCustomer:myCustomer andUser:myUser];
    [self setProcessType:aProcessType];
    return self;
}



-(IBAction)sendInstallation:(id)sender{
    if ([super isAnimationRunning]) {
        return;
    }
    
    [super playAnimationOnView:self.view];
    if (![self checkCustomerForProcess:@"installation"]) {
        return;
    }
    
    CSNewCoolerListViewController * newCoolerListViewController = [[CSNewCoolerListViewController alloc] initWithUser:user andSelectedCustomer:customer];
    [super stopAnimationOnView];
    [[self navigationController] pushViewController:newCoolerListViewController animated:YES];
    
}


-(IBAction)takeAwayCooler:(id)sender{
    if(    [super isAnimationRunning]){
        return;
    }
    if (![self checkCustomerForProcess:@"takeAway"]) {
        return;
    }
    CSTakeAwayDetailViewController *takeAwayDetailViewController = [[CSTakeAwayDetailViewController alloc] initWithCustomer:customer andUser:user];
    [[self navigationController] pushViewController:takeAwayDetailViewController animated:YES];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sökme İş Emri" 
    //                                                    message:[NSString stringWithFormat:@"Sökme iş emiri yaratılıyor. Emin misiniz?"]
    //                                                   delegate:self 
    //                                          cancelButtonTitle:@"İptal" 
    //                                          otherButtonTitles:@"Onayla", nil];
    //    [alert show];
    
    
    
}
-(void)getCoolersFromSap{
    NSString *tableName = [NSString stringWithFormat:@"COOLERS"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"TANIM"];
    [columns addObject:@"SERIAL_NUMBER"];
    //   [columns addObject:@"TYPE"];
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_COOLERS_OF_CUSTOMER"];//sogutucu alcak
    [sapHandler addImportWithKey:@"CUSTOMER" andValue:self.customer.kunnr];
    [ sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    
}



-(IBAction)reportFailure:(id)sender{
    if ([super  isAnimationRunning]) {
        return;
    }
    [super playAnimationOnView:self.view];
    if (![self checkCustomerForProcess:@"failure"]) {
        return;
    }
    selectedProcess = [NSString stringWithFormat:@"failure"];
    [self getCoolersFromSap];
    
    
    
}
-(void)sendTakeAwayOrderToSap{
    
    
}

-(void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
    if ([ABHXMLHelper hasThisTag:@"ZMOB_TEYIT_ITM_STR" fromfromEnvelope:myResponse]) {
        NSMutableArray *coolers = [[NSMutableArray alloc] init];    
        NSMutableArray *serials = [[NSMutableArray alloc] init];
        NSMutableArray *descriptions = [[NSMutableArray alloc] init];
        //     NSMutableArray *types = [[NSMutableArray alloc] init];
        serials = [ABHXMLHelper getValuesWithTag:@"SERIAL_NUMBER" fromEnvelope:myResponse];
        descriptions = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:myResponse];
        //  types = [ABHXMLHelper getValuesWithTag:@"TYPE" fromEnvelope:myResponse];
        CSCooler *tempCooler;
        for (int sayac = 0; sayac < [serials count]; sayac++) {
            tempCooler = [[CSCooler alloc] init];
            [tempCooler setSernr:[serials objectAtIndex:sayac]];
            [tempCooler setDescription:[descriptions objectAtIndex:sayac]];
            //         [tempCooler setType:[types objectAtIndex:sayac]];
            [coolers addObject:tempCooler];
        }
        [customer setCoolers:coolers];
        if ([coolers count]<=0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Soğutucu Bulunamadı" 
                                                            message:[NSString stringWithFormat:@"Seçtiğiniz noktada soğutucu bulunamadı."]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Tamam" 
                                                  otherButtonTitles: nil];
            [alert show];
            
        }else{
            CSCoolerSelectionViewController *coolerSelectionViewController = [[CSCoolerSelectionViewController alloc] initWithCustomer:customer andUser:user andProcess:selectedProcess];
            [[self navigationController] pushViewController:coolerSelectionViewController animated:YES];
            
        }
    }
    if([selectedProcess isEqualToString:@"takeAway"]){
        [self handleTakeAwayResponseFromSap:myResponse];
    }
}

-(void)handleTakeAwayResponseFromSap:(NSString*)myResponse{
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
        [alert show];
    }
}

-(void)initCoolersWithResponse:(NSString*)response{
    
}

- (BOOL)isCustomerDealer:(CSCustomer*)aCustomer{
    if ([customer.kunnr isEqualToString:[NSString stringWithFormat:@"%@",customer.dealer.kunnr]] ) {
        return YES;
    }
    else{
        return NO;
    }
}


-(BOOL)checkCustomerForProcess:(NSString*)selectedProcess{
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Delegation Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        selectedProcess = [NSString stringWithFormat:@"takeAway"];
        [self sendTakeAwayOrderToSap];
    }
}
#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationItem] setTitle:@"Yapılacak İşlem"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //  [activityIndicator setHidesWhenStopped:YES];
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
