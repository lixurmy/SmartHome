//
//  SHWaterReaderManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHWaterReaderManager.h"
#import "SHWaterReaderModel.h"

static NSString * const kSHWaterReaderManagerColdWaterRecordTimeKey = @"kSHWaterReaderManagerColdWaterRecordTimeKey";
static NSString * const kSHWaterReaderManagerHotWaterRecordTimeKey = @"kSHWaterReaderManagerHotWaterRecordTimeKey";

static SHWaterReaderManager * _instance;

@interface SHWaterReaderManager ()

@property (nonatomic, copy) NSString *lastColdWaterRecordTime;
@property (nonatomic, copy) NSString *lastHotWaterRecordTime;

@end

@implementation SHWaterReaderManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHWaterReaderManager alloc] init];
    });
    return _instance;
}

#pragma mark - Public Method
- (void)fetchColdWaterReaderComplete:(SHWaterReaderComplete)complete {
    if (!complete) {
        return;
    }
    NSDictionary *paramters = @{@"gwid" : [SHUserManager sharedInstance].gatewayId ?: @"",
                                @"noparam" : @"1"};
    @weakify(self);
    [[SHNetworkManager waterManager] POST:@"cgi-bin/wreading.cgi"
                               parameters:paramters
                                 progress:nil
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        if (responseObject) {
            SHWaterReaderStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHWaterReaderStatusSuccess) {
                complete(YES, statusCode, responseObject);
                [self updateColdWaterRecordTime];
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(NO, SHWaterReaderStatusInternalError, error);
    }];
}

- (void)fetchHotWaterReaderComplete:(SHWaterReaderComplete)complete {
    if (!complete) {
        return;
    }
    NSDictionary *paramters = @{@"gwid" : [SHUserManager sharedInstance].gatewayId ?: @"",
                                @"noparam" : @"1"};
    @weakify(self);
    [[SHNetworkManager waterManager] POST:@"cgi-bin/greading.cgi"
                               parameters:paramters
                                 progress:nil
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        if (responseObject) {
            SHWaterReaderStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHWaterReaderStatusSuccess) {
                complete(YES, statusCode, responseObject);
                [self updateHotWaterRecordTime];
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(NO, SHWaterReaderStatusInternalError, error);
    }];
}

- (void)fetchColdWaterImageComplete:(SHWaterReaderComplete)complete {
    if (!complete) {
        return;
    }
    [self fetchColdWaterReaderComplete:^(BOOL succ, SHWaterReaderStatus statusCode, id info) {
        if (succ) {
            NSArray *meters = info[@"meters"];
            meters = [meters.rac_sequence map:^id(id value) {
                SHWaterReaderModel *model = [SHWaterReaderModel mj_objectWithKeyValues:value];
                return model;
            }].array;
            complete(YES, statusCode, meters);
        } else {
            complete(NO, statusCode, info);
        }
    }];
}

- (void)fetchHotWaterImageComplete:(SHWaterReaderComplete)complete {

}

#pragma mark - Private Method
- (void)updateColdWaterRecordTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD hh:mm:ss"];
    self.lastColdWaterRecordTime = [dateFormatter stringFromDate:date];
}

- (void)updateHotWaterRecordTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD hh:mm:ss"];
    self.lastHotWaterRecordTime = [dateFormatter stringFromDate:date];
}

#pragma mark - Set
- (void)setLastColdWaterRecordTime:(NSString *)lastColdWaterRecordTime {
    _lastColdWaterRecordTime = [lastColdWaterRecordTime copy];
    [[NSUserDefaults standardUserDefaults] setObject:_lastColdWaterRecordTime forKey:kSHWaterReaderManagerColdWaterRecordTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLastHotWaterRecordTime:(NSString *)lastHotWaterRecordTime {
    _lastHotWaterRecordTime = [lastHotWaterRecordTime copy];;
    [[NSUserDefaults standardUserDefaults] setObject:_lastHotWaterRecordTime forKey:kSHWaterReaderManagerHotWaterRecordTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
