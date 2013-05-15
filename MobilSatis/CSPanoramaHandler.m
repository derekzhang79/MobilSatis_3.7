//

//  CSPanoramaHandler.m

//  MobilSatis

//

//  Created by ABH on 5/16/12.

//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//



/* sample form univera
 
 
 
 .DistReferans = "00004", _
 
 .MerkezKod = "00004M0001", _
 
 .Durum = 2, _
 
 .IptalNeden = 3, _
 
 .Cadde = "cadde", _
 
 .Sokak = "sokak", _
 
 .KapiNo = "kapı no", _
 
 .Mahalle = "mahalle", _
 
 .PostaKod = "posta kod", _
 
 .MerkezIlReferans = "35", _
 
 .MerkezIlceReferans = "ALİAĞA", _
 
 .MerkezSemtTextKod = "KONAK", _
 
 .VergiDairesiKod = 1, _
 
 .VN = "1234567890", _
 
 .RuhsatDaire = "RUHSAT DAİRE", _
 
 .RuhsatNo = "RUHSAT NO", _
 
 .MusteriGrupReferans = "01", _
 
 .MusteriEkGrupReferans = "03", _
 
 .MusOzel = "3", _
 
 .MusteriPO = "1", _
 
 .MusteriKonumGrubu = "3", _
 
 .YazarKasa = "15", _
 
 .AcikMetreKare = "550", _
 
 .KapaliMKare = "400" }
 
 */



#import "CSPanoramaHandler.h"

#import "ABHSAPHandler.h"

@implementation CSPanoramaHandler

@synthesize delegate;

-(id)init{
    
    self = [super self];
    
    header = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\""
              " xmlns:int=\"http://integration.univera.com.tr\">"
              
              "<soapenv:Header/>"
              
              "<soapenv:Body>"
              
              "<int:IntegrationSendEntitySetWithLogin>"];
    
    footer = [NSString stringWithFormat:@"</int:clsEfesMusteriIntegration>"
              
              "</int:EfesMusteriler>"
              
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
    
    staticBeginLine = [NSString stringWithFormat:@"<int:objPanIntEntityList>"
                       
                       "<int:EfesMusteriler>"
                       
                       "<int:clsEfesMusteriIntegration>"];
    
    config = [NSString stringWithFormat:@"%@%@%@%@%@%@",usernameLine,passwordLine,companyCodeLine,workYearLine,distributionCodeLine,staticBeginLine];
    
    
    
}

//gerek yokmuş yollanmayacak- alp

-(void)addChangeFields:(NSMutableArray*)fieldNames{
    
    for (int sayac; sayac < fieldNames.count; sayac++) {
        
        if (changeFiledsLine == nil) {
            
            changeFiledsLine = [NSString stringWithFormat:@"<int:string>%@<int>",[fieldNames objectAtIndex:sayac]];
            
        }else{
            
            changeFiledsLine = [NSString stringWithFormat:@"%@<int:string>%@<int>",changeFiledsLine,[fieldNames objectAtIndex:sayac]];
            
        }
        
    }
    
    
    
}

-(void)addImportWithKey:(NSString*) key andValue:(NSString*)value{
    
    if (imports == nil) {
        
        imports = [[NSMutableArray alloc] init];
        
    }
    
    [imports addObject:[NSString stringWithFormat:@"<int:%@>%@</int:%@>",key,value,key]];
    
    
    
    
    
    //aalpk - silincek
    
    //    [imports addObject:@"<p1 xsi:type=\"mod:Parameter\">"];
    
    //    [imports addObject:[NSString stringWithFormat:@"%@%@%@",@"<key xsi:type=\"xsd:string\">",key,@"</key>"]];
    
    //    [imports addObject:[NSString stringWithFormat:@"%@%@%@",@"<value xsi:type=\"xsd:string\">",value,@"</value>"]];
    
    //    [imports addObject:@"</p1>"];
    
    
    
}



-(void)prepCall{
    
    [self prepImportWithImports:imports];
    
    //    [self prepTableWithTables:tables];
    
    soapMsg = [NSString stringWithFormat:@"%@%@",header,config];
    
    if([import length] !=0)
        
    {
        
        soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,import];
        
    }
    
    //    if ([table length] != 0) {
    
    //        soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,table];
    
    //    }
    
    soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,footer];
    
    
    
    NSMutableURLRequest *soapReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:connectionUrl]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d" , [soapMsg length]];
    
    [soapReq addValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [soapReq addValue:@"http://integration.univera.com.tr/IntegrationSendEntitySetWithLogin" forHTTPHeaderField:@"SOAPAction"];
    
    [soapReq addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [soapReq setHTTPMethod:@"POST"];
    
    //for viewing message that goes in connection -alp
    
    //NSLog(@"%@",soapMsg);
    
    [soapReq setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:soapReq delegate:self];
    
    
}



-(void)prepImportWithImports:(NSMutableArray*)myImports{
    
    if ([myImports count] == 0) {
        
        //no import parameter
        
        return;
        
    }
    
    NSString *body;
    
    for (id line in myImports) {
        
        if (body == nil) {
            
            body = [NSString stringWithFormat:@"%@",line];
            
        }
        
        else{
            
            body = [NSString stringWithFormat:@"%@%@",body,line];
            
        }
        
    }
    
    //    import = [NSString stringWithFormat:@"%@%@%@",@"<ippParams xsi:type=\"web:ArrayOf_tns1_Parameter\" soapenc:arrayType=\"mod:Parameter[]\" xmlns:mod=\"http://model.system.abh.com\">",body,@"</ippParams>"];
    
    import = [NSString stringWithFormat:@"%@",body];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    // NSLog(@"Something Recieved!Beware!");
    webData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *response = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    response = [NSString stringWithFormat:@"%@",[ABHXMLHelper htmlToText:response]];
    //NSLog(@"ALPPPPP----->>>>>%@",response);
    [delegate getPanoramaResponseWithString:response];
    
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}
@end