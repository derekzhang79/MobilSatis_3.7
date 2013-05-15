//
//  CDOUser.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 12.12.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDOChartSaleData, CDOCoordinate, CDOCustomer, CDODealer, CDOUserSaleData;

@interface CDOUser : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * userMyk;
@property (nonatomic, retain) CDOChartSaleData *chartSaleData;
@property (nonatomic, retain) NSSet *customers;
@property (nonatomic, retain) NSSet *dealers;
@property (nonatomic, retain) CDOCoordinate *location;
@property (nonatomic, retain) CDOUserSaleData *userSaleData;
@end

@interface CDOUser (CoreDataGeneratedAccessors)

- (void)addCustomersObject:(CDOCustomer *)value;
- (void)removeCustomersObject:(CDOCustomer *)value;
- (void)addCustomers:(NSSet *)values;
- (void)removeCustomers:(NSSet *)values;
- (void)addDealersObject:(CDODealer *)value;
- (void)removeDealersObject:(CDODealer *)value;
- (void)addDealers:(NSSet *)values;
- (void)removeDealers:(NSSet *)values;
@end
