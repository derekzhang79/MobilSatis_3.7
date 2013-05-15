//
//  customNavigationController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 22.11.2012.
//
//

#import "customNavigationController.h"

@interface customNavigationController ()

@end

@implementation customNavigationController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        BOOL  checker = [CoreDataHandler isViewSupportsOffline:[[viewController class] description]];
        
        if (checker)
        {
            [super pushViewController:viewController animated:animated];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Cihazınızın internet bağlantısı kesildiği için işlemi gerçekleştiremiyoruz" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
