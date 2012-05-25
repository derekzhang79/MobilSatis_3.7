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
NSString *hostName = @"SRECTS081"; //test-10.12.1.188
//NSString *hostName =@"10.12.1.179"; //canli

//NSString *client = @"300"; //canli
NSString *client = @"100";
//NSString *destination = @"ECP300CLNT";
NSString *destination = @"CLNT100";//CLNT100	
NSString *systemNumber = @"00";
NSString *userId = @"MOBIL";
NSString *password = @"12345678";

NSString *R3hostName = @"10.12.253.2"; //test-10.12.1.188

NSString *R3client = @"330";
//NSString *destination = @"ECP300CLNT";
NSString *R3destination = @"AGT330";//CLNT100	
NSString *R3systemNumber = @"00";
NSString *R3userId = @"AALPK";
NSString *R3password = @"alpefes2011";



NSString *BWhostName =@"10.12.1.179"; //canli

NSString *BWclient = @"300"; //canli

NSString *BWdestination = @"ECP300CLNT";

NSString *BWsystemNumber = @"00";
NSString *BWuserId = @"MOBIL";
NSString *BWpassword = @"12345678";




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
@end
