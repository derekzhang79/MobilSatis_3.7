//
//  ABHConnectionInfo.m
//  CrmServisPrototype
//
//  Created by ABH on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ABHConnectionInfo.h"

@implementation ABHConnectionInfo
static NSString *connectionUrl = @"http://saprfcwebserviceext1.abh.com.tr/SapRFCWebService/services/RFCService";
//NSString *hostName = @"10.12.1.188"; //test-10.12.1.188
//NSString *hostName =@"10.12.1.185"; //canli 179
static NSString *hostName =@"10.12.1.179";

NSString *client = @"300"; //canli
//NSString *client = @"100";
NSString *destination = @"ECP300CLNT";
//NSString *destination = @"CLNT100";//CLNT100
static NSString *systemNumber = @"00"; //00
NSString *userId = @"MOBIL";
NSString *password = @"12345678";
//NSString *userId = @"AATAC";
//NSString *password = @"1Q2w3e4r5t";


NSString *R3hostName = @"200.100.32.49";
//49da var test-10.12.1.188  //qa -10.12.253.2
//NSString *R3hostName = @"10.12.253.2";
NSString *R3client = @"330";
//NSString *R3destination = @"AGT330";
NSString *R3destination = @"AGP330";//agt330CLNT100
NSString *R3systemNumber = @"01";
//NSString *R3userId = @"AALPK";
//NSString *R3password = @"alpeylul2012";
NSString *R3userId = @"MOBIL";
NSString *R3password = @"abh12345";


NSString *BWhostName = @"10.12.1.179"; //canli

NSString *BWclient = @"300"; //canli

NSString *BWdestination = @"ECP300CLNT";

NSString *BWsystemNumber = @"01";
NSString *BWuserId = @"MOBIL";
NSString *BWpassword = @"12345678";

NSString *panoramaUsername = @"WEBSERVICE";
NSString *panoramaPassword = @"WEBSERVICE";
NSString *panoramaWorkYear = @"2012";
NSString *panoramaCompanyCode = @"1";
NSString *panoramaDistrubutionCode = @"545";


+(NSString*) getConnectionUrl{
    return connectionUrl;
}

+(NSString*) getHostName{
    return hostName;
}

+(NSString*) getClient{
    return client;
}

+(NSString*) getDestination{
    return destination;
}

+(NSString*) getSystemNumber{
    return systemNumber;
}

+(NSString*) getUserId{
    return userId;
}

+(NSString*) getPassword{
    return password;
}

+(void) setHostName:(NSString*)newHostName{
    hostName = newHostName;
}
+(void) setSystemNumeber:(NSString*)newSystemNumber{
    systemNumber = newSystemNumber;
}


+(NSString*) getR3HostName{
    return R3hostName;
}

+(NSString*) getR3Client{
    return R3client;
}

+(NSString*) getR3Destination{
    return R3destination;
}

+(NSString*) getR3SystemNumber{
    return R3systemNumber;
}

+(NSString*) getR3UserId{
    return R3userId;
}

+(NSString*) getR3Password{
    return R3password;
}

+(NSString*) getBWHostName{
    return BWhostName;
}

+(NSString*) getBWClient{
    return BWclient;
}

+(NSString*) getBWDestination{
    return BWdestination;
}

+(NSString*) getBWSystemNumber{
    return BWsystemNumber;
}

+(NSString*) getBWUserId{
    return BWuserId;
}

+(NSString*) getBWPassword{
    return BWpassword;
}

+(NSString*) getPanaromaUsername{
    return panoramaUsername;
}
+(NSString*) getPanaromaPassword{
    return panoramaPassword;
}
+(NSString*) getPanaromaWorkYear{
    return panoramaWorkYear;
}
+(NSString*) getPanaromaCompanyCode{
    return panoramaCompanyCode;
}
+(NSString*) getPanaromaDistrubutionCode{
    return panoramaDistrubutionCode;
}
@end
