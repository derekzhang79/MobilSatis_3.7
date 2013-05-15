//
//  InfoViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSReportProblemViewController.h"
#import "CoreDataHandler.h"

@interface CSInfoViewController : CSBaseViewController{
    IBOutlet UITextView *mail;
    IBOutlet UITextView *phone;
    IBOutlet UISwitch   *coreDataSwitch;
}

- (IBAction)reportProblem:(id)sender;
- (IBAction)coreDataSwitchChanged:(id)sender;
@end
