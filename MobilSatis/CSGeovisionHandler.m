#import "CSGeovisionHandler.h"

@implementation CSGeovisionHandler
@synthesize webData;

NSString *geovisionHostName = @"http://92.45.120.118:8082/EfesWS/EfesWS?";
NSString *geovisionUsername = @"un=efes.abh";
NSString *geovisionPassword = @"&ps=3f3sAbhC00rTo6vg";

+(NSString *)sendCoordinatesToGeovisionFromUser:(CSUser*)aUser andCustomer:(CSCustomer*)aCustomer andOldLocation:(CLLocationCoordinate2D)oldLocation andNewLocation:(CLLocationCoordinate2D)newLocation andText:(NSString*)text{
    NSString *jsonObjectString = [NSString stringWithFormat:@"&object={"
                                  "\"deneme\":{\"IPHONE_X\":\"%f\",\"IPHONE_Y\":\"%f\",\"MUSTERI_KODU"
                                  "\":\"%@\",\"PANORAMA_X\":\"%f\",\"PANORAMA_Y\":\"%f\",\"USERID\":\"%@\",\"ACIKLAMA\":\"%@\"}}",newLocation.longitude,newLocation.latitude,aCustomer.kunnr,oldLocation.longitude,oldLocation.latitude,aUser.username,text];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@",geovisionHostName,geovisionUsername,geovisionPassword,jsonObjectString];
    urlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *errorReturned = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
    
    NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *resultString = [resultData objectForKey:@"Operation"];
    
    return resultString;
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
    
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

@end
