//
//  SHLockManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockManager.h"

static NSString * const kSHLockManagerCurrentLockKey = @"kSHLockManagerCurrentLockKey";

static SHLockManager * _instance;

@implementation SHLockManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHLockManager alloc] init];
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:kSHLockManagerCurrentLockKey];
        SHLockModel *lockModel = [SHLockModel modelWithDictionary:[jsonString mj_JSONObject]];
        [_instance updateCurrentLock:lockModel];
    });
    return _instance;
}

#pragma mark - Query
- (void)fetchAllLocksWithComplete:(SHLockManagerComplete)complete {
    NSDictionary *parameters = @{@"gwid" : [SHUserManager sharedInstance].gatewayId ?: @""};
    [[SHNetworkManager lockManager] GET:@"cgi-bin/lock/ygs/v2/getygslock.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHLockHttpStatusCode statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLockHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, nil);
        }
    }];
}

- (void)fetchLockWithId:(NSString *)lockId complete:(SHLockManagerComplete)complete {
    NSDictionary *parameters = @{@"gwid" : [SHUserManager sharedInstance].gatewayId ?: @"",
                                 @"lid"  : lockId ?: @""};
    [[SHNetworkManager lockManager] GET:@"cgi-bin/lock/ygs/v2/getygslock.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHLockHttpStatusCode statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLockHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, nil);
        }
    }];
}

#pragma mark - Add
- (void)addLockWithMacAddress:(NSString *)macAddress alias:(NSString *)alias complete:(SHLockManagerComplete)complete {
    if (!macAddress) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, @"MacAdress Cannot be nil");
        }
        return;
    }
    NSDictionary *dict = @{@"gwid" : [SHUserManager sharedInstance].gatewayId ?: @"",
                           @"lmac" : macAddress,
                           @"smode": @"1"};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (alias) {
        [parameters addEntriesFromDictionary:@{@"alias" : alias}];
    }
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/v2/setygslock.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHLockHttpStatusCode statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLockHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, nil);
        }
    }];
}

#pragma mark - Delete
- (void)deleteLockId:(NSString *)lockId complete:(SHLockManagerComplete)complete {
    if (!lockId) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, @"LockId Cannot be nil");
        }
        return;
    }
    NSDictionary *parameters = @{@"gwid"    :   [SHUserManager sharedInstance].gatewayId,
                                 @"lid"     :   lockId,
                                 @"smode"   :   @"0"};
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/v2/setygslock.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHLockHttpStatusCode statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLockHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, nil);
        }
    }];
}

#pragma mark - Update
- (void)updateAlias:(NSString *)alias lockId:(NSString *)lockId complete:(SHLockManagerComplete)complete {
    NSDictionary *parameters = @{@"gwid"    :   [SHUserManager sharedInstance].gatewayId ?: @"",
                                 @"lid"     :   lockId ?: @"",
                                 @"alias"   :   alias ?: @"",
                                 @"smode"   :   @"2"};
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/v2/setygslock.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        } else {
            SHLockHttpStatusCode statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLockHttpStatusSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, @"网络异常");
        }
    }];
}

- (void)updateCurrentLock:(SHLockModel *)lockModel {
    _currentLock = lockModel;
    [[NSUserDefaults standardUserDefaults] setObject:[lockModel mj_JSONString] forKey:kSHLockManagerCurrentLockKey];
}

#pragma mark - Lock Actions
- (void)openLockWithId:(NSString *)lockId password:(NSString *)password complete:(SHLockManagerComplete)complete {
    if (!lockId && !password) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, @"lockId and password cannot be nil");
        }
        return;
    }
    NSDictionary *parameters = @{@"lid"     : lockId,
                                 @"password": password ?: @"",
                                 @"gwid"    : [SHUserManager sharedInstance].gatewayId ?: @""};
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/v2/dounlockygs.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SHLockHttpStatusCode statusCode = [responseObject[@"status"] integerValue];
        if (!complete) {
            return;
        }
        if (statusCode == SHLockHttpStatusSuccess) {
            complete(YES, statusCode, responseObject);
        } else {
            complete(NO, statusCode, responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLockHttpStatusUnknown, nil);
        }
    }];
}

@end
