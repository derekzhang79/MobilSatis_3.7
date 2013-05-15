//
//  CDOVisitDetail.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 12.12.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDOVisitDetail : NSManagedObject

@property (nonatomic, retain) NSString * customerNumber;
@property (nonatomic, retain) NSString * userMyk;
@property (nonatomic, retain) NSString * text;

@end
