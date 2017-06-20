//
//  SHLockManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHLockModel.h"

typedef NS_ENUM(NSUInteger, SHLockHttpStatusCode) {
    SHLockHttpStatusSuccess         = 200,
    SHLockHttpStatusLockExist       = 4105,
    SHLockHttpStatusLockNotFound    = 4107,
    SHLockHttpStatusUnknown
};

typedef void(^SHLockManagerComplete)(BOOL succ, SHLockHttpStatusCode statusCode, id info);

@interface SHLockManager : NSObject

@property (nonatomic, readonly, strong) SHLockModel *currentLock;

+ (instancetype)sharedInstance;

- (void)fetchAllLocksWithComplete:(SHLockManagerComplete)complete;

- (void)fetchLockWithId:(NSString *)lockId complete:(SHLockManagerComplete)complete;

- (void)addLockWithMacAddress:(NSString *)macAddress alias:(NSString *)alias complete:(SHLockManagerComplete)complete;

- (void)deleteLockId:(NSString *)lockId complete:(SHLockManagerComplete)complete;

- (void)updateAlias:(NSString *)alias lockId:(NSString *)lockId complete:(SHLockManagerComplete)complete;

- (void)updateCurrentLock:(SHLockModel *)lockModel;

- (void)openLockWithId:(NSString *)lockId password:(NSString *)password complete:(SHLockManagerComplete)complete;

@end
