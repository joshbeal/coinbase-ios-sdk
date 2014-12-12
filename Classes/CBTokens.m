//
//  CBTokens.m
//  Pods
//
//  Created by Duncan Cunningham on 12/12/14.
//
//

#import "CBTokens.h"

#import <UICKeyChainStore.h>

@implementation CBTokens

NSString* const CBTokensAccessTokenKey = @"CBTokensAccessTokenKey";
NSString* const CBTokensAuthCodeKey = @"CBTokensAuthCodeKey";
NSString* const CBTokensExpiryTimeKey = @"CBTokensExpiryTimeKey";
NSString* const CBTokensRefreshTokenKey = @"CBTokensRefreshTokenKey";

+ (NSString*)accessToken
{
    return [UICKeyChainStore stringForKey:CBTokensAccessTokenKey];
}

+ (NSString*)authCode
{
    return [UICKeyChainStore stringForKey:CBTokensAuthCodeKey];
}

+ (NSNumber*)expiryTime
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:[UICKeyChainStore stringForKey:CBTokensExpiryTimeKey]];
}

+ (NSString*)refreshToken
{
    return [UICKeyChainStore stringForKey:CBTokensRefreshTokenKey];
}

+ (void)setAccessToken:(NSString*)accessToken
{
    [UICKeyChainStore setString:accessToken forKey:CBTokensAccessTokenKey];
}

+ (void)setAuthCode:(NSString*)authCode
{
    [UICKeyChainStore setString:authCode forKey:CBTokensAuthCodeKey];
}

+ (void)setExpiryTime:(NSNumber*)expiryTime
{
    [UICKeyChainStore setString:[expiryTime stringValue] forKey:CBTokensExpiryTimeKey];
}

+ (void)setRefreshToken:(NSString*)refreshToken
{
    [UICKeyChainStore setString:refreshToken forKey:CBTokensRefreshTokenKey];
}

+ (void)resetTokens
{
    [UICKeyChainStore removeItemForKey:CBTokensAccessTokenKey];
    [UICKeyChainStore removeItemForKey:CBTokensAuthCodeKey];
    [UICKeyChainStore removeItemForKey:CBTokensExpiryTimeKey];
    [UICKeyChainStore removeItemForKey:CBTokensRefreshTokenKey];
}

@end
