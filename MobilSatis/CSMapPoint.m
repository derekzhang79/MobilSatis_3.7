//
//  MapPoint.m
//  Whereami
//
//  Created by Joe Conway on 8/10/09.
//  Copyright 2009 Big Nerd Ranch. All rights reserved.
//

#import "CSMapPoint.h"


@implementation CSMapPoint
@synthesize coordinate, title,pngName,tablePngName;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
	self = [super init];
	coordinate = c;
	[self setTitle:t];
	
	return self;
}

@end
