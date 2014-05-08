//
//  CBExchange.h
//  Handshake
//
//  Created by Josh Beal on 12/10/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBRequest.h"

typedef void (^PriceHandler)(NSString *price, NSError *error);
typedef void (^CurrenciesHandler)(NSArray* currencies, NSError *error);

@interface CBExchange : NSObject

+ (void)getTransfers:(CBResponseHandler)handler;

+ (void)getBuyPrice:(NSNumber*)qty withHandler:(PriceHandler)handler;
+ (void)getSellPrice:(NSNumber*)qty withHandler:(PriceHandler)handler;
+ (void)getSpotRate:(NSString *)currency withHandler:(PriceHandler)handler;

+ (void)buyBitcoin:(NSNumber*)qty withHandler:(CBResponseHandler)handler;
+ (void)sellBitcoin:(NSNumber*)qty withHandler:(CBResponseHandler)handler;

+ (void)getExchangeRates:(CBResponseHandler)handler;
+ (void)getSupportedCurrencies:(CurrenciesHandler)handler;

@end
