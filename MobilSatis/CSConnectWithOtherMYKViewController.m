//
//  CSConnectWithOtherMYKViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 24.04.2013.
//
//

#import "CSConnectWithOtherMYKViewController.h"
#import "CSLoginViewController.h"
@interface CSConnectWithOtherMYKViewController ()

@end

@implementation CSConnectWithOtherMYKViewController

@synthesize otherMYKList, otherMYKTableList, tableView, lastMYK, lastMYKList, filteredListContent, searchTerm;
int countNumber = 0;

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
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    [[self navigationItem] setTitle:@"Başka Kullanıcı ile Giriş"];
    [self getMYKListFromSAP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUser:(CSUser *)myUser {
    self = [super initWithUser:myUser];
    otherMYKList = [[NSMutableArray alloc] init];
    otherMYKTableList = [[NSMutableArray alloc] init];
    lastMYKList = [[NSMutableArray alloc] init];
    filteredListContent = [[NSMutableArray alloc] init];
    
    [otherMYKList removeAllObjects];
    [otherMYKTableList removeAllObjects];
    [lastMYKList removeAllObjects];
    [filteredListContent removeAllObjects];
    
    countNumber = 0;
    
    lastMYK = nil;
    return self;
}

- (void)getMYKListFromSAP {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_MYK_LIST"];
    //    [sapHandler addImportWithKey:@"I_PARTNER" andValue:[[self user] username]];
    [sapHandler addImportWithKey:@"I_PARTNER" andValue:[[self user] username]];
    [sapHandler addTableWithName:@"T_MYK_LIST" andColumns:[NSMutableArray arrayWithObjects:@"COUNTER", @"PARTNER", @"NAME_ORG1", @"NAME_ORG2", @"PARTNER2", @"SALES_OFFICE", nil]];
    [sapHandler prepCall];
    
    [super playAnimationOnView:self.view];
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    
    if ([[me RFCNameLine] rangeOfString:@"ZMOB_GET_MYK_LIST" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSRange range = [myResponse rangeOfString:@"item"];
        
        if (range.length > 0) {
            [self initOtherMYKListFromEnvelope:myResponse];
        }
    }
    if ([[me RFCNameLine] rangeOfString:@"ZMOB_CONNECT_WITH_OTHER_MYK" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSRange range = [myResponse rangeOfString:@"E_RETURN"];
        if (range.length > 0) {
            NSString *e_return = [[ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse] objectAtIndex:0];
            if (![e_return isEqualToString:@"F"]) {
                {
                    NSArray *viewsArray = [self.navigationController viewControllers];
                    CSLoginViewController *login = (CSLoginViewController *)[viewsArray objectAtIndex:0];
                    [self.navigationController popToViewController:login animated:YES];
                    login.username.text = [[ABHXMLHelper getValuesWithTag:@"E_PARTNER" fromEnvelope:myResponse] objectAtIndex:0];
                    login.password.text = [[ABHXMLHelper getValuesWithTag:@"E_PASSWORD" fromEnvelope:myResponse] objectAtIndex:0];
                    login.user.sapUser = [[ABHXMLHelper getValuesWithTag:@"E_SAPUSER" fromEnvelope:myResponse] objectAtIndex:0];
                    
                    login.isAdmin = @"X";
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Seçilen kullanıcı ile alakalı hata alındı." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    
}

- (void)initOtherMYKListFromEnvelope:(NSString *)envelope {
    @try {
        NSArray *objectCount = [[NSArray alloc] init];
        NSArray *counterObject = [[NSArray alloc] init];
        NSArray *partnerObject = [[NSArray alloc] init];
        NSArray *name_org1Object = [[NSArray alloc] init];
        NSArray *name_org2Object = [[NSArray alloc] init];
        NSArray *partner2 = [[NSArray alloc] init];
        NSArray *sales_office = [[NSArray alloc] init];
        
        objectCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
        counterObject = [ABHXMLHelper getValuesWithTag:@"COUNTER" fromEnvelope:envelope];
        partnerObject = [ABHXMLHelper getValuesWithTag:@"PARTNER" fromEnvelope:envelope];
        name_org1Object = [ABHXMLHelper getValuesWithTag:@"NAME_ORG1" fromEnvelope:envelope];
        name_org2Object = [ABHXMLHelper getValuesWithTag:@"NAME_ORG2" fromEnvelope:envelope];
        partner2 = [ABHXMLHelper getValuesWithTag:@"PARTNER2" fromEnvelope:envelope];
        sales_office = [ABHXMLHelper getValuesWithTag:@"SALES_OFFICE" fromEnvelope:envelope];
        
        for (int i = 0; i < [objectCount count]; i++) {
            CSOtherMYK *otherMYK = [[CSOtherMYK alloc] init];
            [otherMYK setCounter:[counterObject objectAtIndex:i]];
            [otherMYK setPartner:[partnerObject objectAtIndex:i]];
            [otherMYK setName_org1:[name_org1Object objectAtIndex:i]];
            [otherMYK setName_org2:[name_org2Object objectAtIndex:i]];
            [otherMYK setPartner2:[partner2 objectAtIndex:i]];
            [otherMYK setSales_office:[self getCorrectSalesOfficeText:[sales_office objectAtIndex:i]]];
            
            [otherMYKList addObject:otherMYK];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if ([otherMYKList count] > 0)
        [self modifyArrayContents:otherMYKList];
}

- (NSString *)getCorrectSalesOfficeText:(NSString *)salesOffice {
    if ([salesOffice isEqualToString:@"O 50000002"])
        return @"İstanbul Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000003"])
        return @"Doğu Marmara Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000004"])
        return @"Trakya Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000005"])
        return @"Ege Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000006"])
        return @"Orta Anadolu Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000008"])
        return @"Güney Marmara Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000009"])
        return @"Güney Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000010"])
        return @"Karadeniz Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000011"])
        return @"Akdeniz Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000012"])
        return @"Güney Ege Satış Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000930"])
        return @"İstanbul Beyoğlu Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000931"])
        return @"Doğu Marmara Bayiler Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000932"])
        return @"Ege Bayiler Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000933"])
        return @"Orta Anadolu Bayiler Müdürlüğü";
    else if ([salesOffice isEqualToString:@"O 50000934"])
        return @"Güney Doğu Bayiler Müdürlüğü";
    else
        return @"Merkez";
}

