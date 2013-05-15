    //
//  CSProfileViewController.m
//  MobilSatis
//
//  Created by ABH on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSProfileViewController.h"

@interface CSProfileViewController ()

@end

@implementation CSProfileViewController
@synthesize TableView;
@synthesize welcomeLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewConfirmations{
    CSConfirmationListViewController *confirmationListViewController = [[CSConfirmationListViewController alloc] initWithUser:user];
    [[[self tabBarController] navigationController] pushViewController:confirmationListViewController animated:YES];
}

- (void)viewSales{
    CSUserSalesViewController *userSalesViewController = [[CSUserSalesViewController alloc] initWithUser:user];
    [[[self tabBarController] navigationController] pushViewController:userSalesViewController animated:YES];
}

- (void)viewEfesPilsenCommercials {
    CSEfesPilsenCommercialsViewController *efesPilsenCommercialsViewController = [[CSEfesPilsenCommercialsViewController alloc] init];
    [[[self tabBarController] navigationController] pushViewController:efesPilsenCommercialsViewController animated:YES];
}

- (void)viewConnectWithOtherMYK {
    CSConnectWithOtherMYKViewController *connectWithOtherMYKViewController = [[CSConnectWithOtherMYKViewController alloc] initWithUser:[self user]];
    [[self navigationController] pushViewController:connectWithOtherMYKViewController animated:YES];
}

- (void)viewESatisReports {
    CSFinancialReportViewController *financialReportViewController = [[CSFinancialReportViewController alloc] init];
    [[self navigationController] pushViewController:financialReportViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[[self tabBarController] navigationItem] setRightBarButtonItem:nil animated:YES];
    [welcomeLabel setText:[NSString stringWithFormat:@"%@ %@",welcomeLabel.text,user.name]];
    TableView.backgroundColor = [UIColor clearColor];
    TableView.opaque = NO;
    TableView.backgroundView = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpCompleted) name:@"startUpCompleted" object:nil];
    
    if (![CoreDataHandler isInternetConnectionNotAvailable]) {
        [super playAnimationOnView:self.view];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yenile" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshConfirmations)];
    [[[self tabBarController ]navigationItem] setRightBarButtonItem:nil];
    [[[self tabBarController ]navigationItem] setTitle:@"Profilim"];
    //[myTableView reloadData];
}

- (void)startUpCompleted {
    
    NSArray *arr = [[self navigationController] viewControllers];
    
    for (int i = 0; i < [arr count]; i++) {
        if ([[[[arr objectAtIndex:i] class] description] isEqualToString:@"CSLoginViewController"]) {
            CSBaseViewController *base = [arr objectAtIndex:i];
            [base stopAnimationOnView];
        }
    }
    [super stopAnimationOnView];
    
    if (![CoreDataHandler isInternetConnectionNotAvailable]) 
        [self checkCoreDataForWaitingVisit];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView tag] == 3) {
        if (buttonIndex == 1) {
            [self sendVisitDetailViaCoreData];
        }
    }
    else if([alertView tag] == 2)
    {
        NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOVisitDetail" sortingParameter:@"customerNumber" objectContext:[CoreDataHandler getManagedObject]];
        CDOVisitDetail *visitDetail = [arr objectAtIndex:0];
        
        [[CoreDataHandler getManagedObject] deleteObject:visitDetail];
        [CoreDataHandler saveEntityData];
        
        [self checkCoreDataForWaitingVisit];
    }
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
        
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse];
    
    if ([responses count] > 0) {
        NSString *booleanValue = [responses objectAtIndex:0];
        
        if ([booleanValue isEqualToString:@"T"]) {
            responses = [ABHXMLHelper getValuesWithTag:@"OBJ_ID" fromEnvelope:myResponse];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" message:[NSString stringWithFormat:@"Ziyaret yapıldı, %@ numaralı belge yaratıldı.", [responses objectAtIndex:0]] delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            [alert setTag:2];
            [alert show];
        }
        else if([booleanValue isEqualToString: @"Y"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Rekabet mevzuatı ve Rekabet Kurulu kararları gereği, yazdığınız açıklama kabul olmadığından ziyaret kaydedilemedi." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Sistemde hata oluştu. Ziyaret kaydedilemedi." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
        }
    }
}

