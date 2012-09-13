//
//  CSContractAnalysisDiscountViewController.h
//  MobilSatis
//
//  Created by Ata Cengiz on 9/6/12.
//
//

#import "CSBaseViewController.h"

@interface CSContractAnalysisDiscountViewController : CSBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *discountList;

- (id)initWithDiscountList:(NSMutableArray *)arrayList;

@end
