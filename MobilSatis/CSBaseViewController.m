//
//  CSBaseViewController.m
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSBaseViewController.h"

@implementation CSBaseViewController
@synthesize user;


- (id)init{
    self = [super init];
    isAnimationRunning = NO;
    return self;
}

-(id)initWithUser:(CSUser*)myUser{
    self = [self init];
    user = [[CSUser alloc] init];
    user = myUser;
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

//custom code alp
- (void)playAnimationOnView:(UIView*)myView{
    isAnimationRunning = YES;
    animationView = 
    [[UIImageView alloc] initWithFrame:CGRectMake(130, 170, 60, 60	)];
    animationView.animationImages = [NSArray arrayWithObjects:    
//                                   [UIImage imageNamed:@"anm1.png"],
//                                   [UIImage imageNamed:@"anm2.png"],
//                                   [UIImage imageNamed:@"anm3.png"],
//                                   [UIImage imageNamed:@"anm4.gif"],
//                                     [UIImage imageNamed:@"anm5.png"],
//                                     [UIImage imageNamed:@"anm6.png"],
//                                     [UIImage imageNamed:@"anm7.png"],
//                                     [UIImage imageNamed:@"anm8.png"],
//                                     [UIImage imageNamed:@"Untitled-3.gif"],
                                     [UIImage imageNamed:@"1.png"],
                                     [UIImage imageNamed:@"2.png"],
                                     [UIImage imageNamed:@"3.png"],
                                     [UIImage imageNamed:@"4.png"],
                                     [UIImage imageNamed:@"5.png"],
                                     [UIImage imageNamed:@"6.png"],
                                     [UIImage imageNamed:@"7.png"],
                                     [UIImage imageNamed:@"8.png"],
                                   nil];
    [myView addSubview:animationView];
    // all frames will execute in 1.75 seconds
    animationView.animationDuration = 0.8;
    // repeat the annimation forever
    animationView.animationRepeatCount = 0;
    // start animating
    [animationView startAnimating];
}
- (void)stopAnimationOnView{
    //[ removeFromSuperview];
    isAnimationRunning = NO;
    [animationView stopAnimating];
    [animationView removeFromSuperview];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)isFieldEmpty:(UITextField*)field{
    if ([field.text length] == 0) {
        return YES;
    }else{
    return  NO;
    }
}

- (BOOL)isNumber:(UITextField *)field{
//    NSScanner *scanner = [[NSScanner alloc] init];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    if([numberFormatter numberFromString:field.text]== nil){
        return NO;
    }
    return YES;
                                      
}

- (BOOL)isAnimationRunning{
    return isAnimationRunning;
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
    //[activityIndicator setHidesWhenStopped:YES];
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
