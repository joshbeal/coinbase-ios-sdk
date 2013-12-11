//
//  CBTransaction.h
//  Handshake
//
//  Created by Josh Beal on 12/10/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBRequest.h"

@class CBTransaction;

typedef void (^TransactionHandler)(CBTransaction *transaction, NSError *error);
typedef void (^RequestActionHandler)(BOOL success, NSError *error);

@interface CBTransaction : NSObject
@property NSString *name;
@property NSString *email;
@property NSString *amount;
@property NSString *timestamp;
@property NSString *hash;
@property NSString *transactionId;
@property BOOL sender;
@property BOOL request;

+ (void)send:(NSNumber*)amount to:(NSString*)address withNotes:(NSString*)notes withHandler:(TransactionHandler)handler;
+ (void)request:(NSNumber*)amount from:(NSString*)address withNotes:(NSString*)notes withHandler:(TransactionHandler)handler;

+ (void)resend:(NSString*)requestId withHandler:(RequestActionHandler)handler;
+ (void)cancel:(NSString*)requestId withHandler:(RequestActionHandler)handler;

+ (void)complete:(NSString*)requestId withHandler:(TransactionHandler)handler;
@end
