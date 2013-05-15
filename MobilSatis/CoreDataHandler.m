//
//  CoreDataHandler.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 19.11.2012.
//
//

#import "CoreDataHandler.h"

@implementation CoreDataHandler

static bool isCoreDataSwitchOn;

+ (CoreDataHandler *)getCoreDataHandler {
    static CoreDataHandler *coreDataHandler;
    
    @synchronized(self)
    {
        if(!coreDataHandler)
        {
            coreDataHandler = [[CoreDataHandler alloc] init];

        }
    }
    return coreDataHandler;
}

+ (NSManagedObjectContext *)getManagedObject {
    static NSManagedObjectContext *managedObjectContext;
    
    @synchronized(self)
    {
        if(!managedObjectContext)
        {
            CSAppDelegate *appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            managedObjectContext = [appDelegate managedObjectContext];
            
        }
        
    }
    return managedObjectContext;
}

+ (NSMutableArray *)getEntityData:(NSString *)entityName
{    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[CoreDataHandler getManagedObject]];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSMutableArray *mutableFetchResults = [[[CoreDataHandler getManagedObject] executeFetchRequest:request error:&error] mutableCopy];
    
    return mutableFetchResults;
}

+ (id)insertEntityData:(NSString *)entityName {
   return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[CoreDataHandler getManagedObject]];
}

+ (void)saveEntityData {
    
    NSError *error = nil;
    
    if (![[CoreDataHandler getManagedObject] save:&error]) {
        NSLog(@"error merror");
        return;
    }
}

