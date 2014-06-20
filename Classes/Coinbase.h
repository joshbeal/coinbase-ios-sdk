//
//  Coinbase.h
//  Handshake
//
//  Created by Josh Beal on 11/11/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBAccount.h"

FOUNDATION_EXPORT NSString *const CB_AUTHCODE_NOTIFICATION_TYPE;
FOUNDATION_EXPORT NSString *const CB_AUTHCODE_URL_KEY;

typedef void (^AccountHandler)(CBAccount *account, NSError *error);
typedef void (^LoginHandler)(NSError *error);

@interface Coinbase : NSObject

+ (BOOL)isAuthenticated;

+ (NSString *)getClientId;
+ (NSString *)getClientSecret;
+ (NSString *)getCallbackUrl;

+ (void)setClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

+ (void)login:(LoginHandler)handler;
+ (void)loginWithScope:(NSArray *)permissions withHandler:(LoginHandler)handler;
+ (void)logout;

+ (void)handleUrl:(NSURL *)url;

+ (void)getAccount:(AccountHandler)handler;

@end
