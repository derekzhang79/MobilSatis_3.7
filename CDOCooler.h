//
//  CDOCooler.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 29.11.2012.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDOCooler : NSManagedObject

@property (nonatomic, retain) NSString * barcodeFailed;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * matnr;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * sernr;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * type;

@end
