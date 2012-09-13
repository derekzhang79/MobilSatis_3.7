//
//  CSContractAnalysisViewController.m
//  MobilSatis
//
//  Created by Ata Cengiz on 9/3/12.
//
//

#import "CSContractAnalysisViewController.h"

@interface CSContractAnalysisViewController ()

@end

@implementation CSContractAnalysisViewController
@synthesize tableView;
@synthesize contractAnalysis;
@synthesize contractDiscount, discountList;
@synthesize contractDiscountViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(NSString *)selectedCustomer{
    self = [super initWithUser:myUser];
    contractAnalysis = [[CSContractAnalysis alloc] init];
    contractAnalysis.kunnr = selectedCustomer;
    
    discountList     = [[NSMutableArray alloc] init];
    
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;
    
    [self getContractAnalysisFromSAP];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [[self  navigationItem] setTitle:@"Katılım Analizi"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)getContractAnalysisFromSAP{
    
    //ZCRM_MUSTERI_MASTER
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZSDKA_DATA_SEND_MOBIL"];
    
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:@"0001001257"];//self.contractAnalysis.kunnr];
    [sapHandler addImportWithKey:@"I_MYK" andValue:@"0031026001"];//user.username];
    
    [sapHandler addTableWithName:@"ET_ISKONTO" andColumns:[NSArray arrayWithObjects:@"IDNUM",@"KATUR",@"MATNR",
                                                           @"AKTAR", @"KTMIK", @"KOBRM", @"NKTUT", @"NKTUT_TOP", @"EFSRT",
                                                           @"DGRRT", @"LBFYT", @"LBMLY", @"USVFN", @"THLTR", @"ATHLTR",
                                                           @"ISNAS", @"PKNAS", @"IKTAS", @"ISERT", @"ISERK", @"ISKRT",
                                                           @"DISTY", nil]];
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];

}

- (void)initContractHeaderInformation:(NSString *)envelope {
    
    @try {
        contractAnalysis.name = [[ABHXMLHelper getValuesWithTag:@"NAMES" fromEnvelope:envelope] objectAtIndex:0];
        contractAnalysis.contractNo = [[ABHXMLHelper getValuesWithTag:@"KANUM" fromEnvelope:envelope] objectAtIndex:0];
        contractAnalysis.version = [[ABHXMLHelper getValuesWithTag:@"TERMS" fromEnvelope:envelope] objectAtIndex:0]; //emin değilim bundan
        contractAnalysis.approveNo = [[ABHXMLHelper getValuesWithTag:@"ONYNO" fromEnvelope:envelope] objectAtIndex:0];
        contractAnalysis.requestNo = [[ABHXMLHelper getValuesWithTag:@"TLPNO" fromEnvelope:envelope] objectAtIndex:0];
        contractAnalysis.analysisStartingDate = [[ABHXMLHelper getValuesWithTag:@"BASTR" fromEnvelope:envelope] objectAtIndex:0];
        contractAnalysis.analysisEndingDate = [[ABHXMLHelper getValuesWithTag:@"BITTR" fromEnvelope:envelope] objectAtIndex:0];
        contractAnalysis.contractStartingDate= [[ABHXMLHelper getValuesWithTag:@"ISBGD" fromEnvelope:envelope] objectAtIndex:0];
        contractAnalysis.contractEndingDate = [[ABHXMLHelper getValuesWithTag:@"ISEND" fromEnvelope:envelope] objectAtIndex:0];
    }
    @catch (NSException *exception) {
        NSLog(@"Tuttum valla bırakmam");
    }
    @finally {
        [tableView reloadData];
    }
    
}

