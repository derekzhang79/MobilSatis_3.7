//
//  MapPoint.m
//  Whereami
//
//  Created by Joe Conway on 8/10/09.
//  Copyright 2009 Big Nerd Ranch. All rights reserved.
//

#import "CNMapPoint.h"


@implementation CNMapPoint
@synthesize coordinate, title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
	self = [super init];
	coordinate = c;
	[self setTitle:t];
	
	return self;
}
- (void)dealloc
{
    [super dealloc];
	[title release];
	
}
@end
