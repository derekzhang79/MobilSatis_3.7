//
//  SaleData.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 26.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SaleData : NSManagedObject

@property (nonatomic, retain) NSString * actualCurrent;
@property (nonatomic, retain) NSString * actualHistory;
@property (nonatomic, retain) NSString * budget;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * currentRate;
@property (nonatomic, retain) NSString * development;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * leftAmount;
@property (nonatomic, retain) NSString * lineKey;

@end
