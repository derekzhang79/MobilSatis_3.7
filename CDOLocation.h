//
//  CDOLocation.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDOCoordinate;

@interface CDOLocation : NSManagedObject

@property (nonatomic, retain) NSString * pngName;
@property (nonatomic, retain) NSString * tablePngName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) CDOCoordinate *coordinate;

@end
