//
//  CSVisitDetailViewController.h
//  MobilSatis
//
//  Created by ABH on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CSVisitDetailViewController : CSBaseViewController<UIAlertViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate>{
    CSCustomer *customer;
    IBOutlet UITextView *textView;
    BOOL *isStandartText;
    UISegmentedControl *segment;
    UIImageView *imageView;
    BOOL newMedia;
    NSMutableArray *mailList;
    UIPopoverController *popOver;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property BOOL newMedia;
@property (nonatomic, retain) NSMutableArray *mailList;
@property (nonatomic, retain) UIPopoverController *popOver;

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer;
-(IBAction)ignoreKeyboard;
-(IBAction)checkIn:(id)sender;
- (void)sendVisitDetail;
- (void)sendMailwithVisit;
- (void)composeMail;
- (void)sendNoteToSelf;
- (void)initMailList:(NSString *)envelope;
@end
