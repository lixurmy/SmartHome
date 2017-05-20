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

#pragma mark - Public Method
- (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username || !password) {
        if (complete) {
            complete(NO, SHLoginStatusPasswordWrong, nil);
        }
        return;
    }
    password = [SHUtils lowerCaseMd5:password];
    NSDictionary *parameters = @{@"phone" : username, @"curpass" :  password?: @""};
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userlogin" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                complete(YES, SHLoginOrRegisterSuccess, nil);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)registerWithUsername:(NSString *)username password:(NSString *)password complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username || !password) {
        if (complete) {
            complete(NO, SHLoginStatusPasswordWrong, nil);
        }
        return;
    }
    password = [SHUtils lowerCaseMd5:password];
    NSDictionary *parameters = @{@"phone" : username, @"newpass" : password ?: @""};
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userreg" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                complete(YES, SHLoginOrRegisterSuccess, nil);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)resetPasswordForUsername:(NSString *)username complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username) {
        if (complete) {
            complete(NO, SHLoginStatusUnRegistered, nil);
        }
        return;
    }
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userpassreset" parameters:@{@"phone" : username ?: @""} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                NSString *password = responseObject[@"message"];
                complete(YES, SHLoginOrRegisterSuccess,password);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)changePasswordForUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username || !oldPassword || !newPassword) {
        if (complete) {
            complete(NO, SHLoginStatusUnRegistered, nil);
        }
        return;
    }
    oldPassword = [SHUtils lowerCaseMd5:oldPassword];
    newPassword = [SHUtils lowerCaseMd5:newPassword];
    NSDictionary *parameters = @{@"phone" : username ?: @"", @"curpass" : oldPassword ?: @"", @"newpass" : newPassword ?: @""};
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userpassmod" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                complete(YES, SHLoginOrRegisterSuccess, nil);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

#pragma mark - Prviate Method

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
