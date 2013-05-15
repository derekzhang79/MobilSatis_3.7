//
//  CSNewCoolerListViewController.m
//  CrmServis
//
//  Created by ABH on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSNewCoolerListViewController.h"

@implementation CSNewCoolerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*) selectedCustomer{
    self = [super initWithUser:myUser];
    user = myUser;
    customer = selectedCustomer;
   // [customer setRelationship:@"09"]; for testing!
    [self getCoolers];
    
    
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return coolers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCooler *tempCooler = [[CSCooler alloc] init]; 
    tempCooler = [coolers objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [[cell textLabel] setText:[tempCooler  description]];
    [[cell detailTextLabel] setText:[tempCooler matnr]];
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
    
        //[cell setTextColor:[CSApplicationProperties getUsualTextColor]];
    cell.textLabel.textColor = [UIColor whiteColor];

    //[cell setTextColor:[CSApplicationProperties  getUsualTextColor]];
    if ([tempCooler.type isEqualToString:@"FICI_SOG"]) {
        cell.imageView.image = [UIImage imageNamed:@"appiconlar-09.png"]; 
    }
    else{
       // [cell setAccessoryType:UITableViewCellAccessoryCheckmark]; çirkin oldu.
       cell.imageView.image = [UIImage imageNamed:@"appiconlar-10.png"]; 
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([super isAnimationRunning]) {
        return;
    }
   selectedCooler = [coolers objectAtIndex:indexPath.row];
    if ([selectedCooler.type isEqualToString:@"SISE_SOG"]) {
        //alert view
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Soğutucu Kurulum" 
                                                        message:[NSString stringWithFormat:@"%@ model soğutucu kurulum aktivitesi yaratılıyor. Emin misiniz?",selectedCooler.description]
                                                       delegate:self 
                              
                                              cancelButtonTitle:@"İptal" 
                                              otherButtonTitles:@"Onayla", nil];
        [alert show];
        
    }else{
        CSCooler *tempCooler = [coolers objectAtIndex:indexPath.row];
        CSTowerAndSpoutSelectionViewController *towerAndSpoutSelectionViewController = [[CSTowerAndSpoutSelectionViewController alloc ] initWithUser:user andCustomer:customer andSelectedCooler:tempCooler];
        [[self navigationController] pushViewController:towerAndSpoutSelectionViewController animated:YES];
    
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [super playAnimationOnView:self.view];
        //call rfc
        ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
        [sapHandler setDelegate:self];
        [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CREATE_ACTIVITY_BY_SALES"];//sogutucu alcak
        [sapHandler addImportWithKey:@"IP_TYPE" andValue:@"KURULUM"];
        [sapHandler addImportWithKey:@"IP_CUSTOMER" andValue:customer.kunnr];//customer:1001225kunnr
        [sapHandler addImportWithKey:@"SOGUTUCU" andValue:selectedCooler.matnr];
        [sapHandler addImportWithKey:@"USERNAME" andValue:user.username];
        [sapHandler prepCall];
        
    }
    
}
-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    [super stopAnimationOnView];
    NSString *installationNumber = [[NSString alloc] init];
    
    installationNumber = [[ABHXMLHelper getValuesWithTag:@"OBJECT_ID" fromEnvelope:myResponse] objectAtIndex:0];
    if([installationNumber isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" 
                                                        message:[NSString stringWithFormat:@"Kurulum belgesi yaratılamadı. Lütfen tekrar deneyiniz."]
                                                       delegate:nil
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" 
                                                        message:[NSString stringWithFormat:@"%@  numarali belge yaratildi.", installationNumber]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Tamam" 
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)getCoolers{
    //check customer relationship and get coolers wrt
    coolers = [CSNewCoolerList getNewCoolerList];
    [self filterCoolers];
    
}
-(void)filterCoolers{
    if ([customer.relationship isEqualToString:@"09"]||([customer.relationship isEqualToString:@"06"] && [customer.role isEqualToString:@"BB" ])) {
        CSCooler *tempCooler;
        NSMutableArray *tempCoolers = [[NSMutableArray alloc] init];
        for (int sayac = 0; sayac < coolers.count; sayac++) {
            tempCooler = [coolers objectAtIndex:sayac];
            if ([[tempCooler type] isEqualToString:@"FICI_SOG"]) {
                [tempCoolers addObject:tempCooler];
            }
        }
        coolers = tempCoolers;
        [tableView reloadData];
    }
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    [tableView setSeparatorColor:[UIColor colorWithRed:0.255f green:0.246f blue:0.176f alpha:1]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationItem] setTitle:@"Soğutucular"];
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
