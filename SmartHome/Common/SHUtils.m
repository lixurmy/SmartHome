//
//  SHUtils.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/14.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHUtils.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation SHUtils

+ (NSString *)lowerCaseMd5:(NSString *)inString {
    const char *cStr = inString.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)inString.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result.lowercaseString;
}

+ (NSString *)upperCaseMd5:(NSString *)inString {
    const char *cStr = inString.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)inString.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result.uppercaseString;
}

@end
