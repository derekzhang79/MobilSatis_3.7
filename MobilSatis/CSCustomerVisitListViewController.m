//
//  CSCustomerVisitListViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 28.09.2012.
//
//

#import "CSCustomerVisitListViewController.h"

@interface CSCustomerVisitListViewController ()

@end

@implementation CSCustomerVisitListViewController
@synthesize tableView, visitList, customer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer *)selectedCustomer{
    self = [super initWithUser:myUser];
    
    visitList = [[NSMutableArray alloc] init];
    
    [self setCustomer:selectedCustomer];
    
    return  self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;
    
    
    [self getVisitListDetailsFromSAP];
}

- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Ziyaret Listesi"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)correctDateComponent:(NSInteger)component{
    if (component<10) {
        return [NSString stringWithFormat:@"0%d",component];
    }else {
        return [NSString stringWithFormat:@"%d",component];
    }
}

- (void)getVisitListDetailsFromSAP {
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_NOKTA_ZIYARET_LISTESI"];
    
    
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    // we're just interested in the month and year components
    NSDateComponents *nowComps = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                        fromDate:now];
    NSInteger month = [nowComps month];
    NSInteger year = [nowComps year];
    
    // now calculate the new month and year values
    NSInteger newMonth = month - 1;
    
    // deal with overflow/underflow
    NSInteger newYear = year + newMonth / 12;
    newMonth = newMonth % 12;
    
    // month is 1-based, so if we've ended up with the 0th month,
    // make it the 12th month of the previous year
    if (newMonth == 0) {
        newMonth = 12;
        newYear = newYear - 1;
    }
    
    NSString *currentDate = [NSString stringWithFormat:@"%i%@%@", year, [self correctDateComponent:month], [self correctDateComponent:[nowComps day]]];
    NSString *newDate = [NSString stringWithFormat:@"%i%@%@", newYear, [self correctDateComponent:newMonth], [self correctDateComponent:[nowComps day]]];
    
    [sapHandler addImportWithKey:@"I_NOKTA" andValue:customer.kunnr];
    [sapHandler addImportWithKey:@"I_BEGDA" andValue:newDate];
    [sapHandler addImportWithKey:@"I_ENDDA" andValue:currentDate];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"MYK"];
    [columns addObject:@"NAME1"];
    [columns addObject:@"DATE"];
    
    [sapHandler addTableWithName:@"ET_ZIYARETLER" andColumns:columns];

    [super playAnimationOnView:self.view];

    [sapHandler prepCall];
    
    //[activityIndicator startAnimating];

}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    //NSLog(@"%@", myResponse);
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
        CDOCustomerDetail *custDetail;
        
        if ([arr count] > 0) {
            custDetail = [arr objectAtIndex:0];
        }
        
        for (CDOCustomerVisitList *tempVisitList in [custDetail customerVisitList] ) {
            NSArray *arr2 = [[NSArray alloc] initWithObjects:[tempVisitList myk], [tempVisitList name], [tempVisitList date], nil];
            
            [visitList addObject:arr2];
        }
        
        if ([visitList count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bilgi" message:@"Noktaya ziyaret yapılmamıştır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            [alert show];
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
    else {
        NSArray *arr = [ABHXMLHelper getValuesWithTag:@"ZMOB_NOKTA_ZIYARET" fromEnvelope:myResponse];
        if ([arr count] > 0) {
            [self initVisitListWithEnvelope:[arr objectAtIndex:0]];
        }
        if ([self haveAnyVisit]) {
            [tableView reloadData];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bilgi" message:@"Noktaya ziyaret yapılmamıştır." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            [alert show];
            [[self navigationController] popViewControllerAnimated:YES];
        }

    }
}

-(BOOL)haveAnyVisit{
    if (visitList.count>0) {
        return YES;
    }
    return NO;
}

- (void)initVisitListWithEnvelope:(NSString *)envelope {
    [super stopAnimationOnView];
    
    NSMutableArray *items = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    
    NSMutableArray *myk = [ABHXMLHelper getValuesWithTag:@"MYK" fromEnvelope:envelope];
    NSMutableArray *name = [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:envelope];
    NSMutableArray *date = [ABHXMLHelper getValuesWithTag:@"DATE" fromEnvelope:envelope];
    
    for (int i = ([items count] - 1); i > 0; i--) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[myk objectAtIndex:i], [name objectAtIndex:i], [date objectAtIndex:i], nil];
        
        [visitList addObject:arr];
    }
    
    [self saveCustomerVisitListToCoreData];
}

#pragma mark - Core Data methods

- (void)saveCustomerVisitListToCoreData {
    
    CDOCustomerDetail *cust = (CDOCustomerDetail *)[CoreDataHandler insertExistingEntityData:@"CDOCustomerDetail" andValueForSort:@"kunnr"];
    
    for(int i = 0; i < [visitList count]; i++)
    {
        CDOCustomerVisitList *customerVisitList = (CDOCustomerVisitList *)[CoreDataHandler insertEntityData:@"CDOCustomerVisitList"];
        [customerVisitList setMyk:[[visitList objectAtIndex:i] myk]];
        [customerVisitList setName:[[visitList objectAtIndex:i] name]];
        [customerVisitList setDate:[[visitList objectAtIndex:i] date]];
        
        [cust addCustomerVisitListObject:customerVisitList];
    }
    
    [CoreDataHandler saveEntityData];
}

- (void)checkExistingCoreDataToDelete {
    
    NSArray *arr = [CoreDataHandler fetchCustomerDetailByKunnr:[customer kunnr]];
    CDOCustomerDetail *customerDetail;
    
    if ([arr count] > 0)
        customerDetail = [arr objectAtIndex:0];
    
    
    for (CDOCustomerVisitList *temp in [customerDetail customerVisitList])
         [[CoreDataHandler getManagedObject] deleteObject:temp];
    
    [customerDetail setCustomerVisitList:nil];
    
    [CoreDataHandler saveEntityData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    return [visitList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    else
    {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell detailTextLabel] setTextColor:[UIColor blackColor]];
    [[cell textLabel] setText:[[visitList objectAtIndex:row] objectAtIndex:1]];
    [[cell detailTextLabel] setText:[[visitList objectAtIndex:row] objectAtIndex:2]];
    
    return cell;

}

@end
