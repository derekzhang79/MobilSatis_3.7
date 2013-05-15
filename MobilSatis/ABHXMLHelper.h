//
//  ABHXMLHelper.h
//  CrmServisPrototype
//
//  Created by ABH on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABHXMLHelper : NSObject
+ (NSString*)textToHtml:(NSString*)htmlString;

+ (NSString*)htmlToText:(NSString*)htmlString ;
+ (NSMutableArray*)getValuesWithTag:(NSString*)aTag fromEnvelope:(NSString*)anEnvelope;
+ (NSString *)clearSpacesFromString:(NSString*)aString;
+ (BOOL)hasThisTag:(NSString*)tag fromfromEnvelope:(NSString*)anEnvelope;
+ (NSString*)correctNumberValue:(NSString*)numberValue;

@end
