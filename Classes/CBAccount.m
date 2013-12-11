//
//  CBAccount.m
//  Handshake
//
//  Created by Josh Beal on 12/10/13.
//  Copyright (c) 2013 Handshake. All rights reserved.
//

#import "CBAccount.h"

@implementation CBAccount

- (void)getTransactions:(TransactionsHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/api/v1/transactions?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSMutableArray *transactions = [[NSMutableArray alloc] init];
                NSArray *array = [JSON objectForKey:@"transactions"];
                for (NSDictionary *dict in array) {
                    NSDictionary *tDict = [dict objectForKey:@"transaction"];
                    CBTransaction *transaction = [[CBTransaction alloc] init];
                    transaction.amount = [[tDict objectForKey:@"amount"] objectForKey:@"amount"];
                    transaction.sender = [[[tDict objectForKey:@"sender"] objectForKey:@"email"] isEqualToString:self.email];
                    transaction.name = transaction.sender ? [[tDict objectForKey:@"recipient"] objectForKey:@"name"] : [[tDict objectForKey:@"sender"] objectForKey:@"name"];
                    if (!([tDict objectForKey:@"hsh"] == [NSNull null])) {
                        transaction.hash = [tDict objectForKey:@"hsh"];
                    }
                    transaction.email = transaction.sender ? [[tDict objectForKey:@"recipient"] objectForKey:@"email"] : [[tDict objectForKey:@"sender"] objectForKey:@"email"];
                    if (!transaction.name) {
                        transaction.name = [tDict objectForKey:@"recipient_address"];
                    }
                    transaction.transactionId = [tDict objectForKey:@"id"];
                    transaction.timestamp = [tDict objectForKey:@"created_at"];
                    transaction.request = [[tDict objectForKey:@"request"] boolValue];
                    [transactions addObject:transaction];
                }
                handler(transactions, nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(nil, error);
            }];
            [operation start];
        }
    }];
}

- (void)getAccountChanges:(CBResponseHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/api/v1/account_changes?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                handler(JSON, nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

- (void)getCurrentBalance:(BalanceHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/api/v1/account/balance?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                handler([JSON objectForKey:@"amount"], nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

- (void)getReceiveAddress:(AddressHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/api/v1/account/receive_address?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                handler([JSON objectForKey:@"address"], nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

- (void)getAddresses:(CBResponseHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/api/v1/addresses?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                handler(JSON, nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

- (void)getContacts:(CBResponseHandler)handler {
    [CBRequest authorizedRequest:^(NSDictionary *result, NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://coinbase.com/api/v1/contacts?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                handler(JSON, nil);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                handler(JSON, error);
            }];
            [operation start];
        }
    }];
}

@end
