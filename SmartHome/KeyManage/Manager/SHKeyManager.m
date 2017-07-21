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
            NSString *errorMessage = nil;
            if (error) {
                NSDictionary *userInfo = error.userInfo;
                errorMessage = userInfo[@"NSLocalizedDescription"];
            }
            complete(NO, SHKeyHttpStatusUnknownError, errorMessage);
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
            NSString *errorMessage = nil;
            if (error) {
                NSDictionary *userInfo = error.userInfo;
                errorMessage = userInfo[@"NSLocalizedDescription"];
            }
            complete(NO, SHKeyHttpStatusUnknownError, errorMessage);
        }
    }];
}

- (void)addKeyForLock:(NSString *)lockId password:(NSString *)password keyType:(SHKeyType)keyType active:(BOOL)active alias:(NSString *)alias keyNo:(NSString *)keyNo alert:(BOOL)alert startTime:(NSString *)startTime endTime:(NSString *)endTime timesLimit:(NSString *)timesLimit complete:(SHKeyComplete)complete {
    if (!lockId || !password) {
        if (complete) {
            complete(NO, SHKeyHttpStatusUnknownError, @"lockId Or Password cannot be nil");
        }
        return;
    }
    NSString *formatStartTime = [self formatTimeString:startTime];
    NSString *formatEndTime = [self formatTimeString:endTime];
    NSDictionary *parameters = @{@"lid"     :   lockId,
                                 @"passwd"  :   password,
                                 @"smode"   :   @(1),
                                 @"type"    :   @(keyType),
                                 @"active"  :   @(active),
                                 @"alias"   :   alias ?: @"",
                                 @"no"      :   keyNo ?: @"",
                                 @"alert"   :   @(alert),
                                 @"stime"   : formatStartTime,
                                 @"etime" :   formatEndTime,
                                 @"times"   :   timesLimit ?: @"",
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
            NSString *errorMessage = nil;
            if (error) {
                NSDictionary *userInfo = error.userInfo;
                errorMessage = userInfo[@"NSLocalizedDescription"];
            }
            complete(NO, SHKeyHttpStatusUnknownError, errorMessage);
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
            NSString *errorMessage = nil;
            if (error) {
                NSDictionary *userInfo = error.userInfo;
                errorMessage = userInfo[@"NSLocalizedDescription"];
            }
            complete(NO, SHKeyHttpStatusUnknownError, errorMessage);
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
            NSString *errorMessage = nil;
            if (error) {
                NSDictionary *userInfo = error.userInfo;
                errorMessage = userInfo[@"NSLocalizedDescription"];
            }
            complete(NO, SHKeyHttpStatusUnknownError, errorMessage);
        }
    }];
}

- (NSString *)formatTimeString:(NSString *)timeString {
    if (!timeString || !timeString.length) {
        return timeString;
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@":- "];
    NSArray *array = [timeString componentsSeparatedByCharactersInSet:set];
    NSString *string = array[0];
    for (int i = 1; i < array.count - 2; ++i) {
        if (i == 1) {
            NSString *month = array[i];
            if (month.length < 2) {
                month = [NSString stringWithFormat:@"0%@", month];
            }
            string = [string stringByAppendingString:month];
        } else if (i == 2) {
            NSString *day = array[i];
            if (day.length < 2) {
                day = [NSString stringWithFormat:@"0%@", day];
            }
            string = [string stringByAppendingString:day];
        } else {
            string = [string stringByAppendingString:array[i]];
        }
    }
    //    string = [string stringByAppendingString:@"00"];
    return string;
}

@end
