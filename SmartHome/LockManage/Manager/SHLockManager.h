//
//  SHLockManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SHLockHttpStatusCode) {
    SHLockHttpStatusSuccess         = 200,
    SHLockHttpStatusLockExist       = 4105,
    SHLockHttpStatusLockNotFound    = 4107,
    SHLockHttpStatusUnknown
};

typedef void(^SHLockManagerComplete)(BOOL succ, SHLockHttpStatusCode statusCode, id info);

@interface SHLockManager : NSObject

+ (instancetype)sharedInstance;

- (void)fetchAllLocksWithComplete:(SHLockManagerComplete)complete;

- (void)fetchLockWithId:(NSString *)lockId complete:(SHLockManagerComplete)complete;

- (void)addLockWithMacAddress:(NSString *)macAddress alias:(NSString *)alias complete:(SHLockManagerComplete)complete;

- (void)deleteLockId:(NSString *)lockId complete:(SHLockManagerComplete)complete;

- (void)updateAlias:(NSString *)alias lockId:(NSString *)lockId complete:(SHLockManagerComplete)complete;

@end
