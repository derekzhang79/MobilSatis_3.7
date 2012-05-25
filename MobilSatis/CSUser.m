//
//  CSUser.m
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CSUser.h"

@implementation CSUser
@synthesize username,name,password,customers,surname,dealers,mail,location;

- (void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:username  forKey:@"username"];

	
}

- (id)initWithCoder:(NSCoder *)decoder{
	//self = [super init];
	[self setUsername:[decoder decodeObjectForKey:@"username"]];
	return self;
}
@end
