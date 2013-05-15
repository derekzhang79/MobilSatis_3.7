//
//  CSCityListViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 31.10.2012.
//
//

#import "CSCityListViewController.h"

@interface CSCityListViewController ()

@end

@implementation CSCityListViewController
@synthesize tableView, cityList, countyCode, cityCode;
@synthesize disctrictCode, district, custDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithInformation:(NSString *)city :(NSString *)county :(CSCustomerDetail *)customerDetail
{
    self = [super init];

    if (self) {
        cityList = [[NSMutableArray alloc] init];
        self.cityCode = city;
        self.countyCode = county;
        custDetail = [[CSCustomerDetail alloc] init];
        custDetail = customerDetail;
    }
    return  self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;
    
    [[self  navigationItem] setTitle:@"Mahalle Listesi"];
    
    [self getCityListFromSAP];
}

- (void)getCityListFromSAP {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_TR_CITY_LIST"];
    [sapHandler addImportWithKey:@"I_ILKOD" andValue:[self cityCode]];
    [sapHandler addImportWithKey:@"I_ILCEKOD" andValue:[self countyCode]];
    
    [sapHandler addTableWithName:@"ZMOB_SEMT_LIST" andColumns:[[NSMutableArray alloc] initWithObjects:@"SEMTKOD", @"SEMTAD", nil]];
    
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];

}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    
    NSString *response = [[ABHXMLHelper getValuesWithTag:@"ZMOB_TR_CITY_LIST" fromEnvelope:myResponse] objectAtIndex:0];
    
    [self initCityListFromEnvelope:response];
}

- (void)initCityListFromEnvelope:(NSString *)response {
    NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:response];
    NSMutableArray *broughCode = [ABHXMLHelper getValuesWithTag:@"SEMTKOD" fromEnvelope:response];
    NSMutableArray *broughName = [ABHXMLHelper getValuesWithTag:@"SEMTAD" fromEnvelope:response];
    
    for (int i = 0; i < [itemCount count]; i++) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[broughCode objectAtIndex:i], [broughName objectAtIndex:i], nil];
        [cityList addObject:arr];
    }
    
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    return [cityList count];
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
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [[cell textLabel] setText:[[cityList objectAtIndex:row] objectAtIndex:1]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self custDetail] setDistrinct:[[cityList objectAtIndex:[indexPath row]] objectAtIndex:1]];
    [[self custDetail] setDistrinctCode:[[cityList objectAtIndex:[indexPath row]] objectAtIndex:0]];
    
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
