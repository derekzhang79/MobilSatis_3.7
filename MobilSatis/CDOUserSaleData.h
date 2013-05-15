//
//  CDOUserSaleData.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 04.12.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDOSaleData;

@interface CDOUserSaleData : NSManagedObject

@property (nonatomic, retain) NSString * saleMessage;
@property (nonatomic, retain) NSString * saleTitle1;
@property (nonatomic, retain) NSString * saleTitle2;
@property (nonatomic, retain) NSString * saleTitle3;
@property (nonatomic, retain) NSString * saleTitle4;
@property (nonatomic, retain) NSSet *saleReport1;
@property (nonatomic, retain) NSSet *saleReport2;
@property (nonatomic, retain) NSSet *saleReport3;
@property (nonatomic, retain) NSSet *saleReport4;
@end

@interface CDOUserSaleData (CoreDataGeneratedAccessors)

- (void)addSaleReport1Object:(CDOSaleData *)value;
- (void)removeSaleReport1Object:(CDOSaleData *)value;
- (void)addSaleReport1:(NSSet *)values;
- (void)removeSaleReport1:(NSSet *)values;
- (void)addSaleReport2Object:(CDOSaleData *)value;
- (void)removeSaleReport2Object:(CDOSaleData *)value;
- (void)addSaleReport2:(NSSet *)values;
- (void)removeSaleReport2:(NSSet *)values;
- (void)addSaleReport3Object:(CDOSaleData *)value;
- (void)removeSaleReport3Object:(CDOSaleData *)value;
- (void)addSaleReport3:(NSSet *)values;
- (void)removeSaleReport3:(NSSet *)values;
- (void)addSaleReport4Object:(CDOSaleData *)value;
- (void)removeSaleReport4Object:(CDOSaleData *)value;
- (void)addSaleReport4:(NSSet *)values;
- (void)removeSaleReport4:(NSSet *)values;
@end
