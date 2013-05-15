//
//  CSCommercialWebViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 17.02.2013.
//
//

#import "CSCommercialWebViewController.h"

@interface CSCommercialWebViewController ()

@end

@implementation CSCommercialWebViewController
@synthesize urlString;
@synthesize webView;

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
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlString];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUrl:(NSString *)myUrlString {
    self = [super init];
    urlString = myUrlString;
    
    return self;
}

@end
