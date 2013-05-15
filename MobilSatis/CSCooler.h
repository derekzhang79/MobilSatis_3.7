//
//  CSCooler.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCooler : NSObject{
    NSString *sernr;
    NSString *description;
    NSString *status;
    NSString *quantity;
    NSString *matnr;
    NSString *type;
    NSString *barcodeFailed;
}
@property(nonatomic,retain)NSString *sernr;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *quantity;
@property(nonatomic,retain)NSString *matnr;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *barcodeFailed;
@property BOOL stockTaking;
@end
