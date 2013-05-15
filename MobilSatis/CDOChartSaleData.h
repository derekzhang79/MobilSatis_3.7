//
//  CDOChartSaleData.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDOMonthlySaleData;

@interface CDOChartSaleData : NSManagedObject

@property (nonatomic, retain) NSString * chartTitle1;
@property (nonatomic, retain) NSString * chartTitle2;
@property (nonatomic, retain) NSString * chartTitle3;
@property (nonatomic, retain) NSSet *chartReport1;
@property (nonatomic, retain) NSSet *chartReport2;
@property (nonatomic, retain) NSSet *chartReport3;
@end

@interface CDOChartSaleData (CoreDataGeneratedAccessors)

- (void)addChartReport1Object:(CDOMonthlySaleData *)value;
- (void)removeChartReport1Object:(CDOMonthlySaleData *)value;
- (void)addChartReport1:(NSSet *)values;
- (void)removeChartReport1:(NSSet *)values;
- (void)addChartReport2Object:(CDOMonthlySaleData *)value;
- (void)removeChartReport2Object:(CDOMonthlySaleData *)value;
- (void)addChartReport2:(NSSet *)values;
- (void)removeChartReport2:(NSSet *)values;
- (void)addChartReport3Object:(CDOMonthlySaleData *)value;
- (void)removeChartReport3Object:(CDOMonthlySaleData *)value;
- (void)addChartReport3:(NSSet *)values;
- (void)removeChartReport3:(NSSet *)values;
@end
