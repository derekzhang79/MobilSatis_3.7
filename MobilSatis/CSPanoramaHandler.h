//

//  CSPanoramaHandler.h

//  MobilSatis

//

//  Created by alp keser on 5/16/12.

//  Copyright (c) 2012 ABH. All rights reserved.

//



#import <Foundation/Foundation.h>

#import "ABHConnectionInfo.h"
#import "ABHXMLHelper.h"
@protocol CSPanoramaHandlerDelegate;
/*
 
 wsdl : http://efesws.efespilsen.com.tr:9092/integrationwebservice.asmx?wsdl
 service : http://efesws.efespilsen.com.tr:9092/integrationwebservice.asmx
 */

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
    
    NSString *staticBeginLine;
    
    NSString *changeFiledsLine;
    
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

-(void)prepCallWithUsername:(NSString*)username andPassword:(NSString*)password andWorkYear:(NSString*)workYear andCompanyCode:(NSString*)companyCode andDistributionCode:(NSString*)distributionCode;

-(void)addChangeFields:(NSMutableArray*)fieldNames;

-(void)addImportWithKey:(NSString*) key andValue:(NSString*)value;

-(void)addTableWithName:(NSString*)tableName  andColumns:(NSMutableArray*)columns;

-(void)prepTableWithTables:(NSMutableArray*)myTables;

-(void)prepImportWithImports:(NSMutableArray*)myImports;

-(void)prepCall;

@end

@protocol CSPanoramaHandlerDelegate

-(void)getPanoramaResponseWithString:(NSString*)myResponse;



@end