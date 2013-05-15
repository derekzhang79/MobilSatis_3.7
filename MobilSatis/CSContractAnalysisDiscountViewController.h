//
//  CSContractAnalysisDiscountViewController.h
//  MobilSatis
//
//  Created by Ata Cengiz on 9/6/12.
//
//

#import "CSBaseViewController.h"
#import "CSContractAnalysisDiscount.h"

@interface CSContractAnalysisDiscountViewController : CSBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *discountList;
@property (nonatomic, retain) CSContractAnalysisDiscount *temp;

- (id)initWithDiscountList:(NSMutableArray *)arrayList;
- (NSString *)findContractAnalysisType: (NSString*)katur;

@end
