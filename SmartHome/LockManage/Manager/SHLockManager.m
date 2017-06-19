//
//  SHLockManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockManager.h"

static SHLockManager * _instance;

@implementation SHLockManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHLockManager alloc] init];
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

@end
