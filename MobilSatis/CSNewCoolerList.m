//
//  CSNewCoolerList.m
//  CrmServis
//
//  Created by ABH on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSNewCoolerList.h"

@implementation CSNewCoolerList
NSMutableArray *coolers;

+(NSMutableArray*) getNewCoolerList{
    return coolers;
}

+(void)initNewCoolers{
    NSString *tableName = [NSString stringWithFormat:@"SOGUTUCULAR"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"URUNID"];
    [columns addObject:@"TANIM"];
    [columns addObject:@"TIP"];
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_COOLERS"];

    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    
}
+(void)getResponseWithString:(NSString *)myResponse{
    coolers = [[NSMutableArray alloc] init];
    NSMutableArray *coolerIds =  [ABHXMLHelper getValuesWithTag:@"URUNID" fromEnvelope:myResponse];
    NSMutableArray *descriptions =  [ABHXMLHelper getValuesWithTag:@"TANIM" fromEnvelope:myResponse];
    NSMutableArray *types =  [ABHXMLHelper getValuesWithTag:@"TIP" fromEnvelope:myResponse];
    CSCooler *tempCooler;
    if( [coolerIds count] != 0 ){
        for (int sayac = 0 ; sayac<coolerIds.count; sayac++) {
            tempCooler = [[CSCooler alloc] init];
            [tempCooler setMatnr:[coolerIds objectAtIndex:sayac]];
            [tempCooler setDescription:[descriptions objectAtIndex:sayac]];
            [tempCooler setType:[types objectAtIndex:sayac]];
            [coolers addObject:tempCooler];
        }
    }
 
}
@end