- (void)initContractItemsInformation:(NSString *)envelope {

    @try {
        contractAnalysis.lastYearSystemSale =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LSYEFS" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TSYEFS" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.estimatedAnalysisSale =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LTHEFS" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TTHEFS" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.estimatedYearSale =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"YLTHEFS" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"YTTHEFS" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.enterpriseCapitalN =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LISKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TISKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.enterpriseCapitalM =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LISKTLM" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TISKTLM" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.cashBasedContract =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LNKTKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TNKTKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.cashBasedProduct =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LNKTMAL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TNKTMAL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.projectContractN =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LPKKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TPKKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.projectContractM =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LPKKTLM" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TPKKTLM" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.discountFromInvoice =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LFAKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TFAKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.periodicDiscount =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LDIKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TDIKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.enterpriseCredit =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LIKKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TIKKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.commercialContract =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LRKKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TRKKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.totalContract =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LTPKTL" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TTPKTL" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.grossIncome =
        [NSString stringWithFormat:@"%@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"NTGTR" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.brutIncome =
        [NSString stringWithFormat:@"%@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"BRGTR" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.pointToPoint =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LBSLTR" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TBSLTR" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.transferedCost =
        [NSString stringWithFormat:@"%@LT / %@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"LDVMLT" fromEnvelope:envelope] objectAtIndex:0]], [ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"TDVMLT" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.grossProceeds =
        [NSString stringWithFormat:@"%@TRY",[ABHXMLHelper correctNumberValue:[[ABHXMLHelper getValuesWithTag:@"BHSLT" fromEnvelope:envelope] objectAtIndex:0]]];
        
        contractAnalysis.grossPercentageWithOTV =
        [NSString stringWithFormat:@"%@TRY",[[ABHXMLHelper getValuesWithTag:@"ODCRP" fromEnvelope:envelope] objectAtIndex:0]];
        
        contractAnalysis.grossPercentageWithoutOTV =
        [NSString stringWithFormat:@"%@TRY",[[ABHXMLHelper getValuesWithTag:@"OHCRP" fromEnvelope:envelope] objectAtIndex:0]];
    }
    @catch (NSException *exception) {
        NSLog(@"Tuttum valla bırakmam");
    }
    @finally {
        [tableView reloadData];
    }
    
}

- (void)initDiscountListItems:(NSString *)envelope {
    
    @try {
        NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
        
        for (int i = 0; i < [itemCount count]; i++) {
            contractDiscount = [[CSContractAnalysisDiscount alloc] init];
            
            NSString *str    = [itemCount objectAtIndex:i];
            
            contractDiscount.idNum = [[ABHXMLHelper getValuesWithTag:@"IDNUM" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.contractType = [[ABHXMLHelper getValuesWithTag:@"KATUR" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.matnr = [[ABHXMLHelper getValuesWithTag:@"MATNR" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.transferDate = [[ABHXMLHelper getValuesWithTag:@"AKTAR" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.contractAmount = [[ABHXMLHelper getValuesWithTag:@"KTMIK" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.weightUnit = [[ABHXMLHelper getValuesWithTag:@"KOBRM" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.cashContractPrice = [[ABHXMLHelper getValuesWithTag:@"NKTUT" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.efesRate = [[ABHXMLHelper getValuesWithTag:@"EFSRT" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.otherRate = [[ABHXMLHelper getValuesWithTag:@"DGRRT" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.pricePerLitre = [[ABHXMLHelper getValuesWithTag:@"LBFYT" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.costPerLitre = [[ABHXMLHelper getValuesWithTag:@"LBMLY" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.manufacturerTax = [[ABHXMLHelper getValuesWithTag:@"USVFN" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.estimatedSale = [[ABHXMLHelper getValuesWithTag:@"THLTR" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.estimatedMontlySale = [[ABHXMLHelper getValuesWithTag:@"ATHLTR" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.isnas = [[ABHXMLHelper getValuesWithTag:@"ISNAS" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.pknas = [[ABHXMLHelper getValuesWithTag:@"PKNAS" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.iktas = [[ABHXMLHelper getValuesWithTag:@"IKTAS" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.isert = [[ABHXMLHelper getValuesWithTag:@"ISERT" fromEnvelope:str] objectAtIndex:0];
            contractDiscount.iserk = [[ABHXMLHelper getValuesWithTag:@"ISERK" fromEnvelope:str] objectAtIndex:0];
            
            [discountList addObject:contractDiscount];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"tuttum bırakmam");
    }
    @finally {
        [tableView reloadData];
    }
    
}

- (void)getResponseWithString:(NSString *)myResponse{
    [super stopAnimationOnView];
        
    NSString *errorMessage = [[ABHXMLHelper getValuesWithTag:@"MESSAGE" fromEnvelope:myResponse] objectAtIndex:0];
    UIAlertView *alert;
    
    if (!([errorMessage isEqualToString:@""])) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:errorMessage delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];
    }
    else {
        [self initContractHeaderInformation:[[ABHXMLHelper getValuesWithTag:@"E_HEAD" fromEnvelope:myResponse] objectAtIndex:0]];
        [self initContractItemsInformation:[[ABHXMLHelper getValuesWithTag:@"E_KOBEF" fromEnvelope:myResponse] objectAtIndex:0]];
        [self initDiscountListItems:[[ABHXMLHelper getValuesWithTag:@"ZSDKA_ISKONTO_ALL" fromEnvelope:myResponse] objectAtIndex:0]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Genel Bilgiler";
    else if (section == 1)
        return @"Countries visited";
    else if (section == 2)
        return @"Iskonto Bilgileri";
    
    return @"";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    
    if(section == 0)
        label.text = @"Genel Bilgiler";
    else if (section == 1)
        label.text = @"Kalem Verileri";
    else if (section == 2)
        label.text = @"Iskonto Bilgileri";
    
    label.textColor = [UIColor whiteColor];
    
    label.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 8;
            break;
        case 1:
            return 21;
        case 2:
            return 1;
            break;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    cell.detailTextLabel.textColor = [UIColor blackColor];
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (section == 0) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Müşteri Numarası";
                cell.detailTextLabel.text = contractAnalysis.kunnr;
                break;
            case 1:
                cell.textLabel.text = @"Müşteri Adı";
                cell.detailTextLabel.text = contractAnalysis.name;
                break;
            case 2:
                cell.textLabel.text = @"Analiz Numarası";
                cell.detailTextLabel.text = contractAnalysis.contractNo;
                break;
            case 3:
                cell.textLabel.text = @"Analiz Versiyon";
                cell.detailTextLabel.text = contractAnalysis.version;
                break;
            case 4:
                cell.textLabel.text = @"Onay Numarası";
                cell.detailTextLabel.text = contractAnalysis.approveNo;
                break;
            case 5:
                cell.textLabel.text = @"Talep Numarası";
                cell.detailTextLabel.text = contractAnalysis.requestNo;
                break;
            case 6:
                cell.textLabel.text = @"Analiz Tarihi";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@", contractAnalysis.analysisStartingDate, contractAnalysis.analysisEndingDate];
                break;
            case 7:
                cell.textLabel.text = @"Sözleşme Tarihi";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@", contractAnalysis.contractStartingDate, contractAnalysis.contractEndingDate];
            default:
                break;
        }
    }
    else if (section == 1)
    {
        cell.detailTextLabel.numberOfLines = 2;
        switch (row) {
            case 0:
                cell.textLabel.text = @"Son Yıl Satış";
                cell.detailTextLabel.text = contractAnalysis.lastYearSystemSale;
                break;
            case 1:
                cell.textLabel.text = @"Tahmini Satış";
                cell.detailTextLabel.text = contractAnalysis.estimatedAnalysisSale;
                break;
            case 2:
                cell.textLabel.text = @"Tahmini Yıllık Satış";
                cell.detailTextLabel.text = contractAnalysis.estimatedYearSale;
                break;
            case 3:
                cell.textLabel.text = @"İşletme Sermayesi";
                cell.detailTextLabel.text = contractAnalysis.enterpriseCapitalN;
                break;
            case 4:
                cell.textLabel.text = @"İşletme Sermayesi Mal";
                cell.detailTextLabel.text = contractAnalysis.enterpriseCapitalM;
                break;
            case 5:
                cell.textLabel.text = @"Nakit Bazlı Katılım";
                cell.detailTextLabel.text = contractAnalysis.cashBasedContract;
                break;
            case 6:
                cell.textLabel.text = @"Nakit Bazı Mal";
                cell.detailTextLabel.text = contractAnalysis.cashBasedProduct;
                break;
            case 7:
                cell.textLabel.text = @"Proje Katılımı";
                cell.detailTextLabel.text = contractAnalysis.projectContractN;
                break;
            case 8:
                cell.textLabel.text = @"Proje Katılımı Mal";
                cell.detailTextLabel.text = contractAnalysis.projectContractM;
                break;
            case 9:
                cell.textLabel.text = @"Fatura Altı Iskonto";
                cell.detailTextLabel.text = contractAnalysis.discountFromInvoice;
                break;
            case 10:
                cell.textLabel.text = @"Dönemsel Iskonto";
                cell.detailTextLabel.text = contractAnalysis.periodicDiscount;
                break;
            case 11:
                cell.textLabel.text = @"İşletme Kredisi";
                cell.detailTextLabel.text = contractAnalysis.enterpriseCredit;
                break;
            case 12:
                cell.textLabel.text = @"Reklam Katılımı";
                cell.detailTextLabel.text = contractAnalysis.commercialContract;
                break;
            case 13:
                cell.textLabel.text = @"Toplam Katılım";
                cell.detailTextLabel.text = contractAnalysis.totalContract;
                break;
            case 14:
                cell.textLabel.text = @"Net Gelir";
                cell.detailTextLabel.text = contractAnalysis.grossIncome;
                break;
            case 15:
                cell.textLabel.text = @"Brüt Gelir";
                cell.detailTextLabel.text = contractAnalysis.brutIncome;
                break;
            case 16:
                cell.textLabel.text = @"Başabaş Noktası";
                cell.detailTextLabel.text = contractAnalysis.pointToPoint;
                break;
            case 17:
                cell.textLabel.text = @"Devreden Maliyetler";
                cell.detailTextLabel.text = contractAnalysis.pointToPoint;
                break;
            case 18:
                cell.textLabel.text = @"Brüt Hasılat";
                cell.detailTextLabel.text = contractAnalysis.grossProceeds;
                break;
            case 19:
                cell.textLabel.text = @"Ciro Payı(ÖTV Dahil)";
                cell.detailTextLabel.text = contractAnalysis.grossPercentageWithOTV;
                break;
            case 20:
                cell.textLabel.text = @"Ciro Payı(ÖTV Haric)";
                cell.detailTextLabel.text = contractAnalysis.grossPercentageWithoutOTV;
                break;
            default:
                break;
        }
    }
    else if (section == 2)
    {
        cell.textLabel.text = @"Iskonto Bilgisi";
        @try {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i Adet",[discountList count]];
        }
        @catch (NSException *exception) {
            cell.detailTextLabel.text = @"0 Adet";
        }
        @finally {
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            contractDiscountViewController = [[CSContractAnalysisDiscountViewController alloc] initWithDiscountList:discountList];
            [self.navigationController pushViewController:contractDiscountViewController animated:YES];
        }
    }
}


@end
