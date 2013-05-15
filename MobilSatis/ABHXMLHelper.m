//
//  ABHXMLHelper.m
//  CrmServisPrototype
//
//  Created by ABH on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ABHXMLHelper.h"

@implementation ABHXMLHelper
+ (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    return htmlString;
}
+ (NSString*)htmlToText:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    // I 
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#x15E;" withString:@"Ş"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#x131;" withString:@"ı"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#xD6;" withString:@"Ö"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#x11E;" withString:@"Ğ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#x130;" withString:@"İ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#xDC;" withString:@"Ü"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#xC7;" withString:@"Ç"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#xE7;" withString:@"ç"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#x11F;" withString:@"ğ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#x15F;" withString:@"ş"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#xF6;" withString:@"ö"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#xFC;" withString:@"ü"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\\U015e" withString:@"S"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\\U0130" withString:@"I"];
    return htmlString;
    
}

+ (NSMutableArray*)getValuesWithTag:(NSString*)aTag fromEnvelope:(NSString*)anEnvelope{
    anEnvelope = [self htmlToText:anEnvelope];
    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    NSString *openTag = [NSString stringWithFormat:@"<%@>",aTag];
    NSString *closeTag = [NSString stringWithFormat:@"</%@>",aTag];
    NSMutableArray *components = [NSMutableArray arrayWithArray:[anEnvelope componentsSeparatedByString:openTag]];
	[components removeObjectAtIndex:0];
	for (NSString *component in components)
		[valueList addObject:[self clearSpacesFromString:[[component componentsSeparatedByString:closeTag] objectAtIndex:0]]];
    
    if ([valueList count] == 0) {
       //wierd
    //NSLog(anEnvelope);
    }
    return valueList;
}

+ (NSString *)clearSpacesFromString:(NSString*)aString{

    return [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+ (BOOL)hasThisTag:(NSString*)tag fromfromEnvelope:(NSString*)anEnvelope{

    NSString *myTag = [NSString stringWithFormat:@"<%@>",tag];
    NSRange range = [anEnvelope rangeOfString:myTag];
    if (range.location == NSNotFound) {
        return false;
    }
    return true;
}

+ (NSString*)correctNumberValue:(NSString*)numberValue{
    NSString *returnValue;
    NSArray *array = [numberValue componentsSeparatedByString:@"."];
    @try{
            returnValue = [array objectAtIndex:0];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        returnValue = [numberFormatter stringFromNumber:[numberFormatter numberFromString:returnValue]];
       // NSLog(@"%@",returnValue);
    }
    @catch (NSException *ex) {
        
    }
  //  NSNumberFormatter *temp = [NSNumberFormatter numberFromString:returnValue];
    return returnValue;
    
}
@end
