//
//  CSConnectWithOtherMYKViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 24.04.2013.
//
//

#import "CSBaseViewController.h"
#import "CSOtherMYK.h"

@interface CSConnectWithOtherMYKViewController : CSBaseViewController <ABHSAPHandlerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *otherMYKList;
@property (nonatomic, retain) NSMutableArray *otherMYKTableList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *lastMYKList;
@property (nonatomic, retain) CSOtherMYK *lastMYK;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSString *searchTerm;

- (id)initWithUser:(CSUser *)myUser;
@end
