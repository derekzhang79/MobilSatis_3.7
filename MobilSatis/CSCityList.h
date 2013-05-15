//
//  CSCityList.h
//  MobilSatis
//
//  Created by Ata Cengiz on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBaseViewController.h"

@interface CSCityList : CSBaseViewController <ABHSAPHandlerDelegate>
{
    NSMutableArray *cityList;
    NSMutableArray *countyList;
    NSMutableArray *sesGroup;
    NSMutableArray *musozList;
    NSMutableArray *mupozList;
    NSMutableArray *locGroup;
    NSMutableArray *name1List;
    NSMutableArray *cancelList;
}

@property (nonatomic, retain) NSMutableArray *cityList;
@property (nonatomic, retain) NSMutableArray *countyList;
@property (nonatomic, retain) NSMutableArray *sesGroup;
@property (nonatomic, retain) NSMutableArray *musozList;
@property (nonatomic, retain) NSMutableArray *mupozList;
@property (nonatomic, retain) NSMutableArray *locGroup;
@property (nonatomic, retain) NSMutableArray *name1List;
@property (nonatomic, retain) NSMutableArray *cancelList;

+ (CSCityList *)getCityList;
- (void) allocateMethods;

@end
