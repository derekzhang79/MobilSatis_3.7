//
//  ESatisHandler.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 09.05.2013.
//
//

#import "ESatisHandler.h"

@implementation ESatisHandler
@synthesize delegate;


-(id)init{
    
    self = [super self];
    
    header = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\""
              " xmlns:bean=\"http://beans.webservice.esatis.elikasu.com\">"
              
              "<soapenv:Header/>"
              
              "<soapenv:Body>"];
    
    footer = [NSString stringWithFormat:@"</soapenv:Body>"
              
              "</soapenv:Envelope>"];
    
    return self;
    
}

-(id)initWithConnectionUrl:(NSString*)myUrl{
    
    self = [self init];
    
    connectionUrl = myUrl;
    
    return self;
    
}

-(void)prepCallToGetMusteriRiskBilgileri:(NSString *)i_kunnr {
    NSString *methodName = @"<bean:getMusteriRiskBilgileri>";
    NSString *importParameter = [NSString stringWithFormat:@"<bean:musteriNo>%@</bean:musteriNo>", i_kunnr];
    NSString *endMethodName = @"</bean:getMusteriRiskBilgileri>";
    
    import = [NSString stringWithFormat:@"%@%@%@", methodName, importParameter, endMethodName];
    
    [self prepCall];
}

-(void)prepCallToGetMasrafYeriRiskBilgileri:(NSString *)i_sapUser {
    NSString *methodName = @"<bean:getMasrafYeriRiskBilgileri>";
    NSString *importParameter = [NSString stringWithFormat:@"<bean:sapUserName>%@</bean:sapUserName>", i_sapUser];
    NSString *endMethodName = @"</bean:getMasrafYeriRiskBilgileri>";
    
    import = [NSString stringWithFormat:@"%@%@%@", methodName, importParameter, endMethodName];
}

- (void)prepCallToGetMudurlukMasrafYeriRiskBilgileri:(NSString *)i_mudurluk :(NSString *)i_sapUser {
    NSString *methodName = @"<bean:getMudurlukMasrafYeriRiskBilgileri>";
    NSString *importParameter1 = [NSString stringWithFormat:@"<bean:sapUserName>%@</bean:sapUserName>", i_sapUser];
    NSString *importParameter2 = [NSString stringWithFormat:@"<bean:mudurlukNo>%@</bean:mudurlukNo>", i_mudurluk];
    NSString *endMethodName = @"</bean:getMudurlukMasrafYeriRiskBilgileri>";

    import = [NSString stringWithFormat:@"%@%@%@%@", methodName, importParameter1, importParameter2, endMethodName];
}


-(void) prepCall {
    
    soapMsg = [NSString stringWithFormat:@"%@%@",header, import];
    
    soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,footer];
    
    
    
    NSMutableURLRequest *soapReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:connectionUrl]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d" , [soapMsg length]];
    
    [soapReq addValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [soapReq addValue:@"" forHTTPHeaderField:@"SOAPAction"];
    
    [soapReq addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [soapReq setHTTPMethod:@"POST"];
    
    [soapReq setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:soapReq delegate:self];
    
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
    [delegate getResponseFromSOAP:response];
    
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}
@end
