//
//  CSApplicationProperties.m
//  CrmServis
//
//  Created by ABH on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSApplicationProperties.h"
 
@implementation CSApplicationProperties
NSString *versionOfTheAppliaction = @"1.10"; 
+(NSString*)getVersionOfApplication{
    return versionOfTheAppliaction;
}
+(UIColor*)getUsualTextColor{
    return  [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];

}

@end
