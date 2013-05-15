//
//  CSUserSalesDetailsViewController.h
//  MobilSatis
//
//  Created by Alp Keser on 6/8/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSUserSaleData.h"
#import "CSUserSaleDataViewController.h"
@interface CSUserSalesDetailsViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *dataArray;
    NSString *title;
    NSString *beginDate;
    NSString *endDate;

}

- (id)initWithUser:(CSUser *)myUser andArray:(NSMutableArray*)array andTitle:(NSString*)atitle beginDate:(NSString*)aBegin endDate:(NSString *)aEnd;
@end
