//
//  CSDealerSalesChartViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 12.11.2012.
//
//

#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import "CPTGraphHostingView.h"
#import "CSGraphData.h"
#import "CSBarGraphHandler.h"

@interface CSDealerSalesChartViewController : CSBaseViewController <ABHSAPHandlerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    CSCustomer *myCustomer;
    NSMutableArray *report1;
    NSMutableArray *budget1;
    NSMutableArray *report1Texts;
    NSMutableArray *report2;
    NSMutableArray *budget2;
    NSMutableArray *report2Texts;
    NSMutableArray *report3;
    NSMutableArray *budget3;
    NSMutableArray *report3Texts;
    NSString *header1;
    NSString *header2;
    NSString *header3;
    IBOutlet CSBarGraphHandler *barPlot;
    IBOutlet UIPickerView *pickerView;
    IBOutlet CPTGraphHostingView *barGraphHostingView;


}
@property (nonatomic, retain) CSCustomer *myCustomer;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer;

@end
