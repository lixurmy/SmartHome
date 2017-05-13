//
//  SHUserManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/14.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHUserManager.h"

static NSString * const kSHUserManagerPhoneKey = @"kSHUserManagerPhoneKey";
static NSString * const kSHUserManagerIsLoginKey = @"kSHUserManagerIsLoginKey";

static SHUserManager * _instance;

@implementation SHUserManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHUserManager alloc] init];
    });
    return _instance;
}

- (void)setIsLogin:(BOOL)isLogin {
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:kSHUserManagerIsLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSHUserManagerIsLoginKey];
}

- (void)setPhone:(NSString *)phone {
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:kSHUserManagerPhoneKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)phone {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSHUserManagerPhoneKey];
}

@end