- (void)modifyArrayContents:(NSMutableArray *)mykList {
    
    CSOtherMYK *myk = [[CSOtherMYK alloc] init];
    myk = [mykList objectAtIndex:0];
    [otherMYKTableList addObject:myk];
    
    for (int i = 1; i < [mykList count]; i++) {
        if (![[myk sales_office] isEqualToString:[[mykList objectAtIndex:i] sales_office]]) {
            [otherMYKTableList addObject:[mykList objectAtIndex:i]];
        }
        myk = [mykList objectAtIndex:i];
    }
    [tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [filteredListContent count];
    else
        return [otherMYKTableList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    int row = [indexPath row];
    
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    [cell.imageView setImage:nil];
    cell.accessoryView = nil;
    
    cell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    
    if(![UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    }
    
    if (countNumber == 0 && tableView != self.searchDisplayController.searchResultsTableView)
        cell.textLabel.text = [[otherMYKTableList objectAtIndex:row] sales_office];
    else if ([lastMYKList count] > 0 && row == 0)
    {
        UIButton *sendMYK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [sendMYK setFrame:CGRectMake(0, 0, 50, 30)];
        [sendMYK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendMYK setTitle:@"Seç" forState:UIControlStateNormal];
        [sendMYK addTarget:self action:@selector(sendSelectedOtherMYKToSAP) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = sendMYK;
        
        if (tableView != self.searchDisplayController.searchResultsTableView) {
            [[cell imageView] setImage:[UIImage imageNamed:@"BackArrow.png"]];
            [cell.imageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonTapped)];
            [tap setNumberOfTapsRequired:1];
            [cell.imageView setGestureRecognizers:[NSArray arrayWithObject:tap]];
        }
        
        cell.textLabel.text = [[otherMYKTableList objectAtIndex:row] name_org1];
        cell.detailTextLabel.text = [[otherMYKTableList objectAtIndex:row] name_org2];
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [[filteredListContent objectAtIndex:row] name_org1];
        cell.detailTextLabel.text = [[filteredListContent objectAtIndex:row] name_org2];
    }
    else
    {
        cell.textLabel.text = [[otherMYKTableList objectAtIndex:row] name_org1];
        cell.detailTextLabel.text = [[otherMYKTableList objectAtIndex:row] name_org2];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];
    
    CSOtherMYK *myk = [[CSOtherMYK alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        myk = [filteredListContent objectAtIndex:row];
        NSArray *arr = [filteredListContent mutableCopy];
        [lastMYKList addObject:arr];
    }
    else
    {
        myk = [otherMYKTableList objectAtIndex:row];
        NSArray *arr = [otherMYKTableList mutableCopy];
        [lastMYKList addObject:arr];
    }
    
    [otherMYKTableList removeAllObjects];
    
    if (countNumber == 0) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"counter" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray = [otherMYKList sortedArrayUsingDescriptors:sortDescriptors];
        NSString *count;
        
        countNumber = [[(CSOtherMYK *)[sortedArray objectAtIndex:0] counter] intValue];
        NSMutableArray *tableListBuffer = [[NSMutableArray alloc] init];
        
        
        for (int i = 0; i < [sortedArray count]; i++) {
            if ([[[sortedArray objectAtIndex:i] sales_office] isEqualToString:[myk sales_office]]) {
                [tableListBuffer addObject:[sortedArray objectAtIndex:i]];
            }
        }
        [tableListBuffer sortedArrayUsingDescriptors:sortDescriptors];
        count = [(CSOtherMYK *)[tableListBuffer objectAtIndex:0] counter];
        
        for (int i = 0; i < [tableListBuffer count]; i++) {
            if ([[(CSOtherMYK *)[tableListBuffer objectAtIndex:i] counter] isEqualToString:count]) {
                [otherMYKTableList addObject:[tableListBuffer objectAtIndex:i]];
            }
        }
        
        lastMYK = myk;
        [otherMYKTableList insertObject:lastMYK atIndex:0];
    }
    else
    {
        countNumber--;
        lastMYK = myk;
        for (int i = 0; i < [otherMYKList count]; i++) {
            if ([[[otherMYKList objectAtIndex:i] partner2] isEqualToString:[lastMYK partner]]) {
                [otherMYKTableList addObject:[otherMYKList objectAtIndex:i]];
            }
        }
        [otherMYKTableList insertObject:lastMYK atIndex:0];
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)backButtonTapped {
    
    [otherMYKTableList removeAllObjects];
    otherMYKTableList = [lastMYKList objectAtIndex:[lastMYKList count] - 1];
    [lastMYKList removeLastObject];
    
    if ([lastMYKList count] == 0)
        countNumber = 0;
    else
        countNumber++;
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)sendSelectedOtherMYKToSAP {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CONNECT_WITH_OTHER_MYK"];
    [sapHandler addImportWithKey:@"I_PARTNER" andValue:[lastMYK partner]];
    [sapHandler prepCall];
    
    [super playAnimationOnView:self.view];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self->filteredListContent removeAllObjects]; // First clear the filtered array.
    
    for (int i = 0; i < [otherMYKList count]; i++) {
        CSOtherMYK *otherMYK = [otherMYKList objectAtIndex:i];
        NSString *string = otherMYK.name_org2;
        
        NSComparisonResult result = [string compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame)
        {
            [self->filteredListContent addObject:[otherMYKList objectAtIndex:i]];
        }
    }
    
    [tableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
    //    //[controller.searchResultsTableView setDelegate:self];
    //
    //    UIImageView *anImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-01.png"]];
    //    controller.searchResultsTableView.backgroundView = anImage;
    //
    //controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    controller.searchResultsTableView.backgroundColor = [UIColor clearColor];
}
@end
