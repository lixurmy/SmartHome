//
//  SHRemoteLockManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/30.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHRemoteLockManager.h"

#define kSHRemoteLockManagerLockPasswordFormat(bindPhone) [NSString stringWithFormat:@"kSHRemoteLockManagerLockPassword_%@", (bindPhone)]
static NSString * const kSHRemoteLockManagerLockPasswordKey = @"kSHRemoteLockManagerLockPasswordKey";
static NSString * const kSHRemoteLockManagerBindPhoneKey = @"kSHRemoteLockManagerBindPhoneKey";
static NSString * const kSHRemoteLockManagerIsBindKey = @"kSHRemoteLockManagerIsBindKey";
static NSString * const kSHRemoteLockManagerBindStartTimeKey = @"kSHRemoteLockManagerBindStartTimeKey";
static NSString * const kSHRemoteLockManagerBindEndTimeKey = @"kSHRemoteLockManagerBindEndTimeKey";

static SHRemoteLockManager * _instance;

@interface SHRemoteLockManager ()

@property (nonatomic, copy) NSString *lockPassword;
@property (nonatomic, assign) BOOL isBind;

@end

@implementation SHRemoteLockManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHRemoteLockManager alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _instance.bindPhone = [defaults objectForKey:kSHRemoteLockManagerBindPhoneKey];
        _instance.isBind = [defaults boolForKey:kSHRemoteLockManagerIsBindKey];
        _instance.startTime = [defaults objectForKey:kSHRemoteLockManagerBindStartTimeKey];
        _instance.endTime = [defaults objectForKey:kSHRemoteLockManagerBindEndTimeKey];
        _instance.lockPassword = [defaults objectForKey:kSHRemoteLockManagerLockPasswordKey];
    });
    return _instance;
}

#pragma mark - Public Method
#pragma mark - Bind
- (void)bindPhone:(NSString *)phone complete:(SHRemoteLockManagerBlock)complete {
    [self bindPhone:phone
          gatewayId:[SHUserManager sharedInstance].gatewayId
          startTime:@""
            endTime:@""
           complete:complete];
}

- (void)bindPhone:(NSString *)phone gatewayId:(NSString *)gatewayId startTime:(NSString *)startTime endTime:(NSString *)endTime complete:(SHRemoteLockManagerBlock)complete {
    if (!phone || !gatewayId) {
        if (complete) {
            complete(NO, SHRemoteLockBindInvalidParameters, nil);
        }
        return;
    }
    NSDictionary *parameters = @{@"phone"       : phone ?: @"",
                                 @"gwid"   : gatewayId ?: @"",
                                 @"startTime"   : startTime ?: @"",
                                 @"endTime"     : endTime ?: @""};
    @weakify(self);
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/binding.cgi" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        SHLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        BOOL completeSuccess = NO;
        SHRemoteLockBindStatus statusCode = [responseObject[@"status"] integerValue];
        if (!responseObject) {
            completeSuccess = NO;
            statusCode = SHRemoteLockBindServerError;
        } else {
            if (statusCode == SHRemoteLockBindSuccess) {
                self.bindPhone = phone;
                self.isBind = YES;
                self.startTime = startTime;
                self.endTime = endTime;
                completeSuccess = YES;
            }
        }
        if (complete) {
            complete(completeSuccess, statusCode, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHRemoteLockBindServerError, nil);
        }
    }];
}

#pragma mark - unBind
- (void)unbindPhone:(NSString *)phone complete:(SHRemoteLockManagerBlock)complete {
    [self unbindPhone:phone gatewayId:[SHUserManager sharedInstance].gatewayId complete:complete];
}

- (void)unbindPhone:(NSString *)phone gatewayId:(NSString *)gatewayId complete:(SHRemoteLockManagerBlock)complete {
    if (!phone || !gatewayId) {
        if (complete) {
            complete(NO, SHRemoteLockBindInvalidParameters, nil);
        }
        return;
    }
    NSDictionary *parameters = @{@"phone" : phone ?: @"", @"gwid" : gatewayId ?: @""};
    @weakify(self);
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/unbinding.cgi" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        SHLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        BOOL completeSuccess = NO;
        SHRemoteLockBindStatus statusCode = [responseObject[@"status"] integerValue];
        if (!responseObject) {
            completeSuccess = NO;
            statusCode = SHRemoteLockBindServerError;
        } else {
            if (statusCode == SHRemoteLockBindSuccess) {
                self.bindPhone = nil;
                self.isBind = NO;
                self.startTime = nil;
                self.endTime = nil;
                completeSuccess = YES;
            }
        }
        if (complete) {
            complete(completeSuccess, statusCode, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHRemoteLockBindServerError, nil);
        }
    }];
}

