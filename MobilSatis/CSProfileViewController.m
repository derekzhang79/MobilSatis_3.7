//
//  CSProfileViewController.m
//  MobilSatis
//
//  Created by ABH on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSProfileViewController.h"

@interface CSProfileViewController ()

@end

@implementation CSProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)viewConfirmations:(id)sender{
    CSConfirmationListViewController *confirmationListViewController = [[CSConfirmationListViewController alloc] initWithUser:user];
    [[[self tabBarController] navigationController] pushViewController:confirmationListViewController animated:YES];
}
- (IBAction)viewSales:(id)sender{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
