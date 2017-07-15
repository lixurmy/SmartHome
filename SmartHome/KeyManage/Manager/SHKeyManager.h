//
//  SHKeyManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SHKeyHttpStatus) {
    SHKeyHttpStatusSuccess      = 200,
    SHKeyHttpStatusKeyExist     = 4105,
    SHKeyHttpStatusKeyNoExist   = 4436,
    SHKeyHttpStatusKeyPassError = 4402,
    SHKeyHttpStatusKeyNotExist  = 4107,
    SHKeyHttpStatusUnknownError
};

typedef NS_ENUM(NSUInteger, SHKeyType) {
    SHKeyTypeUnknown0 = 0,
    SHKeyTypeUnknown1 = 1,
    SHKeyTypeUnknown2 = 2,
    SHKeyTypeUser   = 3,
    SHKeyTypeTemp   = 4
};

typedef void(^SHKeyComplete)(BOOL succ, SHKeyHttpStatus statusCode, id info);

@interface SHKeyManager : NSObject

+ (instancetype)sharedInstance;

/**
 获取锁的钥匙信息

 @param lockId 锁Id
 @param complete 结果回调
 */
- (void)fetchKeysWithLockId:(NSString *)lockId complete:(SHKeyComplete)complete;

/**
 为指定锁添加新的钥匙

 @param lockId 锁Id
 @param password 钥匙对应的密码
 @param keyType 钥匙类型
 @param active 是否启用该钥匙
 @param alias 钥匙别名，可为nil
 @param keyNo 钥匙的序列号，可为nil
 @param alert 是否设置警报类型钥匙
 @param complete 添加结果回调
 */
- (void)addKeyForLock:(NSString *)lockId
             password:(NSString *)password
              keyType:(SHKeyType)keyType
               active:(BOOL)active
                alias:(NSString *)alias
                keyNo:(NSString *)keyNo
                alert:(BOOL)alert
             complete:(SHKeyComplete)complete;

/**
 更新指定锁的钥匙信息

 @param lockId 锁Id
 @param keyNo 更新的钥匙序列号
 @param alias 钥匙别名
 @param alert 是否设置为报警类型钥匙
 @param complete 更新结果回调
 */
- (void)updateKeyWithLockId:(NSString *)lockId
                      keyNo:(NSString *)keyNo
                      alias:(NSString *)alias
                      alert:(BOOL)alert
                   complete:(SHKeyComplete)complete;

/**
 删除锁的钥匙信息

 @param lockId 锁Id
 @param keyNo 删除的钥匙序列号
 @param complete 删除结果回调
 */
- (void)deleteKeyWithLockId:(NSString *)lockId
                      keyNo:(NSString *)keyNo
                   complete:(SHKeyComplete)complete;

@end
