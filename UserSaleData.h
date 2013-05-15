//
//  UserSaleData.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 26.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SaleData;

@interface UserSaleData : NSManagedObject

@property (nonatomic, retain) NSSet *saleReport1;
@property (nonatomic, retain) NSSet *saleReport2;
@property (nonatomic, retain) NSSet *saleReport3;
@property (nonatomic, retain) NSSet *saleReport4;
@property (nonatomic, retain) NSSet *chartReport1;
@property (nonatomic, retain) NSSet *chartReport2;
@property (nonatomic, retain) NSSet *chartReport3;
@end

@interface UserSaleData (CoreDataGeneratedAccessors)

- (void)addSaleReport1Object:(SaleData *)value;
- (void)removeSaleReport1Object:(SaleData *)value;
- (void)addSaleReport1:(NSSet *)values;
- (void)removeSaleReport1:(NSSet *)values;
- (void)addSaleReport2Object:(SaleData *)value;
- (void)removeSaleReport2Object:(SaleData *)value;
- (void)addSaleReport2:(NSSet *)values;
- (void)removeSaleReport2:(NSSet *)values;
- (void)addSaleReport3Object:(SaleData *)value;
- (void)removeSaleReport3Object:(SaleData *)value;
- (void)addSaleReport3:(NSSet *)values;
- (void)removeSaleReport3:(NSSet *)values;
- (void)addSaleReport4Object:(SaleData *)value;
- (void)removeSaleReport4Object:(SaleData *)value;
- (void)addSaleReport4:(NSSet *)values;
- (void)removeSaleReport4:(NSSet *)values;
- (void)addChartReport1Object:(SaleData *)value;
- (void)removeChartReport1Object:(SaleData *)value;
- (void)addChartReport1:(NSSet *)values;
- (void)removeChartReport1:(NSSet *)values;
- (void)addChartReport2Object:(SaleData *)value;
- (void)removeChartReport2Object:(SaleData *)value;
- (void)addChartReport2:(NSSet *)values;
- (void)removeChartReport2:(NSSet *)values;
- (void)addChartReport3Object:(SaleData *)value;
- (void)removeChartReport3Object:(SaleData *)value;
- (void)addChartReport3:(NSSet *)values;
- (void)removeChartReport3:(NSSet *)values;
@end
