//
//  CDODealerSalesData.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDOMonthlySaleData;

@interface CDODealerSalesData : NSManagedObject

@property (nonatomic, retain) NSString * title1;
@property (nonatomic, retain) NSString * title2;
@property (nonatomic, retain) NSString * title3;
@property (nonatomic, retain) NSSet *dealerSalesReport1;
@property (nonatomic, retain) NSSet *dealerSalesReport2;
@property (nonatomic, retain) NSSet *dealerSalesReport3;
@end

@interface CDODealerSalesData (CoreDataGeneratedAccessors)

- (void)addDealerSalesReport1Object:(CDOMonthlySaleData *)value;
- (void)removeDealerSalesReport1Object:(CDOMonthlySaleData *)value;
- (void)addDealerSalesReport1:(NSSet *)values;
- (void)removeDealerSalesReport1:(NSSet *)values;
- (void)addDealerSalesReport2Object:(CDOMonthlySaleData *)value;
- (void)removeDealerSalesReport2Object:(CDOMonthlySaleData *)value;
- (void)addDealerSalesReport2:(NSSet *)values;
- (void)removeDealerSalesReport2:(NSSet *)values;
- (void)addDealerSalesReport3Object:(CDOMonthlySaleData *)value;
- (void)removeDealerSalesReport3Object:(CDOMonthlySaleData *)value;
- (void)addDealerSalesReport3:(NSSet *)values;
- (void)removeDealerSalesReport3:(NSSet *)values;
@end