- (void)forceToUnbind {
    self.isBind = NO;
    self.bindPhone = nil;
    self.startTime = nil;
    self.endTime = nil;
}

#pragma mark - unLock
- (void)unlockPhone:(NSString *)phone complete:(SHRemoteLockManagerBlock)complete{
    [self unlockPhone:phone gatewayId:[SHUserManager sharedInstance].gatewayId complete:complete];
}

- (void)unlockPhone:(NSString *)phone gatewayId:(NSString *)gatewayId complete:(SHRemoteLockManagerBlock)complete {
    if (!phone || !gatewayId) {
        if (complete) {
            complete(NO, SHRemoteLockBindInvalidParameters, nil);
        }
        return;
    }
    NSDictionary *parameters = @{@"phone" : phone ?: @"", @"gwid" : gatewayId ?: @""};
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/unlock.cgi" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        SHLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL completeSuccess = NO;
        SHRemoteLockBindStatus statusCode = [responseObject[@"status"] integerValue];
        if (!responseObject) {
            completeSuccess = NO;
            statusCode = SHRemoteLockBindServerError;
        } else {
            if (statusCode == SHRemoteLockBindSuccess) {
                completeSuccess = YES;
            }
        }
        if (complete) {
            complete(completeSuccess, statusCode, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHRemoteLockBindServerError, nil);
        }
    }];
}

#pragma mark - OfflinePassword
- (void)updateOfflinePassword:(NSString *)password phone:(NSString *)phone gatewayId:(NSString *)gatewayId startTime:(NSString *)startTime endTime:(NSString *)endTime usableTime:(NSUInteger)usableTime complete:(SHRemoteLockManagerBlock)complete {
    if (!password || !phone || !gatewayId) {
        if(complete) {
            complete(NO, SHRemoteLockBindInvalidParameters, nil);
        }
        return;
    }
    NSDictionary *parameters = @{@"phone"       : phone ?: @"",
                                 @"gwid"   : gatewayId ?: @"",
                                 @"password"    : password ?: @"",
                                 @"startTime"   : startTime ?: @"",
                                 @"endTime"     : endTime ?: @"",
                                 @"times"       : @(usableTime)};
    [[SHNetworkManager lockManager] POST:@"cgi-bin/lock/ygs/setpasswd.cgi" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        SHLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL completeSuccess = NO;
        SHRemoteLockBindStatus statusCode = [responseObject[@"status"] integerValue];
        if (!responseObject) {
            completeSuccess = NO;
            statusCode = SHRemoteLockBindServerError;
        } else {
            if (statusCode == SHRemoteLockBindSuccess) {
                completeSuccess = YES;
            }
        }
        if (complete) {
            complete(completeSuccess, statusCode, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHRemoteLockBindServerError, nil);
        }
    }];
}

- (void)updateLockPassword:(NSString *)password {
    self.lockPassword = password;
}

#pragma mark - Set
- (void)setBindPhone:(NSString *)bindPhone {
    _bindPhone = [bindPhone copy];
    [[NSUserDefaults standardUserDefaults] setObject:_bindPhone forKey:kSHRemoteLockManagerBindPhoneKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsBind:(BOOL)isBind {
    _isBind = isBind;
    [[NSUserDefaults standardUserDefaults] setBool:_isBind forKey:kSHRemoteLockManagerIsBindKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setStartTime:(NSString *)startTime {
    _startTime = [startTime copy];
    [[NSUserDefaults standardUserDefaults] setObject:_startTime forKey:kSHRemoteLockManagerBindStartTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setEndTime:(NSString *)endTime {
    _endTime = endTime;
    [[NSUserDefaults standardUserDefaults] setObject:_endTime forKey:kSHRemoteLockManagerBindEndTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLockPassword:(NSString *)lockPassword {
    _lockPassword = [lockPassword copy];
    [[NSUserDefaults standardUserDefaults] setObject:_lockPassword forKey:kSHRemoteLockManagerLockPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
