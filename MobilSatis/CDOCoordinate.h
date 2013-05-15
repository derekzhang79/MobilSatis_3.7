//
//  CDOCoordinate.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDOCoordinate : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
