//
//  CSEfesPilsenCommercialsViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 17.02.2013.
//
//

#import "CSEfesPilsenCommercialsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CSEfesPilsenCommercialsViewController ()

@end

@implementation CSEfesPilsenCommercialsViewController
@synthesize tableView;
@synthesize streamPlayer;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCommercialWebView:(NSString *)aUrlString {
    
    CSCommercialWebViewController *commercialWebViewController = [[CSCommercialWebViewController alloc] initWithUrl:aUrlString];
    [[self navigationController] pushViewController:commercialWebViewController animated:YES];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    switch (section) {
        case 0:
            return @"Manifesto";
            break;
        case 1:
            return @"Duvel Reklamları";
            break;
        default:
            return @"";
            break;
    }
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    headerView.layer.cornerRadius = 5;
    headerView.layer.masksToBounds = YES;
    if (section == 0){
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:headerView.frame];
        [tempLabel setText:@"Manifesto"];
        [tempLabel setTextColor:[UIColor whiteColor]];
        [tempLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:tempLabel];
    }
    else if (section == 1)
    {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:headerView.frame];
        [tempLabel setText:@"Duvel Reklamları"];
        [tempLabel setTextColor:[UIColor whiteColor]];
        [tempLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:tempLabel];
    }
    else
        [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        default:
            return 1;
            break;
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
        cell.textLabel.text = @"Efes Pilsen Manifesto";
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    else {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Duvel'in Tarihi";
                cell.selectionStyle = UITableViewCellAccessoryNone;                
                break;
            case 1:
                cell.textLabel.text = @"Duvel'in Üretimi";
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            case 2:
                cell.textLabel.text = @"Duvel Reklam";
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = [indexPath section];
    int row = [indexPath row];
    NSString *urlString;
    
    if (section == 0) {
        urlString = @"http://youtu.be/_dtKbKhm8M4";
    }
    else if (section == 1)
    {
        switch (row) {
            case 0:
                urlString = @"http://youtu.be/ZZ5rSK1jcCs";
                break;
            case 1:
                urlString = @"http://youtu.be/dBdKVGpViIc";
                break;
            case 2:
                urlString = @"http://youtu.be/d3F5OJd5hv8";
                break;
            default:
                break;
        }
    }
    
    [self showCommercialWebView:urlString];
    
}


@end
