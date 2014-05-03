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
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager GET:[NSString stringWithFormat:@"https://coinbase.com/api/v1/transfers?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
                
                return handler(JSON, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                return handler(nil, error);
            }];
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
            NSDictionary *params = @{@"qty" : qty};

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"https://coinbase.com/api/v1/sells?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
                
                handler(JSON, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                handler(nil, error);
            }];
        }
    }];
}

+ (void)buyBitcoin:(NSNumber *)qty withHandler:(CBResponseHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            NSDictionary *params = @{@"qty" : qty};
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"https://coinbase.com/api/v1/buys?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
                
                handler(JSON, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                handler(nil, error);
            }];
        }
    }];
}

+ (void)getExchangeRates:(CBResponseHandler)handler {
    [CBRequest getRequest:@"https://coinbase.com/api/v1/currencies/exchange_rates" withHandler:^(NSDictionary *result, NSError *error) {
        handler(result, error);
    }];
}

+ (void)getSupportedCurrencies:(CurrenciesHandler)handler {
    [CBRequest getRequest:@"https://coinbase.com/api/v1/currencies" withHandler:^(id result, NSError *error) {
        handler(result, error);
    }];
}

@end
