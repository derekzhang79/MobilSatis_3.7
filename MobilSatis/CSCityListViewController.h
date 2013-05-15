//
//  CSCityListViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 31.10.2012.
//
//

#import "CSBaseViewController.h"
#import "CSCustomerDetail.h"

@interface CSCityListViewController : CSBaseViewController <UITableViewDataSource, UITableViewDelegate, ABHSAPHandlerDelegate >
{
    NSMutableArray *cityList;
    UITableView *tableView;
    NSString *cityCode;
    NSString *countyCode;
    CSCustomerDetail *custDetail;
}

@property (nonatomic, retain) NSMutableArray *cityList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *cityCode;
@property (nonatomic, retain) NSString *countyCode;
@property (nonatomic, retain) NSString *district;
@property (nonatomic, retain) NSString *disctrictCode;
@property (nonatomic, retain) CSCustomerDetail *custDetail;


- (void)getCityListFromSAP;
- (void)initCityListFromEnvelope:(NSString *)response;
- (id)initWithInformation:(NSString *)city :(NSString *)county : (CSCustomerDetail *)customerDetail;

@end
