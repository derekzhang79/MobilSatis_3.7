//
//  CSCoolerCreationViewController.h
//  MobilSatis
//
//  Created by Ata Cengiz on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSTowerAndSpoutSelectionViewController.h"

@class CSTowerAndSpoutSelectionViewController;
@interface CSCoolerCreationViewController : CSBaseViewController <UITextFieldDelegate>
{
    UIButton *createButton;
    UITextView *textView;
    CSTowerAndSpoutSelectionViewController *towerViewController;
    UIImageView *imageView;
    BOOL isStandartText;
}
@property (nonatomic, retain) IBOutlet UIButton *createButton;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) CSTowerAndSpoutSelectionViewController *towerViewController;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property BOOL isStandartText;

- (IBAction)sendToSAP;
- (IBAction)makeKeyboardGoAway;
@end