# pragma mark - Core Data

- (void)checkCoreDataForWaitingVisit {
    NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOVisitDetail" sortingParameter:@"customerNumber" objectContext:[CoreDataHandler getManagedObject]];
    
    if ([arr count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Cihazınızda bekleyen Ziyaret detayları var, SAP'ye göndermek ister misiniz ? " delegate:self cancelButtonTitle:@"Hayır" otherButtonTitles:@"Evet", nil];
        [alert setTag:3];
        [alert show];
    }
    
}

- (void)sendVisitDetailViaCoreData {
    
    NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOVisitDetail" sortingParameter:@"customerNumber" objectContext:[CoreDataHandler getManagedObject]];
    CDOVisitDetail *tempVisitDetail = [arr objectAtIndex:0];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_ZIYARET_GIRIS"];
    [sapHandler addImportWithKey:@"I_UNAME" andValue:[tempVisitDetail userMyk]];
    [sapHandler addImportWithKey:@"I_CUST" andValue:[tempVisitDetail customerNumber]];
    [sapHandler addImportWithKey:@"I_TYPE" andValue:@"G"];
    [sapHandler addImportWithKey:@"I_TEXT" andValue:[tempVisitDetail text]];
    [sapHandler addTableWithName:@"T_RETURN" andColumns:[NSMutableArray arrayWithObjects:@"KUNNR",@"DATE",@"STATUS", nil]];
    
    [super playAnimationOnView:self.view];
    
    [sapHandler prepCall];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    if (section == 0) {
        return 1;
    }
    else {
        return 6;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    cell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    
    if (section == 0) {
        cell.textLabel.text = @"Hoşgeldiniz";
        cell.detailTextLabel.text = user.name;
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    else {
    switch (row) {
        case 0:
            cell.textLabel.text = @"Satışlarım";
            cell.selectionStyle = UITableViewCellAccessoryNone;    
            cell.imageView.image = [UIImage imageNamed:@"maviappiconlar-07.png"];

            break;
        case 1:
            cell.textLabel.text = @"Soğutucu Onayları";
            cell.imageView.image = [UIImage imageNamed:@"maviappiconlar-08.png"];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            break;
        case 2:
            cell.textLabel.text = @"Satış Analiz Onayları";
            cell.imageView.image = [UIImage imageNamed:@"sharePointOnay.png"];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            break;
        case 3:
            cell.textLabel.text = @"Başka Kullanıcı ile Giriş";
            cell.imageView.image = [UIImage imageNamed:@"profilim_mavi.png"];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            break;
        case 4:
            cell.textLabel.text = @"Finans Raporları";
            cell.imageView.image  = [UIImage imageNamed:@"chart_icon_mavi.png"];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            break;
        case 5:
            cell.textLabel.text = @"Efes Pilsen Reklamlar";
            cell.imageView.image = [UIImage imageNamed:@"efesLogo_mavi.png"];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            break;
        default:
            break;
    }
    }
    
    return cell;
}

-(void)viewSharePoint{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ma.efesintranet.com"]];

//    CSSharePointSafariViewController *sharePointViewController = [[CSSharePointSafariViewController alloc] init];
//    [[self navigationController] pushViewController:sharePointViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    if (section == 1) {
        switch (row) {
            case 0:
                [self viewSales];
                break;
            case 1:
                [self viewConfirmations];
                break;
            case 2:
                [self viewSharePoint];
                break;
            case 3:
                [self viewConnectWithOtherMYK];
                break;
            case 4:
                [self viewESatisReports];
                break;
            case 5:
                [self viewEfesPilsenCommercials];
                break;
            default:
                break;
        }
    }
    
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
