//
//  CSTowerAndSpotSelectionViewController.m
//  CrmServis
//
//  Created by ABH on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSTowerAndSpoutSelectionViewController.h"

@implementation CSTowerAndSpoutSelectionViewController
@synthesize coolerViewController;
@synthesize selectedCooler;
@synthesize selectedTowerIndex, selectedSpoutIndex, towerAmount, spoutAmount;
@synthesize customer;
@synthesize towers;
@synthesize spouts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self = [super self];
    towers = [CSTowerAndSpoutList getTowers];
    spouts = [CSTowerAndSpoutList getSpouts];
    
    
    return self;
}
-(id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)myCustomer andSelectedCooler:(CSCooler *)myCooler{
    self = [self init];
    [self setUser:myUser];
    customer = myCustomer;
    selectedCooler = myCooler;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Custom code
-(IBAction)sendInstallationToSap{
    
    coolerViewController = [[CSCoolerCreationViewController alloc] init];
    
    coolerViewController.towerViewController = [[CSTowerAndSpoutSelectionViewController alloc] init];
    coolerViewController.towerViewController = self;
    
    [self.navigationController  pushViewController:coolerViewController animated:YES];
    
}

#pragma mark - Delegate methods
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
            
            return 650;
        } 
        
        else{
            return 260;
        }
        
    }else{
        return 50;    
    }
    
}
//PickerViewController.m
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;
}

//PickerViewController.m
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        if (thePickerView == towerPicker) {
            return towers.count;
        }else{
            return spouts.count;
        }
    }
    return 10;
}
//PickerViewController.m
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CSTower *tempTower;
    if (thePickerView == towerPicker) {
        if (component == 0) {
            tempTower = [towers objectAtIndex:row];
            return [NSString stringWithFormat:@"%@",tempTower.desription];
        }
        else{
            return [NSString stringWithFormat:@"%i",row+1];
        }
    }
    if (thePickerView == spoutPicker) {
        CSSpout *tempSpout;
        if (component == 0) {
            tempSpout = [spouts objectAtIndex:row];
            return [NSString stringWithFormat:@"%@",tempSpout.desription];
        }
        else{
          //  return [NSString stringWithFormat:@"%@",row];
            return [NSString stringWithFormat:@"%i",row+1];
        }
    }
    return  @"alp";
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
 //   NSLog(@"Selected Color: %@. Index of selected color: %i", thePickerView, row);
    if (thePickerView == towerPicker) {
        if (component == 0) {
            selectedTowerIndex = row;
        }
        if (component == 1) {
            towerAmount = row + 1;
        }
    }
    
    if (thePickerView == spoutPicker) {
        if (component == 0) {
            selectedSpoutIndex = row;
        }
        if (component == 1) {
            spoutAmount = row + 1;
        }
    }
    
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //pickerView.showsSelectionIndicator = NO;
    // Do any additional setup after loading the view from its nib.
    towerPicker = [[UIPickerView alloc] init];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
      towerPicker.frame = 	CGRectMake(0, 100, 800, 180);   
    } 
    else{
       towerPicker.frame = 	CGRectMake(0, 0, 320, 180);
    }
    [towerPicker setDelegate:self];
    [towerPicker setDataSource:self];
    [towerPicker setShowsSelectionIndicator:YES];
//    [towerPicker setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
    [[self view] addSubview:towerPicker];
    
    spoutPicker = [[UIPickerView alloc] init];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        spoutPicker.frame = 	CGRectMake(0, 400, 800, 180);   
    } 
    else{
        spoutPicker.frame = 	CGRectMake(0, 200, 320, 180);
    }
    [spoutPicker setDelegate:self];
    [spoutPicker setDataSource:self];
    [spoutPicker setShowsSelectionIndicator:YES];
    [[self view] addSubview:spoutPicker];
    towerAmount = 1;
    spoutAmount = 1;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yarat" style:UIBarButtonItemStyleBordered target:self action:@selector(sendInstallationToSap)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
    [[self navigationItem] setTitle:@"Musluk-Kule"];
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
