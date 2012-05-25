//
//  CSConfirmation.h
//  CrmServisPrototype
//
//  Created by ABH on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSCustomer.h"
@interface CSConfirmation : NSObject{
    NSString *confirmationNumber;
    NSString *description;
    CSCustomer *customer;
    NSMutableArray *items;
    NSString *activityReason;
    
}

@property (nonatomic,retain) NSString *confirmationNumber;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *activityReason;
@property (nonatomic,retain) CSCustomer *customer;
@property (nonatomic,retain) NSMutableArray *items;


@end
