//
//  CBRequest.h
//  Handshake
//
//  Created by Josh Beal on 11/11/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^CBResponseHandler)(id result, NSError* error);

@interface CBRequest : NSObject
+ (void)authorizedRequest:(CBResponseHandler)handler;
+ (void)getRequest:(NSString *)url withHandler:(CBResponseHandler)handler;
@end
