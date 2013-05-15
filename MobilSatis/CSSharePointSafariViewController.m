//
//  CSSharePointSafariViewController.m
//  MobilSatis
//
//  Created by alp keser on 10/8/12.
//
//

#import "CSSharePointSafariViewController.h"

@interface CSSharePointSafariViewController ()

@end

@implementation CSSharePointSafariViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopAnimationOnView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *urlAddress;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
       urlAddress = @"http://ma.efesintranet.com";
    }
    else{
        urlAddress = @"http://ma.efesintranet.com";
    }
//    @"http://ma.efesintranet.com";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [super playAnimationOnView:self.view ];
    [webView loadRequest:requestObj];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationItem] setTitle:@"Satış Analiz Onayları"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