+ (void)deleteAllObjects:(NSString *)entityDescription  {
    
    NSMutableArray *items = [CoreDataHandler getEntityData:entityDescription];
    NSError *error;
    
    for (NSManagedObject *managedObject in items) {
    	[[CoreDataHandler getManagedObject] deleteObject:managedObject];
    }
    if (![[CoreDataHandler getManagedObject] save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

+ (BOOL)isInternetConnectionNotAvailable {
    
    CSAppDelegate *appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Reachability *curReach = [appDelegate internetReach];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];

    switch (netStatus)
    {
        case NotReachable:
        {
            return YES;
            break;
        }
        case ReachableViaWiFi:
        {
            return NO;
            break;
        }
        case ReachableViaWWAN:
        {
            return NO;
            break;
        }
    }
    return YES;
}

+ (void)dropAllTables {
    
    [CoreDataHandler deleteAllObjects:@"CDOUser"];
    [CoreDataHandler deleteAllObjects:@"CDOCustomer"];
    [CoreDataHandler deleteAllObjects:@"CDODealer"];
    [CoreDataHandler deleteAllObjects:@"CDOLocation"];
    [CoreDataHandler deleteAllObjects:@"CDOCoordinate"];
    [CoreDataHandler deleteAllObjects:@"CDOCooler"];
    [CoreDataHandler deleteAllObjects:@"CDOUserSaleData"];
    [CoreDataHandler deleteAllObjects:@"CDOSaleData"];
    [CoreDataHandler deleteAllObjects:@"CDOChartSaleData"];
    [CoreDataHandler deleteAllObjects:@"CDOMonthlySaleData"];
    [CoreDataHandler deleteAllObjects:@"CDOLocationCustomer"];
    [CoreDataHandler deleteAllObjects:@"CDOCustomerDetail"];
    [CoreDataHandler deleteAllObjects:@"CDOCustomerVisitList"];
    [CoreDataHandler deleteAllObjects:@"CDODealerSalesData"];
    [CoreDataHandler deleteAllObjects:@"CDOVisitDetail"];
}

+ (BOOL)isViewSupportsOffline: (NSString *)classDescription {
    
    if ([classDescription isEqualToString:@"UITabBarController"] || [classDescription isEqualToString:@"CSLoginViewController"] || [classDescription isEqualToString:@"CSDealerListViewController"] || [classDescription isEqualToString:@"CSCustomerListViewController"] || [classDescription isEqualToString:@"CSLoctionHandlerViewController"] || [classDescription isEqualToString:@"CSProfileViewController"] || [classDescription isEqualToString:@"CSProcessSelectionViewController"] || [classDescription isEqualToString:@"CSUserSalesViewController"] || [classDescription isEqualToString:@"CSUserSaleDataViewController"] || [classDescription isEqualToString:@"CSUserSalesDetailsViewController"] || [classDescription isEqualToString:@"CSCustomerDetailViewController"] || [classDescription isEqualToString:@"CSCustomerVisitListViewController"] || [classDescription isEqualToString:@"CSCustomerSalesChartViewController" ] || [classDescription isEqualToString:@"CSProfileSalesChartViewController"] ||
        [classDescription isEqualToString:@"CSEquipmentViewController"] || [classDescription isEqualToString:@"CSDealerSalesChartViewController"] || [classDescription isEqualToString:@"CSVisitDetailViewController"] )
    {
        return YES;
    }
    
    return NO;
}

+ (id)insertExistingEntityData:(NSString *)entityDescription andValueForSort:(NSString *)aKey {
    
    // Retrieve the entity from the local store -- much like a table in a database
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[CoreDataHandler getManagedObject]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
//    // Set the sorting -- mandatory, even if you're fetching a single record/object
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:aKey ascending:YES];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [request setSortDescriptors:sortDescriptors];
    
    // Request the data -- NOTE, this assumes only one match, that
    // yourIdentifyingQualifier is unique. It just grabs the first object in the array.
    NSError *error;
    return [[[CoreDataHandler getManagedObject] executeFetchRequest:request error:&error] objectAtIndex:0];
}

+ (id)fetchExistingEntityData:(NSString *)aFetchRequestDescription sortingParameter:(NSString *)aSortingParameter objectContext:(NSManagedObjectContext *)aObjectContext{
    
    // goal: tell the FRC to fetch all property objects that belong to the previously selected item
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    
    // fetch all Property entities.
    NSEntityDescription *entity = [NSEntityDescription entityForName:aFetchRequestDescription inManagedObjectContext:aObjectContext];
    
    [fetch setEntity:entity];
    
    // limit to those entities that belong to the particular item
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"item.name like '%@'",self.item.name]];
//    [fetch setPredicate:predicate];
    
    // sort it. Boring.
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:aSortingParameter ascending:YES];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sort]];

    NSFetchedResultsController *fetchedArray = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[CoreDataHandler getManagedObject] sectionNameKeyPath:nil cacheName:nil];

    // ...create the fetch results controller...
    NSError *fetchRequestError;
    BOOL success = [fetchedArray performFetch:&fetchRequestError];
    
    return [fetchedArray fetchedObjects];
}

+ (NSManagedObjectModel *)getManagedObjectModel {
    static NSManagedObjectModel *managedObjectModel;
    
    @synchronized(self)
    {
        if(!managedObjectModel)
        {
            CSAppDelegate *appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            managedObjectModel = [appDelegate managedObjectModel];
            
        }
        
    }
    return managedObjectModel;
}

+ (id)fetchCustomerDetailByKunnr:(NSString *)aKunnr {

    // goal: tell the FRC to fetch all property objects that belong to the previously selected item
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];

    // fetch all Property entities.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDOCustomerDetail" inManagedObjectContext:[CoreDataHandler getManagedObject]];

    [fetch setEntity:entity];   

    // limit to those entities that belong to the particular item
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"kunnr == '%@'",aKunnr]];
    [fetch setPredicate:predicate];

    // sort it. Boring.
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"kunnr" ascending:YES];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sort]];

    NSFetchedResultsController *fetchedArray = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[CoreDataHandler getManagedObject] sectionNameKeyPath:nil cacheName:nil];

    // ...create the fetch results controller...
    NSError *fetchRequestError;
    BOOL success = [fetchedArray performFetch:&fetchRequestError];
    
    if (success) {
        return [fetchedArray fetchedObjects];
    }
    
    return NO;
}

+ (void)saveCoreDataSwitchState:(BOOL)state {
    isCoreDataSwitchOn = state;
}

+ (BOOL)isCoreDataSwitchOn {
    return isCoreDataSwitchOn;
}


@end
