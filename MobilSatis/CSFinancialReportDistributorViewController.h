//
//  CSFinancialReportDistributorViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 10.05.2013.
//
//

#import <UIKit/UIKit.h>
#import "CSFinancialReport.h"

@interface CSFinancialReportDistributorViewController : UITableViewController
@property (nonatomic, retain) CSFinancialReport *distributorFinancialReport;
- (id)initWithStyle:(UITableViewStyle)style andDistributorReport:(CSFinancialReport *)report;
@end
