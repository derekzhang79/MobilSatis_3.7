//
//  ABHSAPHandler.m
//  CrmServisPrototype
//
//  Created by ABH on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ABHSAPHandler.h"
#import "ABHXMLHelper.h"
@implementation ABHSAPHandler
@synthesize delegate, RFCNameLine;

-(id)init{
    self = [super self];
    header = [NSString stringWithFormat:@"<soapenv:Envelope "
              "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
              "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
              "xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
              "xmlns:web=\"http://webService.abh.com\" "
              "xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\">"
              "<soapenv:Header/>"
              "<soapenv:Body>"
              "<web:callSapRFCByName2XML soapenv:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"];
    footer = [NSString stringWithFormat:@"</web:callSapRFCByName2XML>"
              "</soapenv:Body>"
              "</soapenv:Envelope>"];
    
    return self;
}

-(id)initWithConnectionUrl:(NSString*)myUrl{
    self = [self init];
    connectionUrl = [NSString stringWithFormat:myUrl];
    return self;
}

-(void)prepRFCWithHostName:(NSString*)hostName andClient:(NSString*)client andDestination:(NSString*)destination andSystemNumber:(NSString*)systemNumber andUserId:(NSString*)userId andPassword:(NSString*)password andRFCName:(NSString*)RFCName {
    
    
    hostNameLine = [NSString stringWithFormat:@"%@%@%@",@"<hostName xsi:type=\"xsd:string\">",hostName,@"</hostName>"];
    clientLine = [NSString stringWithFormat:@"%@%@%@",@"<client xsi:type=\"xsd:string\">",client,@"</client>"];
    destinationLine = [NSString stringWithFormat:@"%@%@%@",@"<destination xsi:type=\"xsd:string\">",destination,@"</destination>"];
    systemNumberLine = [NSString stringWithFormat:@"%@%@%@",@"<systemNumber xsi:type=\"xsd:string\">",systemNumber,@"</systemNumber>"];
    userIdLine = [NSString stringWithFormat:@"%@%@%@",@"<userId xsi:type=\"xsd:string\">",userId,@"</userId>"];
    passwordLine = [NSString stringWithFormat:@"%@%@%@",@"<password xsi:type=\"xsd:string\">",password,@"</password>"];
    RFCNameLine = [NSString stringWithFormat:@"%@%@%@",@"<rfcName xsi:type=\"xsd:string\">",RFCName,@"</rfcName>"];
    config = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",hostNameLine,clientLine,destinationLine,systemNumberLine,userIdLine,passwordLine,RFCNameLine];
    
}

-(void)addImportWithKey:(NSString*) key andValue:(NSString*)value{
    if (imports == nil) {
        imports = [[NSMutableArray alloc] init];
    }
    [imports addObject:@"<p1 xsi:type=\"mod:Parameter\">"];
    [imports addObject:[NSString stringWithFormat:@"%@%@%@",@"<key xsi:type=\"xsd:string\">",key,@"</key>"]];
    [imports addObject:[NSString stringWithFormat:@"%@%@%@",@"<value xsi:type=\"xsd:string\">",value,@"</value>"]];
    [imports addObject:@"</p1>"];
    
}
-(void)addTableWithName:(NSString*)tableName  andColumns:(NSMutableArray*)columns{
    BOOL returnTable = YES;
    if(tables == nil){
        tables = [[NSMutableArray alloc] init];
    }
    NSString *aTable = [NSString stringWithFormat:@"<t1 xsi:type=\"mod:ABHSapTable\"><columnNames xsi:type=\"impl:ArrayOf_xsd_string\">"];
    for (id column in columns) {
        aTable = [NSString stringWithFormat:@"%@%@%@%@",aTable,@"<cn xsi:type=\"xsd:string\">",column,@"</cn>"];
    }
    aTable = [NSString stringWithFormat:@"%@%@%@%@%@%@",aTable,@"</columnNames><name xsi:type=\"xsd:string\">",tableName,@"</name><returnTable xsi:type=\"xsd:boolean\">",@"TRUE",@"</returnTable></t1>"];
    [tables addObject:aTable];
    
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
    import = [NSString stringWithFormat:@"%@%@%@",@"<ippParams xsi:type=\"web:ArrayOf_tns1_Parameter\" soapenc:arrayType=\"mod:Parameter[]\" xmlns:mod=\"http://model.system.abh.com\">",body,@"</ippParams>"];
    
}

-(void)prepTableWithTables:(NSMutableArray*)myTables{
    if([myTables count] == 0){
        return;
    }
    table = [NSString stringWithFormat:@"<rfcTables xsi:type=\"web:ArrayOf_tns1_ABHSapTable\" soapenc:arrayType=\"mod:ABHSapTable[]\" xmlns:mod=\"http://model.system.abh.com\">"];
    for(id aTable in tables){
        table = [NSString stringWithFormat:@"%@%@",table,aTable];
    }
    table=[NSString stringWithFormat:@"%@%@",table,@"</rfcTables>"];

    
    
}

-(void)prepCall{
    
    if ([CoreDataHandler isInternetConnectionNotAvailable]) {
        NSLog(@"Internet yoh");
        [delegate getResponseWithString:@"" andSender:self];
        return;
    }
    
    [self prepImportWithImports:imports];
    [self prepTableWithTables:tables];
    soapMsg = [NSString stringWithFormat:@"%@%@",header,config];
    if([import length] !=0)
    {
        soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,import];
    }
    if ([table length] != 0) {
        soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,table];
    }
    soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,footer];
    
     NSMutableURLRequest *soapReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:connectionUrl]];
     NSString *msgLength = [NSString stringWithFormat:@"%d" , [soapMsg length]];
     [soapReq addValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
     [soapReq addValue:@"http://webService.abh.com/RFCService" forHTTPHeaderField:@"SOAPAction"];
     [soapReq addValue:msgLength forHTTPHeaderField:@"Content-Length"];
     [soapReq setHTTPMethod:@"POST"];
    //for viewing message that goes in connection -alp
     //NSLog(@"%@",soapMsg);
     [soapReq setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
     NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:soapReq delegate:self];
     
     
     
}

//delegation methods
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//    NSLog(@"lookin for credentials... there is authentication you know probably proxy");
//}

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
    [delegate getResponseWithString:response andSender:self];

}

@end
