//
//  ABHConnectionInfo.h
//  CrmServisPrototype
//
//  Created by ABH on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABHConnectionInfo : NSObject{
    
    
    
}

+(NSString*) getConnectionUrl;
+(NSString*) getHostName;
+(NSString*) getClient;
+(NSString*) getDestination;
+(NSString*) getSystemNumber;
+(NSString*) getUserId;
+(NSString*) getPassword;

+(NSString*) getR3ConnectionUrl;
+(NSString*) getR3HostName;
+(NSString*) getR3Client;
+(NSString*) getR3Destination;
+(NSString*) getR3SystemNumber;
+(NSString*) getR3UserId;
+(NSString*) getR3Password;



+(NSString*) getBWConnectionUrl;
+(NSString*) getBWHostName;
+(NSString*) getBWClient;
+(NSString*) getBWDestination;
+(NSString*) getBWSystemNumber;
+(NSString*) getBWUserId;
+(NSString*) getBWPassword;

+(NSString*) getPanaromaUsername;
+(NSString*) getPanaromaPassword;
+(NSString*) getPanaromaWorkYear;
+(NSString*) getPanaromaCompanyCode;
+(NSString*) getPanaromaDistrubutionCode;

+(void) setHostName:(NSString*)newHostName;
+(void) setSystemNumeber:(NSString*)newSystemNumber;
@end
