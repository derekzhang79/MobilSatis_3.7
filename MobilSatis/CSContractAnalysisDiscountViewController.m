//
//  CSContractAnalysisDiscountViewController.m
//  MobilSatis
//
//  Created by Ata Cengiz on 9/6/12.
//
//

#import "CSContractAnalysisDiscountViewController.h"

@interface CSContractAnalysisDiscountViewController ()

@end

@implementation CSContractAnalysisDiscountViewController
@synthesize tableView;
@synthesize discountList;
@synthesize temp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDiscountList:(NSMutableArray *)arrayList{
    self = [super init];
        
    discountList     = [[NSMutableArray alloc] init];
    discountList = arrayList;
    
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self  navigationItem] setTitle:@"Iskonto Bilgileri"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [discountList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    else
    {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    int row = [indexPath row];
    int section = [indexPath section];
    
    temp = [[CSContractAnalysisDiscount alloc] init];
    
    temp = [discountList objectAtIndex:section];
    
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[temp contractType] isEqualToString:@"0001"] && [[temp contractType] isEqualToString:@"0002"]) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Katılım Türü";
                cell.detailTextLabel.text = @"İşletme Sermayesi";
                break;
            case 1:
                cell.textLabel.text = @"Aktarım Şekli";
                cell.detailTextLabel.text = [temp contractDescription];
                break;
            case 2:
                cell.textLabel.text = @"KDV Hariç Tutar";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ TL",[temp cashContractPrice]];
                break;
            case 3:
                cell.textLabel.text = @"Efes Oranı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp efesRate]];
                break;
            case 4:
                cell.textLabel.text = @"Diğer Oran";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp otherRate]];
                break;
            default:
                break;
        }
        
    }
    
    if ([[temp contractType] isEqualToString:@"0005"]) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Katılım Türü";
                cell.detailTextLabel.text = @"Fatura Altı İskonto";
                break;
            case 1:
                cell.textLabel.text = @"Tanım";
                cell.detailTextLabel.text = [temp contractDescription];
                break;
            case 2:
                cell.textLabel.text = @"İskonto Oranı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp discountPercent]];
                break;
            case 3:
                cell.textLabel.text = @"Efes Oranı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp efesRate]];
                break;
            case 4:
                cell.textLabel.text = @"Diğer Oran";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp otherRate]];
                [cell setHidden:YES];
                break;
            default:
                break;
        }

    }
    
    if ([[temp contractType] isEqualToString:@"0006"]) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Katılım Türü";
                cell.detailTextLabel.text = @"Dönemsel İskonto";
                break;
            case 1:
                cell.textLabel.text = @"Iskonto Alt Tipi";
                cell.detailTextLabel.text = [temp contractDescription];
                break;
            case 2:
                cell.textLabel.text = @"İskonto Oranı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp discountPercent]];
                break;
            case 3:
                cell.textLabel.text = @"Efes Oranı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp efesRate]];
                break;
            case 4:
                cell.textLabel.text = @"Diğer Oran";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp otherRate]];
                [cell setHidden:YES];
                break;
            default:
                break;
        }
        
    }
    
    if ([[temp contractType] isEqualToString:@"0007"]) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Katılım Türü";
                cell.detailTextLabel.text = @"İşletme Kredisi";
                break;
            case 1:
                [cell setHidden:YES];
                break;
            case 2:
                cell.textLabel.text = @"Tutar";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ TL",[temp cashContractPrice]];
                break;
            case 3:
                cell.textLabel.text = @"Efes Oranı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp efesRate]];
                break;
            case 4:
                cell.textLabel.text = @"Diğer Oran";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp otherRate]];
                break;
            default:
                break;
        }
    }
    
    if ([[temp contractType] isEqualToString:@"0010"]) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Katılım Türü";
                cell.detailTextLabel.text = @"Nakit Bazlı Aktarım";
                break;
            case 1:
                cell.textLabel.text = @"Aktarım Tarihi";
                cell.detailTextLabel.text = [temp transferDate];
                break;
            case 2:
                cell.textLabel.text = @"Katılım Miktarı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ TL",[temp cashContractPrice]];
                break;
            case 3:
                cell.textLabel.text = @"Efes Oranı";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp efesRate]];
                break;
            case 4:
                cell.textLabel.text = @"Diğer Oran";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%% %@",[temp otherRate]];
                break;
            default:
                break;
    }
    }
    
    return cell;
}

@end
