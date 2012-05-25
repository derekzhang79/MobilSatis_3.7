//
//  ABHSAPHandler.h
//  CrmServisPrototype
//
//  Created by ABH on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ABHSAPHandlerDelegate;
@interface ABHSAPHandler : NSObject{
    NSString *header;
    NSString *config;
    NSString *import;
    NSString *table;
    NSString *footer;
    NSString *hostNameLine;
    NSString *clientLine;
    NSString *destinationLine;
    NSString *systemNumberLine;
    NSString *userIdLine;
    NSString *passwordLine;
    NSString *RFCNameLine;
    NSMutableArray *imports;
    NSMutableArray *tables;
    
    //beware the mighty!!
    NSString *soapMsg;
    
    //config only
    NSString *connectionUrl;  //@"http://saprfcwebserviceext1.abh.com.tr/SapRFCWebService/services/RFCService"
    //recieveing
    NSMutableData *webData;
    
    //delegation attribute
    id<ABHSAPHandlerDelegate>delegate;
    
}
@property (nonatomic,retain)id<ABHSAPHandlerDelegate>delegate;
-(id)initWithConnectionUrl:(NSString*)myUrl;
-(void)prepRFCWithHostName:(NSString*)hostName andClient:(NSString*)client andDestination:(NSString*)destination andSystemNumber:(NSString*)systemNumber andUserId:(NSString*)userId andPassword:(NSString*)password andRFCName:(NSString*)RFCName;
-(void)addImportWithKey:(NSString*) key andValue:(NSString*)value;
-(void)addTableWithName:(NSString*)tableName  andColumns:(NSMutableArray*)columns;
-(void)prepTableWithTables:(NSMutableArray*)myTables;
-(void)prepImportWithImports:(NSMutableArray*)myImports;
-(void)prepCall;

//r3 ztssu4 rapor 8124
@end
@protocol ABHSAPHandlerDelegate
-(void)getResponseWithString:(NSString*)myResponse;

@end
