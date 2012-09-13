//
//  CSContractAnalysisViewController.h
//  MobilSatis
//
//  Created by Ata Cengiz on 9/3/12.
//
//

#import "CSBaseViewController.h"
#import "CSContractAnalysis.h"
#import "CSContractAnalysisDiscount.h"
#import "CSContractAnalysisDiscountViewController.h"

@interface CSContractAnalysisViewController : CSBaseViewController <UITableViewDataSource, UITableViewDelegate, ABHSAPHandlerDelegate, UIAlertViewDelegate>
{
    UITableView *tableView;
    CSContractAnalysis *contractAnalysis;
    
    CSContractAnalysisDiscount *contractDiscount;
    CSContractAnalysisDiscountViewController *contractDiscountViewController;
    NSMutableArray *discountList;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) CSContractAnalysis *contractAnalysis;

@property (nonatomic, retain) CSContractAnalysisDiscount *contractDiscount;
@property (nonatomic, retain) NSMutableArray *discountList;
@property (nonatomic, retain) CSContractAnalysisDiscountViewController *contractDiscountViewController;

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(NSString *)selectedCustomer;

@end
