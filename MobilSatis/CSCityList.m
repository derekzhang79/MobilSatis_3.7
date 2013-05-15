//
//  CSCityList.m
//  MobilSatis
//
//  Created by Ata Cengiz on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSCityList.h"

@implementation CSCityList
@synthesize cityList;
@synthesize countyList;
@synthesize sesGroup;
@synthesize musozList;
@synthesize mupozList;
@synthesize locGroup;
@synthesize name1List;
@synthesize cancelList;

+ (CSCityList *)getCityList{
    
    static CSCityList *list=nil;
    
    @synchronized(self)
    {
        if(!list)
        {
            list = [[CSCityList alloc] init];            
        }
        
    }    
    return list;
}

- (void) allocateMethods{
    
    
    cityList = [[NSMutableArray alloc] init];
    countyList = [[NSMutableArray alloc] init];
    sesGroup = [[NSMutableArray alloc] init];
    musozList = [[NSMutableArray alloc] init];
    mupozList = [[NSMutableArray alloc] init];
    locGroup = [[NSMutableArray alloc] init];
    name1List = [[NSMutableArray alloc] init];
    cancelList = [[NSMutableArray alloc] init];
    [self cityListSapHandler];
    
}

-(void) cityListSapHandler {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_CITY_COUNTY"];
    [sapHandler addTableWithName:@"ZMOB_CITY_COUNTY_LIST" andColumns:[NSMutableArray arrayWithObjects:@"CITY_ID",@"CITY_NAME",@"COUNTY_NAME", @"COUNTY_CODE", nil]];
    
    [sapHandler addTableWithName:@"ZMOB_GET_SESGRP" andColumns:[NSMutableArray arrayWithObjects:@"KUKLA",@"VTEXT",nil]];
    
    [sapHandler addTableWithName:@"ZMOB_GET_MUSOZ" andColumns:[NSMutableArray arrayWithObjects:@"KATR1", @"VTEXT", nil]];
    
    [sapHandler addTableWithName:@"ZMOB_GET_MUPOZ" andColumns:[NSMutableArray arrayWithObjects:@"UNDELIVER", @"UNDELI_TX", nil]];
        
    [sapHandler addTableWithName:@"ZMOB_GET_KATR5" andColumns:[NSMutableArray arrayWithObjects:@"KATR5", @"VTEXT", nil]];
    
    [sapHandler addTableWithName:@"ZMOB_GET_NAME" andColumns:[NSMutableArray arrayWithObjects:@"KUNNR", @"NAME1", nil]];
    
    [sapHandler addTableWithName:@"ZMOB_IPTAL_NEDEN" andColumns:[NSMutableArray arrayWithObjects:@"MANDT", @"KOD", @"TANIM", nil]];
    
    [sapHandler prepCall];
    [super playAnimationOnView:self.view];
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me{
    [super stopAnimationOnView];
    [self initCityAndCountyList:[[ABHXMLHelper getValuesWithTag:@"ZMOB_CITY_COUNTY" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initSesGroupList:[[ABHXMLHelper getValuesWithTag:@"ZMOB_SESGRP" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initMusozList:[[ABHXMLHelper getValuesWithTag:@"ZMOB_MUSOZ" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initMupozList:[[ABHXMLHelper getValuesWithTag:@"ZMOB_MUPOZ" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initLocationGroupList:[[ABHXMLHelper getValuesWithTag:@"ZMOB_KATR5" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initName1List:[[ABHXMLHelper getValuesWithTag:@"ZMOB_GET_NAME1" fromEnvelope:myResponse] objectAtIndex:0]];
    [self initCancelList:[[ABHXMLHelper getValuesWithTag:@"ZMOB_IPTAL_NEDEN" fromEnvelope:myResponse] objectAtIndex:0]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityListCompleted" object:nil userInfo:nil];
    
}

- (void)initCityAndCountyList:(NSString *)envelope {
    
    NSMutableArray *city_number = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *city_name = [ABHXMLHelper getValuesWithTag:@"CITY" fromEnvelope:envelope];
    NSMutableArray *city_code = [ABHXMLHelper getValuesWithTag:@"CITY_CODE" fromEnvelope:envelope];
    NSMutableArray *county_name = [ABHXMLHelper getValuesWithTag:@"COUNTY" fromEnvelope:envelope];
    NSMutableArray *county_code = [ABHXMLHelper getValuesWithTag:@"COUNTY_CODE" fromEnvelope:envelope];
    
    int counter = 0;
    
    NSMutableArray *cityBuffer = [[NSMutableArray alloc] init];
    NSMutableArray *cityIdBuffer = [[NSMutableArray alloc] init];
    
    [cityBuffer addObject:[city_name objectAtIndex:0]];
    [cityIdBuffer addObject:[city_code objectAtIndex:0]];
    
    for (int i = 1; i < [city_number count]; i++) {
        
        NSString *cityName = [city_name objectAtIndex:i];
        
        if ([cityName isEqualToString:[cityBuffer objectAtIndex:counter]]) {
            continue;
        }
        else {
            [cityBuffer addObject:[city_name objectAtIndex:i]];
            [cityIdBuffer addObject:[city_code objectAtIndex:i]];
            counter++;
        }
        
    }
    
    counter = 0;
    
    @try {
        for (int i = 0; i < [cityBuffer count]; i++) {
            
            NSMutableArray *countyBuffer = [[NSMutableArray alloc] init];
            
            while ([[cityBuffer objectAtIndex:i] isEqualToString:[city_name objectAtIndex:counter]]) {
                if (counter < [city_name count])
                {
                    NSArray *arr = [[NSArray alloc] initWithObjects:[county_name objectAtIndex:counter], [county_code objectAtIndex:counter], nil];
                    [countyBuffer addObject:arr];
                    counter++;
                }
                else {
                    break;
                }
            }
            
            NSArray *arr = [[NSArray alloc]initWithObjects:[cityBuffer objectAtIndex:i], [cityIdBuffer objectAtIndex:i],countyBuffer, nil];
            [cityList addObject:arr];
        }        
    }
    @catch (NSException *exception) {
    
    }
}


- (void)initSesGroupList:(NSString *)envelope {
    
    NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *sesNumber = [ABHXMLHelper getValuesWithTag:@"KUKLA" fromEnvelope:envelope];
    NSMutableArray *sesName = [ABHXMLHelper getValuesWithTag:@"VTEXT" fromEnvelope:envelope];
    
    for (int i = 0; i < [itemCount count]; i++) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[sesNumber objectAtIndex:i], [sesName objectAtIndex:i], nil];
        
        [sesGroup addObject:arr];
    }
}

- (void)initMusozList:(NSString *)envelope {
    
    NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *musozNumber = [ABHXMLHelper getValuesWithTag:@"KATR1" fromEnvelope:envelope];
    NSMutableArray *musozName = [ABHXMLHelper getValuesWithTag:@"VTEXT" fromEnvelope:envelope];
    
    for (int i = 0; i < [itemCount count]; i++) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[musozNumber objectAtIndex:i], [musozName objectAtIndex:i], nil];
        
        [musozList addObject:arr];
    }
}

- (void)initMupozList:(NSString *)envelope {
    
    NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *mupozNumber = [ABHXMLHelper getValuesWithTag:@"UNDELIVER" fromEnvelope:envelope];
    NSMutableArray *mupozName = [ABHXMLHelper getValuesWithTag:@"UNDELI_TX" fromEnvelope:envelope];
    
    for (int i = 0; i < [itemCount count]; i++) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[mupozNumber objectAtIndex:i], [mupozName objectAtIndex:i], nil];
        
        [mupozList addObject:arr];
    }
}


- (void)initLocationGroupList:(NSString *)envelope {
    
    NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *katr5Number = [ABHXMLHelper getValuesWithTag:@"KATR5" fromEnvelope:envelope];
    NSMutableArray *katr5Name = [ABHXMLHelper getValuesWithTag:@"VTEXT" fromEnvelope:envelope];
    
    for (int i = 0; i < [itemCount count]; i++) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[katr5Number objectAtIndex:i], [katr5Name objectAtIndex:i], nil];
        
        [locGroup addObject:arr];
    }
    
}

- (void)initName1List:(NSString *)envelope {
    NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *kunnrArray = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:envelope];
    NSMutableArray *name1Number = [ABHXMLHelper getValuesWithTag:@"NAME1" fromEnvelope:envelope];
    
    for (int i = 0; i < [itemCount count]; i++)
    {
        NSArray *arr = [[NSArray alloc] initWithObjects:[kunnrArray objectAtIndex:i],[name1Number objectAtIndex:i], nil];
        [name1List addObject:arr];
    }
}

- (void)initCancelList:(NSString *)envelope {
    NSMutableArray *itemCount = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:envelope];
    NSMutableArray *tanim     = [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:envelope];
    NSMutableArray *kod       = [ABHXMLHelper getValuesWithTag:@"KOD" fromEnvelope:envelope];
    
    for (int  i = 0; i < [itemCount count]; i++) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[kod objectAtIndex:i], [tanim objectAtIndex:i], nil];
        [cancelList addObject:arr];
    }
}

@end
