//
//  SHKeyManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHKeyManager.h"

static SHKeyManager * _instance;

@implementation SHKeyManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHKeyManager alloc] init];
    });
    return _instance;
}

#pragma mark - Public Method
- (void)fetchKeysWithLockId:(NSString *)lockId complete:(SHKeyComplete)complete {
    if (!lockId) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, @"lockId cannot be nil");
        }
        return;
    }
    NSDictionary *parameters = @{@"lid" : lockId, @"gwid" : [SHUserManager sharedInstance].gatewayId ?: @""};
    [[SHNetworkManager keyManager] POST:@"cgi-bin/lock/ygs/v2/getkeyinfo.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHKeyHttpStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHKeyHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, nil);
        }
    }];
}

- (void)addKeyForLock:(NSString *)lockId password:(NSString *)password keyType:(SHKeyType)keyType active:(BOOL)active alias:(NSString *)alias keyNo:(NSString *)keyNo alert:(BOOL)alert complete:(SHKeyComplete)complete {
    if (!lockId || !password) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, @"lockId Or Password cannot be nil");
        }
        return;
    }
    NSDictionary *parameters = @{@"lid"     :   lockId,
                                 @"passwd"  :   password,
                                 @"smode"   :   @(1),
                                 @"type"    :   @(keyType),
                                 @"active"  :   @(active),
                                 @"alias"   :   alias ?: @"",
                                 @"no"      :   keyNo ?: @"",
                                 @"alert"   :   @(alert),
                                 @"gwid"    :   [SHUserManager sharedInstance].gatewayId ?: @""};
    [[SHNetworkManager keyManager] POST:@"cgi-bin/lock/ygs/v2/setkeyinfo.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHKeyHttpStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHKeyHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, nil);
        }
    }];
}

- (void)updateKeyWithLockId:(NSString *)lockId keyNo:(NSString *)keyNo alias:(NSString *)alias alert:(BOOL)alert complete:(SHKeyComplete)complete {
    if (!lockId || !keyNo) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, @"LockId Or KeyNo Cannot be nil");
        }
        return;
    }
    NSDictionary *parameters = @{@"lid"     :   lockId,
                                 @"no"      :   keyNo,
                                 @"smode"   :   @(2),
                                 @"alias"   :   alias ?: @"",
                                 @"alert"   :   @(alert),
                                 @"gwid"    :   [SHUserManager sharedInstance].gatewayId ?: @""};
    [[SHNetworkManager keyManager] POST:@"cgi-bin/lock/ygs/v2/setkeyinfo.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHKeyHttpStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHKeyHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, nil);
        }
    }];
}

- (void)deleteKeyWithLockId:(NSString *)lockId keyNo:(NSString *)keyNo complete:(SHKeyComplete)complete {
    if (!lockId || !keyNo) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, @"lockId Or keyNo Cannot be nil");
        }
        return;
    }
    NSDictionary *parameters = @{@"lid"     :   lockId,
                                 @"no"      :   keyNo,
                                 @"smode"   :   @(0),
                                 @"gwid"    :   [SHUserManager sharedInstance].gatewayId ?: @""};
    [[SHNetworkManager keyManager] POST:@"cgi-bin/lock/ygs/v2/setkeyinfo.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHKeyHttpStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHKeyHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, nil);
        }
    }];
}

@end
