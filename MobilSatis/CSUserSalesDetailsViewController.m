//
//  CSUserSalesDetailsViewController.m
//  MobilSatis
//
//  Created by Alp Keser on 6/8/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import "CSUserSalesDetailsViewController.h"

@interface CSUserSalesDetailsViewController ()

@end

@implementation CSUserSalesDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andArray:(NSMutableArray*)array andTitle:(NSString*)atitle beginDate:(NSString*)aBegin endDate:(NSString *)aEnd {
    self = [self initWithUser:myUser];
    dataArray = array;
    title = atitle;
    beginDate = [NSString stringWithFormat:@"%@", aBegin];
    endDate = [NSString stringWithFormat:@"%@", aEnd];
    
    return self;
}

#pragma mark - Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
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
   
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    CSUserSaleData *tempSaleData;
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    tempSaleData = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tempSaleData.label;
    

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[tempSaleData currentRate]];
    
    if(cell.detailTextLabel.text == nil)
        [cell.detailTextLabel setText:@"0"];
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
    
    
    //[cell setTextColor:[CSApplicationProperties getUsualTextColor]];
    cell.textLabel.textColor = [UIColor whiteColor];

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    
    @try {
        return @"Gerçekleşen Oranlarım";
    }
    @catch (NSException *exception) {
        NSLog(@"table viewda neler oluyor?");
        return @"My Title";
    }
    @finally {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSUserSaleDataViewController *userSaleDataViewController = [[CSUserSaleDataViewController alloc] initWithUser:user andUserSaleData:[dataArray objectAtIndex:indexPath.row] andTitle:title andBeginDate:beginDate andEndDate:endDate];
    [[self navigationController] pushViewController:userSaleDataViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    table.backgroundColor = [UIColor clearColor];
    table.opaque = YES;
    table.backgroundView = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yenile" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshConfirmations)];
    // [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
    [[self navigationItem] setTitle:title];
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
