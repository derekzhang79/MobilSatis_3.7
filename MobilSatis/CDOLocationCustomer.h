//
//  CDOLocationCustomer.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDOLocation;

@interface CDOLocationCustomer : NSManagedObject

@property (nonatomic, retain) NSString * hasPlan;
@property (nonatomic, retain) NSString * kunnr;
@property (nonatomic, retain) NSString * name1;
@property (nonatomic, retain) NSString * other;
@property (nonatomic, retain) NSString * relationship;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) CDOLocation *location;

@end
