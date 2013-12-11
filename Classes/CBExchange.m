//
//  CBExchange.m
//  Handshake
//
//  Created by Josh Beal on 12/10/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import "CBExchange.h"

@implementation CBExchange
+ (void)getTransfers:(CBResponseHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/api/v1/transfers?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                return handler(JSON, nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                return handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

+ (void)getBuyPrice:(NSNumber*)qty withHandler:(PriceHandler)handler {
    [CBRequest getRequest:@"https://coinbase.com/api/v1/prices/buy" withHandler:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            handler([[result objectForKey:@"total"] objectForKey:@"amount"], nil);
        }
    }];
}

+ (void)getSellPrice:(NSNumber*)qty withHandler:(PriceHandler)handler {
    [CBRequest getRequest:@"https://coinbase.com/api/v1/prices/sell" withHandler:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            handler([[result objectForKey:@"total"] objectForKey:@"amount"], nil);
        }
    }];
}

+ (void)getSpotRate:(NSString *)currency withHandler:(PriceHandler)handler {
    [CBRequest getRequest:[NSString stringWithFormat:@"https://coinbase.com/api/v1/prices/spot_rate?currency=%@",currency] withHandler:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            handler([result objectForKey:@"amount"], nil);
        }
    }];
}

+ (void)sellBitcoin:(NSNumber *)qty withHandler:(CBResponseHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://coinbase.com"]];
            [httpClient setParameterEncoding:AFJSONParameterEncoding];
            NSDictionary *params = @{@"qty" : qty};
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                    path:[NSString stringWithFormat:@"https://coinbase.com/api/v1/sells?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]
                                                              parameters:params];
            httpClient.parameterEncoding = AFJSONParameterEncoding;
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                handler(JSON, nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

+ (void)buyBitcoin:(NSNumber *)qty withHandler:(CBResponseHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://coinbase.com"]];
            [httpClient setParameterEncoding:AFJSONParameterEncoding];
            NSDictionary *params = @{@"qty" : qty};
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                    path:[NSString stringWithFormat:@"https://coinbase.com/api/v1/buys?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]
                                                              parameters:params];
            httpClient.parameterEncoding = AFJSONParameterEncoding;
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                handler(JSON, nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

+ (void)getExchangeRates:(CBResponseHandler)handler {
    [CBRequest getRequest:@"https://coinbase.com/api/v1/currencies/exchange_rates" withHandler:^(NSDictionary *result, NSError *error) {
        handler(result, error);
    }];
}

+ (void)getSupportedCurrencies:(CBResponseHandler)handler {
    [CBRequest getRequest:@"https://coinbase.com/api/v1/currencies" withHandler:^(NSDictionary *result, NSError *error) {
        handler(result, error);
    }];
}

@end
