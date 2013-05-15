//
//  CustomerDetail.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cooler, CustomerVisitList, DealerSalesData, MonthlySaleData;

@interface CustomerDetail : NSManagedObject

@property (nonatomic, retain) NSString * borough;
@property (nonatomic, retain) NSString * boroughCode;
@property (nonatomic, retain) NSString * cashRegister;
@property (nonatomic, retain) NSString * certificateNumber;
@property (nonatomic, retain) NSString * certificateOffice;
@property (nonatomic, retain) NSString * closeM2;
@property (nonatomic, retain) NSString * customerFeature;
@property (nonatomic, retain) NSString * customerGroup;
@property (nonatomic, retain) NSString * customerManager;
@property (nonatomic, retain) NSString * customerPosition;
@property (nonatomic, retain) NSString * distrinct;
@property (nonatomic, retain) NSString * distrinctCode;
@property (nonatomic, retain) NSString * doorNumber;
@property (nonatomic, retain) NSString * efesContract;
@property (nonatomic, retain) NSString * kunnr;
@property (nonatomic, retain) NSString * locationGroup;
@property (nonatomic, retain) NSString * m2;
@property (nonatomic, retain) NSString * mainStreet;
@property (nonatomic, retain) NSString * marketDeveloper;
@property (nonatomic, retain) NSString * name1;
@property (nonatomic, retain) NSString * neighbourhood;
@property (nonatomic, retain) NSString * openM2;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * saleChief;
@property (nonatomic, retain) NSString * saleManager;
@property (nonatomic, retain) NSString * salesRepresentative;
@property (nonatomic, retain) NSString * sesGroup;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * stateCode;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * taxNumber;
@property (nonatomic, retain) NSString * taxOffice;
@property (nonatomic, retain) NSString * telf1;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *coolers;
@property (nonatomic, retain) NSSet *customerSale;
@property (nonatomic, retain) NSSet *customerVisitList;
@property (nonatomic, retain) NSSet *otherCoolers;
@property (nonatomic, retain) DealerSalesData *dealerSale;
@end

@interface CustomerDetail (CoreDataGeneratedAccessors)

- (void)addCoolersObject:(Cooler *)value;
- (void)removeCoolersObject:(Cooler *)value;
- (void)addCoolers:(NSSet *)values;
- (void)removeCoolers:(NSSet *)values;
- (void)addCustomerSaleObject:(MonthlySaleData *)value;
- (void)removeCustomerSaleObject:(MonthlySaleData *)value;
- (void)addCustomerSale:(NSSet *)values;
- (void)removeCustomerSale:(NSSet *)values;
- (void)addCustomerVisitListObject:(CustomerVisitList *)value;
- (void)removeCustomerVisitListObject:(CustomerVisitList *)value;
- (void)addCustomerVisitList:(NSSet *)values;
- (void)removeCustomerVisitList:(NSSet *)values;
- (void)addOtherCoolersObject:(Cooler *)value;
- (void)removeOtherCoolersObject:(Cooler *)value;
- (void)addOtherCoolers:(NSSet *)values;
- (void)removeOtherCoolers:(NSSet *)values;
@end
