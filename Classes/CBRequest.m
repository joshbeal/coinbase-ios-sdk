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
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://coinbase.com"]];
        [httpClient setParameterEncoding:AFJSONParameterEncoding];
        
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshToken"];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@", refreshToken, [Coinbase getClientId], [Coinbase getClientSecret]]
                                                          parameters:nil];
        httpClient.parameterEncoding = AFJSONParameterEncoding;
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"access_token"] forKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"refresh_token"] forKey:@"refreshToken"];
            double expiryTime = [[NSDate date] timeIntervalSince1970] + 7200;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:expiryTime] forKey:@"expiryTime"];
            
            handler(JSON, nil);
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            handler(JSON, error);
        }];
        [operation start];
    } else {
        handler(nil, nil); // already authorized
    }
}

+ (void)getRequest:(NSString *)url withHandler:(CBResponseHandler)handler {
    NSURL *_url = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        handler(JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        handler(JSON, error);
    }];
    [operation start];
}
@end
