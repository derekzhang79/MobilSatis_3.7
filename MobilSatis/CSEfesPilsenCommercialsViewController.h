//
//  CSEfesPilsenCommercialsViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 17.02.2013.
//
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CSUser.h"
#import "CSCommercialWebViewController.h"

@interface CSEfesPilsenCommercialsViewController : CSBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MPMoviePlayerController *streamPlayer;

@end
