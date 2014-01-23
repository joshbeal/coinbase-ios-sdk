//
//  CBRequest.m
//  Handshake
//
//  Created by Josh Beal on 11/11/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import "CBRequest.h"
#import "Coinbase.h"

@implementation CBRequest
+ (void)authorizedRequest:(CBResponseHandler)handler {
    double currentTime = [[NSDate date] timeIntervalSince1970];
    double expiryTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"expiryTime"] doubleValue];
    if (currentTime >= expiryTime) {
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshToken"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@", refreshToken, [Coinbase getClientId], [Coinbase getClientSecret]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@", JSON);

            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"access_token"] forKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"refresh_token"] forKey:@"refreshToken"];
                double expiryTime = [[NSDate date] timeIntervalSince1970] + 7200;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:expiryTime] forKey:@"expiryTime"];

                handler(JSON, nil);
            });
            
        } failure:nil];
        
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
