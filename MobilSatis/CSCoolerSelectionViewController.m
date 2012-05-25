//
//  CSCoolerSelectionViewController.m
//  CrmServisPrototype
//
//  Created by ABH on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSCoolerSelectionViewController.h"
#import "CSFailureDetailViewController.h"
@implementation CSCoolerSelectionViewController
@synthesize customer;

- (id)init{
    self = [super init];
    customer = [[CSCustomer alloc] init];
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCustomer:(CSCustomer*)aCustomer andUser:(CSUser*)myUser andProcess:(NSString*)process{
    self = [self init];
    customer = aCustomer;
    selectedProcess = [NSString stringWithFormat:process];
    user = myUser;
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [customer.coolers count];
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCooler *tempCooler = [customer.coolers objectAtIndex:indexPath.row];
    
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

 [[cell textLabel] setText:tempCooler.description];
    [[cell detailTextLabel] setText:tempCooler.sernr];
    [cell setTextColor:[CSApplicationProperties getUsualTextColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CSCooler *tempCooler = [customer.coolers objectAtIndex:indexPath.row];
    if ([selectedProcess isEqualToString:@"takeAway"]) {
        //sök kes kopar
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sökme İşlemi" 
                                                        message:[NSString stringWithFormat:@"%@ efes barkodlu soğutucunun sökülmesini onaylıyor musunuz?",tempCooler.sernr]
                                                       delegate:self 
                              
                                              cancelButtonTitle:@"İptal" 
                                              otherButtonTitles:@"Onayla", nil];
        [alert show];
    }else{
        CSFailureDetailViewController *failureDetailViewController = [[CSFailureDetailViewController alloc] initWithCooler:tempCooler andCustomer:customer andUser:user];
        [[self navigationController]pushViewController:failureDetailViewController animated:YES];
        
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //onayla
    }
}









- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationItem] setTitle:@"Soğutucular"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    [tableView setSeparatorColor:[UIColor colorWithRed:0.255f green:0.246f blue:0.176f alpha:1]];
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
