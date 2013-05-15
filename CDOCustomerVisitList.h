//
//  CDOCustomerVisitList.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDOCustomerVisitList : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * myk;
@property (nonatomic, retain) NSString * name;

@end
