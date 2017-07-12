//
//  SHUserManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/14.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHUserManager.h"
#import "SHSecurityQuestionModel.h"

static NSString * const kSHUserManagerPhoneKey = @"kSHUserManagerPhoneKey";
static NSString * const kSHUserManagerPasswordKey = @"kSHUserManagerPasswordKey";
static NSString * const kSHUSerManagerGatewayIdKey = @"kSHUserManagerGatewayIdKey";
static NSString * const kSHUserManagerIsLoginKey = @"kSHUserManagerIsLoginKey";
static NSString * const kSHUserManagerRegisterUrlFormat = @"http://13.112.216.206:8088/intelligw_2.0/register?phoneNumber=%@&password=%@&gateway=%@&question=%ld&answer=%@&question=%ld&answer=%@&question=%ld&answer=%@";

static SHUserManager * _instance;

@interface SHUserManager ()

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *gatewayId;
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation SHUserManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHUserManager alloc] init];
        _instance.isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kSHUserManagerIsLoginKey];
        _instance.phone = [[NSUserDefaults standardUserDefaults] objectForKey:kSHUserManagerPhoneKey];
        _instance.password = [[NSUserDefaults standardUserDefaults] objectForKey:kSHUserManagerPasswordKey];
        _instance.gatewayId = [[NSUserDefaults standardUserDefaults] objectForKey:kSHUSerManagerGatewayIdKey];
    });
    return _instance;
}

#pragma mark - Public Method
- (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username || !password) {
        if (complete) {
            complete(NO, SHLoginStatusPasswordWrong, nil);
        }
        return;
    }
    password = [SHUtils lowerCaseMd5:password];
    NSDictionary *parameters = @{@"phone" : username, @"curpass" :  password?: @""};
    @weakify(self);
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userlogin" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                self.isLogin = YES;
                self.phone = username;
                self.password = password;
                complete(YES, SHLoginOrRegisterSuccess, nil);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

-(void)registerWithUserName:(NSString *)username password:(NSString *)password mixedId:(NSString *)mixedId questions:(NSArray *)questions complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username || !password || !questions || !questions.count || !mixedId) {
        if (complete) {
            complete(NO, SHLoginStatusPasswordWrong, nil);
        }
        return;
    }
    password = [SHUtils lowerCaseMd5:password];
    SHSecurityQuestionModel *firstQuestion = questions[0];
    SHSecurityQuestionModel *secondQuestion = questions[1];
    SHSecurityQuestionModel *thirdQuestion = questions[2];
    NSString *urlString = [NSString stringWithFormat:kSHUserManagerRegisterUrlFormat, username, password, mixedId, [firstQuestion.questionId integerValue], firstQuestion.answer, [secondQuestion.questionId integerValue], secondQuestion.answer, [thirdQuestion.questionId integerValue], thirdQuestion.answer];
    [[AFHTTPSessionManager manager] POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                complete(YES, statusCode, responseObject);
            } else {
                complete(NO, statusCode, responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)registerWithUsername:(NSString *)username password:(NSString *)password complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username || !password) {
        if (complete) {
            complete(NO, SHLoginStatusPasswordWrong, nil);
        }
        return;
    }
    password = [SHUtils lowerCaseMd5:password];
    NSDictionary *parameters = @{@"phone" : username, @"newpass" : password ?: @""};
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userreg" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                complete(YES, SHLoginOrRegisterSuccess, nil);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)resetPasswordForUsername:(NSString *)username complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username) {
        if (complete) {
            complete(NO, SHLoginStatusUnRegistered, nil);
        }
        return;
    }
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userpassreset" parameters:@{@"phone" : username ?: @""} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                NSString *password = responseObject[@"message"];
                complete(YES, SHLoginOrRegisterSuccess,password);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)changePasswordForUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!username || !oldPassword || !newPassword) {
        if (complete) {
            complete(NO, SHLoginStatusUnRegistered, nil);
        }
        return;
    }
    oldPassword = [SHUtils lowerCaseMd5:oldPassword];
    newPassword = [SHUtils lowerCaseMd5:newPassword];
    NSDictionary *parameters = @{@"phone" : username ?: @"", @"curpass" : oldPassword ?: @"", @"newpass" : newPassword ?: @""};
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userpassmod" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                complete(YES, SHLoginOrRegisterSuccess, nil);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)bindGatewayWithId:(NSString *)gatewayId complete:(SHLoginOrRegisterCompleteBlock)complete {
    if (!gatewayId) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
        return;
    }
    NSDictionary *parameters = @{@"phone" : self.phone ?: @"", @"curpass" : self.password ?: @"", @"gwid" : gatewayId};
    [[SHNetworkManager baseManager] POST:@"intelligw-server/app/gwbind" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        SHLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!complete) {
            return;
        }
        if (!responseObject) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        } else {
            SHLoginOrRegisterStatus statusCode = [responseObject[@"status"] integerValue];
            if (statusCode == SHLoginOrRegisterSuccess) {
                self.gatewayId = gatewayId;
                complete(YES, statusCode, nil);
            } else {
                complete(NO, statusCode, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO, SHLoginOrRegisterServerError, nil);
        }
    }];
}

- (void)logoutWithComplete:(SHLoginOrRegisterCompleteBlock)complete {
    self.isLogin = NO;
    self.phone = nil;
    self.password = nil;
    self.gatewayId = nil;
    if (complete) {
        complete(YES, SHLoginOrRegisterSuccess, nil);
    }
}

#pragma mark - Set
- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:kSHUserManagerIsLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:kSHUserManagerPhoneKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString *)password {
    _password = [password copy];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kSHUserManagerPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setGatewayId:(NSString *)gatewayId {
    _gatewayId = gatewayId;
    [[NSUserDefaults standardUserDefaults] setObject:gatewayId forKey:kSHUSerManagerGatewayIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
