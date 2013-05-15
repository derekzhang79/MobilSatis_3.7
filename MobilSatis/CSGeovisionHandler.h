//
//  CSGeovisionHandler.h
//  MobilSatis
//
//  Created by alp keser on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import "CSUser.h"
#import "CSCustomer.h"
#import "ABHXMLHelper.h"
/*
 NSString *urlString = [NSString stringWithFormat:@"http://92.45.120.118:8082/EfesWS/EfesWS?"
 "un=efes.abh&ps=3f3sAbhC00rTo6vg&object={"
 "\"deneme\":{\"IPHONE_X\":\"44\",\"IPHONE_Y\":\"44\",\"MUSTERI_KODU"
 "\":\"0001323475\",\"PANORAMA_X\":\"30\",\"PANORAMA_Y\":\"30\",\"USERID\":\"alpkeseriPhone2\"}}"];
 //    urlString =[urlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
 urlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSURL *url = [NSURL URLWithString:urlString];
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 NSError *errorReturned = nil;
 CSUser *user = [[CSUser alloc] init];
 [user setName:@"alpkesertest"];
 CSCustomer *customer = [[CSCustomer alloc] init];
 [customer setKunnr:@"0001323475"];
 CLLocationCoordinate2D old;
 old.latitude = 29;
 old.longitude = 30;
 CLLocationCoordinate2D new;
 new.latitude = 31;
 new.longitude = 32;
 [CSGeovisionHandler sendCoordinatesToGeovisionFromUser:user andCustomer:customer andOldLocation:old andNewLocation:new andText:@"açıklama satırı"]; */
@interface CSGeovisionHandler : NSObject {
    NSMutableData *webData;

}

@property (nonatomic, retain) NSMutableData *webData;

+(NSString *)sendCoordinatesToGeovisionFromUser:(CSUser*)aUser andCustomer:(CSCustomer*)aCustomer andOldLocation:(CLLocationCoordinate2D)oldLocation andNewLocation:(CLLocationCoordinate2D)newLocation andText:(NSString*)text;
@end
//
//  CSGeovisionHandler.m
//  MobilSatis
//
//  Created by alp keser on 8/25/12.
//
//

