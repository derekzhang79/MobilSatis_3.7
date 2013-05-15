//
//  InfoViewController.m
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSInfoViewController.h"

@implementation CSInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [mail setDataDetectorTypes:UIDataDetectorTypeLink];
    [phone setDataDetectorTypes:UIDataDetectorTypePhoneNumber];
//    [mail setBackgroundColor:[UIColor blueColor] ];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yenile" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshConfirmations)];
    // [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
    [[self navigationItem] setTitle:@"Hakkında"];
    //[myTableView reloadData];
    [coreDataSwitch setOn:[CoreDataHandler isCoreDataSwitchOn]];
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


- (IBAction)reportProblem:(id)sender {
    CSReportProblemViewController *report = [[CSReportProblemViewController alloc] initWithUser:user];
    [[self navigationController] pushViewController:report animated:YES];
}

- (IBAction)coreDataSwitchChanged:(id)sender {
    [CoreDataHandler saveCoreDataSwitchState:[coreDataSwitch isOn]];
}

@end
