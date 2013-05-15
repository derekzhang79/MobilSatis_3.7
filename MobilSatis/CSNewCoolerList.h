//
//  CSNewCoolerList.h
//  CrmServis
//
//  Created by ABH on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
#import "ABHConnectionInfo.h"
#import "CSCooler.h"
@interface CSNewCoolerList : NSObject<ABHSAPHandlerDelegate>{
    
}

+(NSMutableArray*)getNewCoolerList;
+(void)initNewCoolers;
@end
