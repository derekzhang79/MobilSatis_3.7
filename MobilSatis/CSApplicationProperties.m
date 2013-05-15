//
//  CSApplicationProperties.m
//  CrmServis
//
//  Created by ABH on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSApplicationProperties.h"
 
@implementation CSApplicationProperties
NSString *versionOfTheAppliaction = @"3.6"; 
+(NSString*)getVersionOfApplication{
    return versionOfTheAppliaction;
}
+(UIColor*)getUsualTextColor{
    return  [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];

}

+ (UIColor*)getEfesBlueColor{
    return [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
}

@end
