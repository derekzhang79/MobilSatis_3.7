//
//  CSDraggableMapPoint.m
//  MobilSatis
//
//  Created by ABH on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSDraggableMapPoint.h"

@implementation CSDraggableMapPoint
@synthesize coordinate, title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
	self = [super init];
	coordinate = c;
	[self setTitle:t];
	
	return self;
}

@end
