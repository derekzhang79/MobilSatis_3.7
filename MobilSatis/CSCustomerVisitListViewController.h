//
//  CSCustomerVisitListViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 28.09.2012.
//
//

#import "CSBaseViewController.h"
#import "CSCustomer.h"

@interface CSCustomerVisitListViewController : CSBaseViewController <UITableViewDataSource, UITableViewDelegate, ABHSAPHandlerDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *visitList;
@property (nonatomic, retain) CSCustomer *customer;

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer *)selectedCustomer;

@end
