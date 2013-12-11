//
//  CBAccount.h
//  Handshake
//
//  Created by Josh Beal on 12/10/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBTransaction.h"
#import "CBRequest.h"

typedef void (^TransactionsHandler)(NSArray *transactions, NSError *error);
typedef void (^BalanceHandler)(NSString *balance, NSError *error);
typedef void (^AddressHandler)(NSString *address, NSError *error);
typedef void (^AddressListHandler)(NSArray *addressList, NSError *error);

@interface CBAccount : NSObject
@property NSString *name;
@property NSString *email;
@property NSString *balance;
@property NSString *cbId;
@property NSString *nativeCurrency;
@property NSString *timeZone;
@property NSString *buyLevel;
@property NSString *buyLimit;
@property NSString *sellLevel;
@property NSString *sellLimit;

- (void)getTransactions:(TransactionsHandler)handler;

- (void)getAccountChanges:(CBResponseHandler)handler;

- (void)getCurrentBalance:(BalanceHandler)handler;
- (void)getReceiveAddress:(AddressHandler)handler;
- (void)getAddresses:(CBResponseHandler)handler;
- (void)getContacts:(CBResponseHandler)handler;

@end
