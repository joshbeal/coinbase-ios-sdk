//
//  CBRequest.m
//  Handshake
//
//  Created by Josh Beal on 11/11/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import "CBRequest.h"
#import "CBTokens.h"
#import "Coinbase.h"

@implementation CBRequest

static NSMutableArray *queuedAuthHandlers = nil;

+ (void)authorizedRequest:(CBResponseHandler)handler {
    double currentTime = [[NSDate date] timeIntervalSince1970];
    double expiryTime = [[CBTokens expiryTime] doubleValue];
    if (currentTime >= expiryTime) {
        // Refresh is in progress
        if (queuedAuthHandlers) {
            [queuedAuthHandlers addObject:handler];
        } else {
            queuedAuthHandlers = [[NSMutableArray alloc] init];
            [queuedAuthHandlers addObject:handler];
        
            NSString *refreshToken = [CBTokens refreshToken];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@", refreshToken, [Coinbase getClientId], [Coinbase getClientSecret]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
                NSLog(@"%@", JSON);

                dispatch_async(dispatch_get_main_queue(), ^{
                    [CBTokens setAccessToken:[JSON objectForKey:@"access_token"]];
                    [CBTokens setRefreshToken:[JSON objectForKey:@"refresh_token"]];
                    double expiryTime = [[NSDate date] timeIntervalSince1970] + 7200;
                    [CBTokens setExpiryTime:[NSNumber numberWithDouble:expiryTime]];
                    
                    for (CBResponseHandler queuedAuthHandler in queuedAuthHandlers) {
                        queuedAuthHandler(JSON, nil);
                    }
                    queuedAuthHandlers = nil;
                });
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                for (CBResponseHandler queuedHandler in queuedAuthHandlers) {
                    queuedHandler(nil, error);
                }
                queuedAuthHandlers = nil;
            }];
        }
    } else {
        handler(nil, nil); // already authorized
    }
}

+ (void)getRequest:(NSString *)url withHandler:(CBResponseHandler)handler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        handler(JSON, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}
@end
