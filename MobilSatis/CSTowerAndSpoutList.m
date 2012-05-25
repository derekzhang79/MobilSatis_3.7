//
//  CSTowerAndSpoutList.m
//  CrmServis
//
//  Created by ABH on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSTowerAndSpoutList.h"

@implementation CSTowerAndSpoutList
NSMutableArray *towers;
NSMutableArray *spouts;

+(NSMutableArray*)getTowers{
    return  towers;
}
+(NSMutableArray*)getSpouts{
    return spouts;
}

+(void)initEquipments{
    NSString *tableName = [NSString stringWithFormat:@"MALZEMELER"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"URUNID"];
    [columns addObject:@"TANIM"];
    [columns addObject:@"TIP"];	
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_FICI_MALZEME"];
    
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    
}
+(void)getResponseWithString:(NSString *)myResponse{
    towers = [[NSMutableArray alloc] init];
    spouts = [[NSMutableArray alloc] init];
    NSMutableArray *coolerIds =  [ABHXMLHelper getValuesWithTag:@"URUNID" fromEnvelope:myResponse];
    NSMutableArray *descriptions =  [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:myResponse];
    NSMutableArray *types =  [ABHXMLHelper getValuesWithTag:@"TIP" fromEnvelope:myResponse];
    CSTower *tempTower;
    CSSpout *tempSpout;
    
    if( [coolerIds count] != 0 ){
        for (int sayac = 0 ; sayac<coolerIds.count; sayac++) {
            if ([[types objectAtIndex:sayac]isEqualToString:@"FICI_KULE"]) {
                tempTower = [[CSTower alloc ] init];
                [tempTower setMatnr:[coolerIds objectAtIndex:sayac] ];
                [tempTower setDesription: [descriptions objectAtIndex:sayac]];
                [tempTower setType:[types objectAtIndex:sayac]];
                [towers addObject:tempTower];
            }else{
                tempSpout = [[CSSpout alloc] init];
                [tempSpout setMatnr:[coolerIds objectAtIndex:sayac] ];
                [tempSpout setDesription: [descriptions objectAtIndex:sayac]];
                [tempSpout setType:[types objectAtIndex:sayac]];
                [spouts addObject:tempSpout];
            }
        }
    }
    
}

@end
