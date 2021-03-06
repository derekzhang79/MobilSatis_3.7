//
//  CSCustomerListViewController.m
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSCustomerListViewController.h"
#import "CSProcessSelectionViewController.h"
@implementation CSCustomerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCustomers:(NSMutableArray*)myCustomers andUser:(CSUser*)myUser{
    self=   [self init];
    user = [[CSUser alloc] init];
    user = myUser;
    customers = [[NSMutableArray alloc] init];
    customers = myCustomers;
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [filteredListContent count];
    else
        return [customers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //create row
    
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        CSCustomer *tempCustomer = [filteredListContent objectAtIndex:indexPath.row];
        cell.textLabel.text = [tempCustomer name1];
        cell.detailTextLabel.text = [tempCustomer kunnr];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
        
        cell.imageView.image = [UIImage imageNamed:[self getPngOfCustomer:tempCustomer]];
        //[cell setTextColor:[CSApplicationProperties getUsualTextColor]];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
        
    }
    else {
        CSCustomer *tempCustomer = [customers objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[tempCustomer name1]];
        [[cell detailTextLabel] setText:[tempCustomer kunnr]];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
        
        cell.imageView.image = [UIImage imageNamed:[self getPngOfCustomer:tempCustomer]];
        //[cell setTextColor:[CSApplicationProperties getUsualTextColor]];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
    
}

- (NSString *)getPngOfCustomer:(CSCustomer *)cust {
    if ([cust.type isEqualToString:@"acik"]) {
        return @"appiconlar-02.png";
    }
    else if([cust.type isEqualToString:@"kapali"])
    {
        return @"app iconlar-11.png";
    }
    else if([cust.type isEqualToString:@"bira"])
    {
        return @"iconBira.png";
    }
    else if([cust.type isEqualToString:@"dealer"])
    {
        return @"appiconlar-01.png";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSProcessSelectionViewController *processSelectionViewController;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        processSelectionViewController = [[CSProcessSelectionViewController alloc] initWithCustomer:[filteredListContent objectAtIndex:indexPath.row] andUser:user];
    }
    else {
        processSelectionViewController = [[CSProcessSelectionViewController alloc] initWithCustomer:[customers objectAtIndex:indexPath.row] andUser:user];
    }
    
    [[self navigationController] pushViewController:processSelectionViewController animated:YES];
    
}

- (BOOL)isDealer:(CSCustomer*)aCustomer{
    if (aCustomer.dealer == nil) {
        return YES;
    }else{
        return NO;
    }
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Search Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
        
//        sale = [[SaleOrderCreationViewController alloc]initWithNibName:@"SaleOrderCreationViewController" bundle:[NSBundle mainBundle]];
//        
//        [self.navigationController pushViewController:sale animated:YES];
	}
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{    
    [self->filteredListContent removeAllObjects]; // First clear the filtered array.
    
    for (int i = 0; i < [customers count]; i++) {
        CSCustomer *tempCustomer = [customers objectAtIndex:i];
        NSString *string = tempCustomer.name1;
        
        NSComparisonResult result = [string compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame)
        {
            [self->filteredListContent addObject:[customers objectAtIndex:i]];
        }
    }
    
    
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
    
    //[controller.searchResultsTableView setDelegate:self];
    
    UIImageView *anImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background-01.png"]];
    controller.searchResultsTableView.backgroundView = anImage;
    
    //controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    controller.searchResultsTableView.backgroundColor = [UIColor clearColor]; 
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setTitle:@"Müşteri Seçimi"];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    [tableView setSeparatorColor:[UIColor colorWithRed:0.255f green:0.246f blue:0.176f alpha:1]];
    filteredListContent = [[NSMutableArray alloc]init];
    ///test
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self->savedSearchTerm)
    {
        [self.searchDisplayController setActive:YES];
       
     
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
