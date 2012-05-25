//
//  CSPanoramaHandler.h
//  MobilSatis
//
//  Created by ABH on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CSPanoramaHandlerDelegate;
@interface CSPanoramaHandler : NSObject{


    NSString *header;
    NSString *config;
    NSString *import;
    NSString *table;
    NSString *footer;

    NSString *companyCodeLine;
    NSString *workYearLine;
    NSString *distributionCodeLine;
    NSString *usernameLine;
    NSString *passwordLine;
    NSString *staticEndLine;
    NSMutableArray *imports;
    NSMutableArray *tables;
    
    //beware the mighty!!
    NSString *soapMsg;
    
    //config only
    NSString *connectionUrl;  
    //recieveing
    NSMutableData *webData;
    
    //delegation attribute
    id<CSPanoramaHandlerDelegate>delegate;
    
}
@property (nonatomic,retain)id<CSPanoramaHandlerDelegate>delegate;
-(id)initWithConnectionUrl:(NSString*)myUrl;
-(void)prepRFCWithHostName:(NSString*)hostName andClient:(NSString*)client andDestination:(NSString*)destination andSystemNumber:(NSString*)systemNumber andUserId:(NSString*)userId andPassword:(NSString*)password andRFCName:(NSString*)RFCName;
-(void)addImportWithKey:(NSString*) key andValue:(NSString*)value;
-(void)addTableWithName:(NSString*)tableName  andColumns:(NSMutableArray*)columns;
-(void)prepTableWithTables:(NSMutableArray*)myTables;
-(void)prepImportWithImports:(NSMutableArray*)myImports;
-(void)prepCall;
@end
@protocol CSPanoramaHandlerDelegate
-(void)getPanoramaResponseWithString:(NSString*)myResponse;

@end
