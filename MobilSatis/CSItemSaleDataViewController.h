//
//  CSItemSaleDataViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 15.11.2012.
//
//

#import "CSBaseViewController.h"
#import "CSGraphData.h"
#import "CSBarGraphHandler.h"
#import "CSUserSaleData.h"

@interface CSItemSaleDataViewController : CSBaseViewController <ABHSAPHandlerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
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
    CSUserSaleData *userSaleData;
    NSString *title;
    NSString *beginDate;
    NSString *endDate;
    
}
@property(nonatomic, retain) UIPickerView *pickerView;

- (id)initWithUser:(CSUser *)myUser andUserSaleData:(CSUserSaleData*)anUserSaleData andTitle:(NSString*)atitle beginDate:(NSString*)aBegin endDate:(NSString *)aEnd;

@end
