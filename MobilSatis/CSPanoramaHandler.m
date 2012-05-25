//
//  CSPanoramaHandler.m
//  MobilSatis
//
//  Created by ABH on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSPanoramaHandler.h"
#import "ABHSAPHandler.h"
@implementation CSPanoramaHandler
@synthesize delegate;
-(id)init{
    self = [super self];
    header = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"" "xmlns:int=\"http://integration.univera.com.tr\">"
              "<soapenv:Header/>"
              "<soapenv:Body>"
              "<int:IntegrationSendEntitySetWithLogin>"];
    footer = [NSString stringWithFormat:@"</int:clsMusteriIntegration>"
              "</int:Musteriler>"
              "</int:objPanIntEntityList>"
              "</int:IntegrationSendEntitySetWithLogin>"
              "</soapenv:Body>"
              "</soapenv:Envelope>"];
    
    return self;
}
-(id)initWithConnectionUrl:(NSString*)myUrl{
    self = [self init];
    connectionUrl = [NSString stringWithFormat:myUrl];
    return self;
}

-(void)prepCallWithUsername:(NSString*)username andPassword:(NSString*)password andWorkYear:(NSString*)workYear andCompanyCode:(NSString*)companyCode andDistributionCode:(NSString*)distributionCode{
    usernameLine = [NSString stringWithFormat:@"%@%@%@",@"<int:strUserName>",username,@"</int:strUserName>"];
    passwordLine = [NSString stringWithFormat:@"%@%@%@",@"<int:strPassWord>",password,@"</int:strPassWord>"];
    companyCodeLine = [NSString stringWithFormat:@"%@%@%@",@"<int:bytFirmaKod>",companyCode,@"</int:bytFirmaKod>"];
    workYearLine = [NSString stringWithFormat:@"%@%@%@",@"<int:lngCalismaYili>",workYear,@"</int:lngCalismaYili>"];
    distributionCodeLine = [NSString stringWithFormat:@"%@%@%@",@"<int:lngDistributorKod>",distributionCode,@"</int:lngDistributorKod>"];
    staticEndLine = [NSString stringWithFormat:@"<int:Musteriler>"
                     "<int:clsMusteriIntegration>"];
    config = [NSString stringWithFormat:@"%@%@%@%@%@%@",usernameLine,passwordLine,companyCodeLine,workYearLine,distributionCodeLine,staticEndLine];
    
}

@end
