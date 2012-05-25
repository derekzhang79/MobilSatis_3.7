//
//  CSTowerAndSpoutList.h
//  CrmServis
//
//  Created by ABH on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABHSAPHandler.h"
#import "ABHConnectionInfo.h"
#import "ABHXMLHelper.h"
#import "CSTower.h"
#import "CSSpout.h"
@interface CSTowerAndSpoutList : NSObject<ABHSAPHandlerDelegate>{
    
}

+(NSMutableArray*)getTowers;
+(NSMutableArray*)getSpouts;
+(void)initEquipments;

@end
