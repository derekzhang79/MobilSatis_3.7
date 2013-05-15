//
//  CSReportProblemViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 02.10.2012.
//
//

#import "CSBaseViewController.h"

@interface CSReportProblemViewController : CSBaseViewController <UIAlertViewDelegate, ABHSAPHandlerDelegate>
{
    IBOutlet UITextView *textView;
    BOOL isStandartText;
}
@property (nonatomic ,retain) UITextView *textView;
@property BOOL isStandartText;

-(IBAction)sendReportToSap:(id)sender;
-(BOOL)checkFailureDescription;
-(IBAction)ignoreKeyboard;

@end
