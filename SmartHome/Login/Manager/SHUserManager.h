//
//  SHUserManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/14.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SHLoginOrRegisterStatus) {
    SHLoginOrRegisterSuccess = 2000,
    SHRegisterStatusAlreadyRegistered = 4001,
    SHLoginStatusUnRegistered = 4002,
    SHLoginStatusPasswordWrong = 4005,
    SHLoginStatusPasswordShouldChange = 3001,
    SHLoginOrRegisterServerError
};

typedef void(^SHLoginOrRegisterCompleteBlock)(BOOL succ, SHLoginOrRegisterStatus statusCode, id info);

@interface SHUserManager : NSObject

@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *password; //MD5
@property (nonatomic, readonly) NSString *gatewayId;
@property (nonatomic, readonly) BOOL isLogin;

+ (instancetype)sharedInstance;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(SHLoginOrRegisterCompleteBlock)complete;
- (void)registerWithUserName:(NSString *)username password:(NSString *)password mixedId:(NSString *)mixedId questions:(NSArray *)questions complete:(SHLoginOrRegisterCompleteBlock)complete;
- (void)resetPasswordForUsername:(NSString *)username complete:(SHLoginOrRegisterCompleteBlock)complete;
- (void)changePasswordForUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword complete:(SHLoginOrRegisterCompleteBlock)complete;
- (void)bindGatewayWithId:(NSString *)gatewayId complete:(SHLoginOrRegisterCompleteBlock)complete;
- (void)verifyUserWithPhone:(NSString *)phone questions:(NSArray *)questions complete:(SHLoginOrRegisterCompleteBlock)complete;
- (void)logoutWithComplete:(SHLoginOrRegisterCompleteBlock)complete;

@end
