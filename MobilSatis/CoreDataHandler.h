//
//  CoreDataHandler.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 19.11.2012.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "CDOSaleData.h"
#import "CDOMonthlySaleData.h"
#import "CDOLocationCustomer.h"
#import "CDOLocation.h"
#import "CDODealerSalesData.h"
#import "CDODealer.h"
#import "CDOCustomerDetail.h"
#import "CDOCustomer.h"
#import "CDOCoordinate.h"
#import "CDOCooler.h"
#import "CDOChartSaleData.h"
#import "CDOCustomerVisitList.h"
#import "CDOUserSaleData.h"
#import "CDOVisitDetail.h"
#import "CDOUser.h"

@interface CoreDataHandler : NSObject

+ (NSManagedObjectContext *)getManagedObject;

+ (NSMutableArray *)getEntityData:(NSString *)entityName;

+ (id)insertEntityData:(NSString *)entityName;

+ (void)saveEntityData;

+ (BOOL)isInternetConnectionNotAvailable;

+ (CoreDataHandler *)getCoreDataHandler;

+ (void)deleteAllObjects:(NSString *) entityDescription;

+ (void)dropAllTables;

+ (BOOL)isViewSupportsOffline: (NSString *)classDescription;

+ (id)insertExistingEntityData:(NSString *)entityDescription andValueForSort:(NSString *)aKey;

+ (id)fetchExistingEntityData:(NSString *)entityDescription  sortingParameter:(NSString *)aSortingParameter objectContext:(NSManagedObjectContext *)aObjectContext;

+ (NSManagedObjectModel *)getManagedObjectModel;

+ (id)fetchCustomerDetailByKunnr:(NSString *)aKunnr;

+ (void)saveCoreDataSwitchState:(BOOL)state;

+ (BOOL)isCoreDataSwitchOn;

@end
