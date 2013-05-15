//
//  CSUserSaleDataViewController.m
//  MobilSatis
//
//  Created by Alp Keser on 6/13/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import "CSUserSaleDataViewController.h"

@interface CSUserSaleDataViewController ()

@end

@implementation CSUserSaleDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andUserSaleData:(CSUserSaleData*)anUserSaleData andTitle:(NSString *)aTitle andBeginDate:(NSString *)aBegin andEndDate:(NSString *)aEnd {
    self = [self initWithUser:myUser];
    userSaleData = anUserSaleData;
    title = aTitle;
    beginDate = aBegin;
    endDate = aEnd;
    
    return self;
}

#pragma mark - Table Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        return 120;
    else
        return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else {
        [[cell detailTextLabel] setText:@""];
        [cell setAccessoryView:nil];
    }
    int sayac = 0;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    CSUserSaleData *tempSaleData;
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
    
    //[cell setTextColor:[CSApplicationProperties getUsualTextColor]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:24]];
    }

    
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Gerçekleşen Geçmiş";
        cell.detailTextLabel.text = [userSaleData actualHistory];
       
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Fiili";
        cell.detailTextLabel.text = [userSaleData actualCurrent];
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Bütçe";
        cell.detailTextLabel.text = [userSaleData budget];
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Gelişme";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[userSaleData development]];
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Gerçekleşme Oranı";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[userSaleData currentRate]];
        [[cell textLabel] setTextColor:[UIColor redColor]];
        [[cell detailTextLabel] setTextColor:[UIColor redColor]];
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Kalan Litre";
        cell.detailTextLabel.text = [userSaleData leftAmount];
        cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }

    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    
    @try {
        return userSaleData.label;
    }
    @catch (NSException *exception) {
        NSLog(@"table viewda neler oluyor?");
        return @"My Title";
    }
    @finally {
        
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)itemBasedSalesGraph {

    CSItemSaleDataViewController *itemSale = [[CSItemSaleDataViewController alloc] initWithUser:[self user] andUserSaleData:userSaleData andTitle:title beginDate:beginDate endDate:endDate];
    [[self navigationController] pushViewController:itemSale animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    table.backgroundColor = [UIColor clearColor];
    table.opaque = NO;
    table.backgroundView = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        [[self navigationItem] setTitle:title];
    
    if ([[userSaleData categroy] isEqualToString:@"Markalar"]) {
        UIBarButtonItem *graphButton = [[UIBarButtonItem alloc] initWithTitle:@"Grafik" style:UIBarButtonItemStyleBordered target:self action:@selector(itemBasedSalesGraph)];
        [[self navigationItem] setRightBarButtonItem:graphButton];

    }
    //[myTableView reloadData];
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
