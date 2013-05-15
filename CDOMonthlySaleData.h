//
//  CDOMonthlySaleData.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDOMonthlySaleData : NSManagedObject

@property (nonatomic, retain) NSString * budget;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * sale;

@end
