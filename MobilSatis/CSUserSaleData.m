//
//  CSUserSaleData.m
//  MobilSatis
//
//  Created by Alp Keser on 6/6/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import "CSUserSaleData.h"

@implementation CSUserSaleData
@synthesize categroy,label,actualCurrent,actualHistory,development,budget,currentRate,leftAmount, lineKey;

- (id)initWithCategory:(NSString*)aCategory andLabel:(NSString*)aLabel andActualHistory:(NSString*) anActualHistory andCurrent:(NSString*) aCurrent andDevelopment:(NSString*) aDevelopment andBudget:(NSString*)aBudget andCurrentRate:(NSString*) aCurrentRate andLineKey:(NSString *) aLineKey {
    self = [super init];
    [self setCategroy:aCategory];
    [self setLabel:aLabel];
    [self setActualHistory:anActualHistory];
    [self setActualCurrent:aCurrent];
    [self setDevelopment:aDevelopment];
    [self setBudget:aBudget];
    [self setCurrentRate:aCurrentRate];
    [self setLeftAmount:@""];
    [self setLineKey:aLineKey];
    return self;
    
}
@end
