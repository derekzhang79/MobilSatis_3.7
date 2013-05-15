//
//  CSSharePointSafariViewController.h
//  MobilSatis
//
//  Created by alp keser on 10/8/12.
//
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"

@interface CSSharePointSafariViewController : CSBaseViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
}

@end
