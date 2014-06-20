//
//  Coinbase.m
//  Handshake
//
//  Created by Josh Beal on 11/11/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import "Coinbase.h"
#import "CBRequest.h"

NSString *const CB_AUTHCODE_NOTIFICATION_TYPE = @"CB_AUTHCODE_NOTIFICATION";
NSString *const CB_AUTHCODE_URL_KEY = @"CB_AUTHCODE_URL";

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
    return [NSString stringWithFormat:@"cb%@%%3A%%2F%%2Fauthorize", [Coinbase getClientId]];
}

+ (void)setClientId:(NSString* )clientId clientSecret:(NSString *)clientSecret {
    _clientId = clientId;
    _clientSecret = clientSecret;
}

+ (void)login:(LoginHandler)handler {
    loginBlock = handler;
    permissionsList = @"all";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authCode"]) {
        [self getAccessToken:permissionsList];
    } else {
        [self getAuthCode:permissionsList];
    }
}

+ (void)loginWithScope:(NSArray *)permissions withHandler:(LoginHandler)handler {
    loginBlock = handler;
    permissionsList = [permissions componentsJoinedByString:@"+"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authCode"]) {
        [self getAccessToken:permissionsList];
    } else {
        [self getAuthCode:permissionsList];
    }
}

+ (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refreshToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"expiryTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authCode"];
    isAuthenticated = NO;
}

+ (void)getAccessToken:(NSString*)permissions {
    
    NSString *authCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"authCode"];
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshToken"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"expiryTime"] == nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@", authCode, [Coinbase getCallbackUrl], [Coinbase getClientId], [Coinbase getClientSecret]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@", JSON);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"access_token"] forKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"refresh_token"] forKey:@"refreshToken"];
                double expiryTime = [[NSDate date] timeIntervalSince1970] + 7200;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:expiryTime] forKey:@"expiryTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
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
                [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"access_token"] forKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"refresh_token"] forKey:@"refreshToken"];
                double expiryTime = [[NSDate date] timeIntervalSince1970] + 7200;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:expiryTime] forKey:@"expiryTime"];
                isAuthenticated = YES;

                loginBlock(nil);
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            loginBlock(error);
        }];
    }
}

+ (void)getAuthCode:(NSString *)scope {
    [[NSNotificationCenter defaultCenter] postNotificationName:CB_AUTHCODE_NOTIFICATION_TYPE object:nil userInfo:@{CB_AUTHCODE_URL_KEY:[NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/oauth/authorize?response_type=code&client_id=%@&redirect_uri=%@&scope=%@", [Coinbase getClientId], [Coinbase getCallbackUrl], scope]]}];
}

+ (NSString *)apiToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
}

+ (void)handleUrl:(NSURL *)url {
    NSArray *components =[[url description] componentsSeparatedByString:@"?"];
    NSString *authCode = [[components objectAtIndex:1] substringFromIndex:5];
    [[NSUserDefaults standardUserDefaults] setObject:authCode forKey:@"authCode"];
    [self getAccessToken:permissionsList];
}

+ (void)getAccount:(AccountHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager GET:[NSString stringWithFormat:@"https://coinbase.com/api/v1/users?access_token=%@", [self apiToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {

                CBAccount *account = [[CBAccount alloc] init];
                account.name = [[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"name"];
                account.email = [[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"email"];
                account.balance = [[[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"balance"] objectForKey:@"amount"];
                account.timeZone = [[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"time_zone"];
                account.cbId = [[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"id"];
                account.buyLevel = [[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"buy_level"];
                account.buyLimit = [[[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"buy_limit"] objectForKey:@"amount"];
                account.sellLevel = [[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"sell_level"];
                account.sellLimit = [[[[[JSON objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"sell_limit"] objectForKey:@"amount"];
                
                handler(account, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                handler(nil, error);
            }];
        }
    }];
}

@end
