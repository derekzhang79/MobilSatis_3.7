//
//  CSUserSaleData.h
//  MobilSatis
//
//  Created by Alp Keser on 6/6/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSUserSaleData : NSObject{
    NSString *category;
    NSString *label;
    NSString *actualHistory;
    NSString *actualCurrent;
    NSString *development;
    NSString *budget;
    NSString *currentRate;
    NSString *leftAmount;
    NSString *lineKey;
}
@property(nonatomic,retain)NSString *categroy;
@property(nonatomic,retain)NSString *label;
@property(nonatomic,retain)NSString *actualHistory;
@property(nonatomic,retain)NSString *actualCurrent;
@property(nonatomic,retain)NSString *development;
@property(nonatomic,retain)NSString *budget;
@property(nonatomic,retain)NSString *currentRate;
@property(nonatomic,retain)NSString *leftAmount;
@property (nonatomic, retain) NSString *lineKey;


- (id)initWithCategory:(NSString*)aCategory andLabel:(NSString*)aLabel andActualHistory:(NSString*) anActualHistory andCurrent:(NSString*) aCurrent andDevelopment:(NSString*) aDevelopment andBudget:(NSString*)aBudget andCurrentRate:(NSString*) aCurrentRate andLineKey:(NSString *)aLineKey;

@end
