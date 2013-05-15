//
//  CSUserSaleDataViewController.h
//  MobilSatis
//
//  Created by Alp Keser on 6/13/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSUserSaleData.h"
#import "CSItemSaleDataViewController.h"

@interface CSUserSaleDataViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *table;
    CSUserSaleData *userSaleData;
    NSString *title;
    NSString *beginDate;
    NSString *endDate;
    }

- (id)initWithUser:(CSUser *)myUser andUserSaleData:(CSUserSaleData*)anUserSaleData andTitle:(NSString*)aTitle andBeginDate:(NSString*)aBegin andEndDate:(NSString*)aEnd;

@end
