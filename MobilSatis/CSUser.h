//
//  CSUser.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMapPoint.h"
@interface CSUser : NSObject {
    NSString *username;
    NSString *password;
    NSString *name;
    NSString *surname;
    NSString *mail;
    NSString *sapUser;
    NSString *javaPassword;
    NSMutableArray *customers;
    NSMutableArray *dealers;
    CSMapPoint *location;
}
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *surname;
@property (nonatomic,retain) NSString *mail;
@property (nonatomic,retain) NSMutableArray *customers;
@property (nonatomic,retain) NSMutableArray *dealers;
@property (nonatomic,retain) CSMapPoint *location;
@property (nonatomic, retain) NSString *sapUser;
@property (nonatomic, retain) NSString *javaPassword;



@end
