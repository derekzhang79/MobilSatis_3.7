//
//  ESatisHandler.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 09.05.2013.
//
//

#import <Foundation/Foundation.h>
#import "ABHXMLHelper.h"

@protocol ESatisHandlerDelegate;

@interface ESatisHandler : NSObject
{
    NSString *header;
    NSString *import;
    NSString *footer;
    NSString *soapMsg;
    NSString *connectionUrl;
    NSMutableData *webData;
    id<ESatisHandlerDelegate> delegate;
}
@property (nonatomic,retain)id<ESatisHandlerDelegate> delegate;

- (id)initWithConnectionUrl:(NSString*)myUrl;

- (void)prepCallToGetMusteriRiskBilgileri:(NSString *)i_kunnr;

- (void)prepCallToGetMasrafYeriRiskBilgileri:(NSString *)i_sapUser;

- (void)prepCallToGetMudurlukMasrafYeriRiskBilgileri:(NSString *)i_mudurluk :(NSString *)i_sapUser;

- (void)prepCall;


@end
@protocol ESatisHandlerDelegate

- (void)getResponseFromSOAP:(NSString*)myResponse;

@end
