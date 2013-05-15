//
//  CSCommercialWebViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 17.02.2013.
//
//

#import "CSBaseViewController.h"

@interface CSCommercialWebViewController : CSBaseViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *urlString;

- (id)initWithUrl:(NSString *)myUrlString;

@end
