//
//  SHRemoteLockManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/30.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SHRemoteLockBindStatus) {
    SHRemoteLockBindSuccess = 200,
    SHRemoteLockBindInvalidParameters = 400,
    SHREmoteLockBindRoomNotFound = 303,
    SHRemoteLockBindErrorUnknown = 304,
    SHRemoteLockBindErrorWrongPassword = 403,
    SHRemoteLockBindErrorHotelIdNotFound = 404,
    SHRemoteLockBindServerError = 500,
    SHRemoteLockUnlockErrorLockOffline = 4061
};

typedef void(^SHRemoteLockManagerBlock)(BOOL succ, SHRemoteLockBindStatus statusCode, id info);

@interface SHRemoteLockManager : NSObject

@property (nonatomic, copy) NSString *bindPhone;
@property (nonatomic, readonly) NSString *lockPassword;
@property (nonatomic, readonly) NSString *startTime;
@property (nonatomic, readonly) NSString *endTime;
@property (nonatomic, readonly) BOOL isBind;

+ (instancetype)sharedInstance;

/**
 绑定手机，使用默认网关

 @param phone 待绑定的手机号
 @param complete 绑定结果回调
 */
- (void)bindPhone:(NSString *)phone complete:(SHRemoteLockManagerBlock)complete;

/**
 绑定手机，指定网关、起止时间、手机号

 @param phone 待绑定手机号
 @param gatewayId 网关Id
 @param startTime 有效期开始时间
 @param endTime 有效期结束时间
 @param complete 绑定结果回调
 */
- (void)bindPhone:(NSString *)phone gatewayId:(NSString *)gatewayId startTime:(NSString *)startTime endTime:(NSString *)endTime complete:(SHRemoteLockManagerBlock)complete;

/**
 解绑手机，使用默认网关

 @param phone 待解绑手机号
 @param complete 解绑结果回调
 */
- (void)unbindPhone:(NSString *)phone complete:(SHRemoteLockManagerBlock)complete;

/**
 解绑手机，指定手机号、网关

 @param phone 待解绑手机号
 @param gatewayId 网关Id
 @param complete 绑定结果回调
 */
- (void)unbindPhone:(NSString *)phone gatewayId:(NSString *)gatewayId complete:(SHRemoteLockManagerBlock)complete;


/**
 强制解绑，客户端清除绑定数据
 */
- (void)forceToUnbind;

/**
 解锁，指定手机号，使用默认网关

 @param phone 用于解锁的手机号
 @param complete 解锁结果回调
 */
- (void)unlockPhone:(NSString *)phone complete:(SHRemoteLockManagerBlock)complete;

/**
 解锁，指定手机号、网关

 @param phone 用于解锁的手机号
 @param gatewayId 待解锁的网关Id
 @param complete 解锁结果回调
 */
- (void)unlockPhone:(NSString *)phone gatewayId:(NSString *)gatewayId complete:(SHRemoteLockManagerBlock)complete;

/**
 设置离线解锁密码

 @param password 离线密码
 @param phone 指定手机号
 @param gatewayId 指定网关号
 @param startTime 有效期开始时间
 @param endTime 有效期结束时间
 @param usableTime 有效解锁次数
 @param complete 设置离线密码结果回调
 */
- (void)updateOfflinePassword:(NSString *)password phone:(NSString *)phone gatewayId:(NSString *)gatewayId startTime:(NSString *)startTime endTime:(NSString *)endTime usableTime:(NSUInteger)usableTime complete:(SHRemoteLockManagerBlock)complete;

- (void)updateLockPassword:(NSString *)password;

@end
