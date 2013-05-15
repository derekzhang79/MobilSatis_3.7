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
#import "CSCustomer.h"
@interface CSContractAnalysisViewController : CSBaseViewController <UITableViewDataSource, UITableViewDelegate, ABHSAPHandlerDelegate, UIAlertViewDelegate>
{
    UITableView *tableView;
    CSContractAnalysis *contractAnalysis;
    CSCustomer *customer;
    CSContractAnalysisDiscount *contractDiscount;
    CSContractAnalysisDiscountViewController *contractDiscountViewController;
    NSMutableArray *discountList;
    NSMutableArray *transferList;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) CSContractAnalysis *contractAnalysis;

@property (nonatomic, retain) CSContractAnalysisDiscount *contractDiscount;
@property (nonatomic, retain) NSMutableArray *discountList;
@property (nonatomic, retain) NSMutableArray *transferList;
@property (nonatomic, retain) CSContractAnalysisDiscountViewController *contractDiscountViewController;

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer *)selectedCustomer;

@end
