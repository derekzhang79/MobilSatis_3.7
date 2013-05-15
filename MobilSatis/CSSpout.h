//
//  CSSpout.h
//  CrmServis
//
//  Created by ABH on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSpout : NSObject{
    NSString *matnr;
    NSString *description;
    NSString *type;    
}
@property (nonatomic,retain) NSString *matnr;
@property (nonatomic,retain) NSString *desription;
@property (nonatomic,retain) NSString *type;

@end
