//
//  CSCancelationInfoViewController.m
//  MobilSatis
//
//  Created by Ata Cengiz on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSCancelationInfoViewController.h"

@interface CSCancelationInfoViewController ()

@end

@implementation CSCancelationInfoViewController
@synthesize customerViewController;
@synthesize table;

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
    table.backgroundColor = [UIColor clearColor];
    table.opaque = YES;
    table.backgroundView = nil;

}

- (void) viewWillAppear:(BOOL)animated {
    [[self  navigationItem] setTitle:@"Iptal Nedeni"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [customerViewController.cityList.cancelList count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    int row = [indexPath row];
    
    cell.textLabel.text = [[customerViewController.cityList.cancelList objectAtIndex:row] objectAtIndex:1];
    
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];
    
    customerViewController.cancelPurpose = [[customerViewController.cityList.cancelList objectAtIndex:row] objectAtIndex:0];
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
