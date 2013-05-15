//
//  CSFinancialReportDistributorViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 10.05.2013.
//
//

#import "CSFinancialReportDistributorViewController.h"

@interface CSFinancialReportDistributorViewController ()

@end

@implementation CSFinancialReportDistributorViewController
@synthesize distributorFinancialReport;

- (id)initWithStyle:(UITableViewStyle)style andDistributorReport:(CSFinancialReport *)report
{
    self = [super initWithStyle:style];
    
    if (self) {
        distributorFinancialReport = [[CSFinancialReport alloc] initWithArray];
        distributorFinancialReport = report;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-01.png"]];
    [[self navigationItem] setTitle:distributorFinancialReport.musteriAdi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    cell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
        switch (row) {
            case 0:
                cell.textLabel.text = @"ABank Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.abankTutar;
                break;
            case 1:
                cell.textLabel.text = @"Açık Sipariş Litre";
                cell.detailTextLabel.text = distributorFinancialReport.acikSiparisLitre;
                break;
            case 2:
                cell.textLabel.text = @"Açık Kalan Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.acikKalanTutar;
                break;
            case 3:
                cell.textLabel.text = @"Açık Sipariş Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.acikSiparisTutar;
                break;
            case 4:
                cell.textLabel.text = @"Kredi Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.akKrediTutar;
                break;
            case 5:
                cell.textLabel.text = @"Ek Kredi Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.ekKrediTutar;
                break;
            case 6:
                cell.textLabel.text = @"Ek Limit Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.abankTutar;
                break;
            case 7:
                cell.textLabel.text = @"Teminat Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.eTeminatTutar;
                break;
            case 8:
                cell.textLabel.text = @"Kanun Tak Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.kanunTakTutar;
                break;
            case 9:
                cell.textLabel.text = @"Kullanılan Toplam Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.kulToplamTutar;
                break;
            case 10:
                cell.textLabel.text = @"Mal Limit Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.malLimitTutar;
                break;
            case 11:
                cell.textLabel.text = @"Sipariş Toplam Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.sipToplamTutar;
                break;
            case 12:
                cell.textLabel.text = @"Toplam Borç Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.toplamBorcTutar;
                break;
            case 13:
                cell.textLabel.text = @"Toplam Efes Borç Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.toplamEfesBorcTutar;
                break;
            case 14:
                cell.textLabel.text = @"Toplam Teminat Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.toplamTeminatTutar;
                break;
            case 15:
                cell.textLabel.text = @"Toplam Kredi Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.abankTutar;
                break;
            case 16:
                cell.textLabel.text = @"Toplam Risk Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.abankTutar;
                break;
            case 17:
                cell.textLabel.text = @"vgc Cek Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vgcCekTutar;
                break;
            case 18:
                cell.textLabel.text = @"vgc Senet Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vgcSenetTutar;
                break;
            case 19:
                cell.textLabel.text = @"vgc Talimat Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vgcTalimatTutar;
                break;
            case 20:
                cell.textLabel.text = @"vgc Toplam Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vgcToplamTutar;
                break;
            case 21:
                cell.textLabel.text = @"vgl cek Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vglCekTutar;
                break;
            case 22:
                cell.textLabel.text = @"vgl Senet Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vglSenetTutar;
                break;
            case 23:
                cell.textLabel.text = @"vgl Talimat Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vglTalimatTutar;
                break;
            case 24:
                cell.textLabel.text = @"vgl Toplam Tutar?";
                cell.detailTextLabel.text = distributorFinancialReport.vglToplamTutar;
                break;
            case 25:
                cell.textLabel.text = @"Yeni Sipariş Toplam Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.yeniSiparisToplamTutar;
                break;
            default:
                break;
        }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

@end
