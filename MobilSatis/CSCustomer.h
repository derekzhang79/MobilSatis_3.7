//
//  CSCustomer.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDealer.h"
#import "CSMapPoint.h"
@interface CSCustomer : NSObject{
    NSString *kunnr;
    NSString *name1;
    CSDealer *dealer;
    NSString *relationship;
    NSString *role;    
    NSMutableArray *coolers;
    CSMapPoint  *locationCoordinate;
    
    
    
}

@property(nonatomic,retain)NSString *kunnr;
@property(nonatomic,retain)NSString *name1;
@property(nonatomic,retain)CSDealer *dealer;
@property(nonatomic,retain)NSString *relationship;
@property(nonatomic,retain)NSString *role;    
@property(nonatomic,retain)NSMutableArray *coolers;
@property(nonatomic,retain)CSMapPoint *locationCoordinate;

@end
