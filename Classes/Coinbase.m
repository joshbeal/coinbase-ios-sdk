//
//  Coinbase.m
//  Handshake
//
//  Created by Josh Beal on 11/11/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import "Coinbase.h"
#import "CBRequest.h"
#import "CBTokens.h"

NSString *const CB_AUTH_CODE_NOTIFICATION_TYPE = @"CB_AUTHCODE_NOTIFICATION";
NSString *const CB_AUTH_CODE_URL_KEY = @"CB_AUTHCODE_URL";

static BOOL isAuthenticated = NO;
static NSString* _clientId;
static NSString* _clientSecret;
static LoginHandler loginBlock;
static NSString *permissionsList;

@interface Coinbase ()
+ (void)getAuthCode:(NSString *)scope;
@end

@implementation Coinbase

+ (BOOL)isAuthenticated {
    return isAuthenticated;
}

+ (NSString *)getClientId {
    return _clientId;
}

+ (NSString *)getClientSecret {
    return _clientSecret;
}

+ (NSString *)getCallbackUrl {
    return @"urn:ietf:wg:oauth:2.0:oob";
}

+ (void)setClientId:(NSString* )clientId clientSecret:(NSString *)clientSecret {
    _clientId = clientId;
    _clientSecret = clientSecret;
}

+ (void)login:(LoginHandler)handler {
    loginBlock = handler;
    permissionsList = @"all";
    if ([CBTokens authCode]) {
        [self getAccessToken:permissionsList];
    } else {
        [self getAuthCode:permissionsList];
    }
}

+ (void)loginWithScope:(NSArray *)permissions withHandler:(LoginHandler)handler {
    loginBlock = handler;
    permissionsList = [permissions componentsJoinedByString:@"+"];
    if ([CBTokens authCode]) {
        [self getAccessToken:permissionsList];
    } else {
        [self getAuthCode:permissionsList];
    }
}

+ (void)logout {
    [CBTokens resetTokens];
    isAuthenticated = NO;
}

+ (void)getAccessToken:(NSString*)permissions {
    
    NSString *authCode = [CBTokens authCode];
    NSString *refreshToken = [CBTokens refreshToken];
    
    if ([CBTokens expiryTime] == nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@", authCode, [Coinbase getCallbackUrl], [Coinbase getClientId], [Coinbase getClientSecret]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@", JSON);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [CBTokens setAccessToken:[JSON objectForKey:@"access_token"]];
                [CBTokens setRefreshToken:[JSON objectForKey:@"refresh_token"]];
                double expiryTime = [[NSDate date] timeIntervalSince1970] + 7200;
                [CBTokens setExpiryTime:[NSNumber numberWithDouble:expiryTime]];
                isAuthenticated = YES;

                loginBlock(nil);
            });

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            loginBlock(error);
        }];
    
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@", refreshToken, [Coinbase getClientId], [Coinbase getClientSecret]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@", JSON);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [CBTokens setAccessToken:[JSON objectForKey:@"access_token"]];
                [CBTokens setRefreshToken:[JSON objectForKey:@"refresh_token"]];
                double expiryTime = [[NSDate date] timeIntervalSince1970] + 7200;
                [CBTokens setExpiryTime:[NSNumber numberWithDouble:expiryTime]];
                isAuthenticated = YES;

                loginBlock(nil);
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            loginBlock(error);
        }];
    }
}

+ (void)getAuthCode:(NSString *)scope {
    [[NSNotificationCenter defaultCenter] postNotificationName:CB_AUTH_CODE_NOTIFICATION_TYPE object:nil userInfo:@{CB_AUTH_CODE_URL_KEY:[NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/oauth/authorize?response_type=code&client_id=%@&redirect_uri=%@&scope=%@", [Coinbase getClientId], [Coinbase getCallbackUrl], scope]]}];
}

+ (void)registerAuthCode:(NSString *)authCode {
    [CBTokens setAuthCode:authCode];
    [self getAccessToken:permissionsList];
}

+ (void)getAccount:(AccountHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager GET:[NSString stringWithFormat:@"https://api.coinbase.com/v1/users/self?access_token=%@", [CBTokens accessToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {

                NSDictionary *user = [JSON objectForKey:@"user"];
                
                CBAccount *account = [[CBAccount alloc] init];
                account.name = [user objectForKey:@"name"];
                account.email = [user objectForKey:@"email"];
                account.balance = [[user objectForKey:@"balance"] objectForKey:@"amount"];
                account.timeZone = [user objectForKey:@"time_zone"];
                account.cbId = [user objectForKey:@"id"];
                account.buyLevel = [user objectForKey:@"buy_level"];
                account.buyLimit = [[user objectForKey:@"buy_limit"] objectForKey:@"amount"];
                account.sellLevel = [user objectForKey:@"sell_level"];
                account.sellLimit = [[user objectForKey:@"sell_limit"] objectForKey:@"amount"];
                
                handler(account, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                handler(nil, error);
            }];
        }
    }];
}

@end
