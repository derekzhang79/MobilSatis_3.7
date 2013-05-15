//
//  CSCancelationInfoViewController.h
//  MobilSatis
//
//  Created by Ata Cengiz on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSCustomerDetailViewController.h"

@class CSCustomerDetailViewController;
@interface CSCancelationInfoViewController : CSBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    CSCustomerDetailViewController *customerViewController;
    UITableView *table;
}
@property (nonatomic, retain) CSCustomerDetailViewController *customerViewController;
@property (nonatomic, retain) IBOutlet UITableView *table;
@end
