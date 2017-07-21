//
//  SHNetworkManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/13.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHNetworkManager.h"
#import "SHBaseURL.h"

static CGFloat kSHNetworkTimeout = 60.0;

@implementation SHNetworkManager

+ (instancetype)baseManager {
    static SHNetworkManager * _baseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:[SHBaseURL sharedInstance].baseUrl];
        _baseManager = [[super alloc] initWithBaseURL:baseUrl];
        _baseManager.requestSerializer.timeoutInterval = kSHNetworkTimeout;
    });
    return _baseManager;
}

+ (instancetype)lockManager {
    static SHNetworkManager * _lockManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *lockUrl = [NSURL URLWithString:[SHBaseURL sharedInstance].lockUrl];
        _lockManager = [[super alloc] initWithBaseURL:lockUrl];
        _lockManager.requestSerializer.timeoutInterval = kSHNetworkTimeout;
    });
    return _lockManager;
}

+ (instancetype)keyManager {
    static SHNetworkManager * _keyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *keyUrl = [NSURL URLWithString:[SHBaseURL sharedInstance].keyUrl];
        _keyManager = [[super alloc] initWithBaseURL:keyUrl];
        _keyManager.requestSerializer.timeoutInterval = kSHNetworkTimeout;
    });
    return _keyManager;
}

+ (instancetype)waterManager {
    static SHNetworkManager * _waterManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *waterUrl = [NSURL URLWithString:[SHBaseURL sharedInstance].waterUrl];
        _waterManager = [[super alloc] initWithBaseURL:waterUrl];
        _waterManager.requestSerializer.timeoutInterval = kSHNetworkTimeout;
        [_waterManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"image/jpeg", nil]];
    });
    return _waterManager;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseURL.absoluteString, URLString];
    return [super GET:urlString parameters:parameters progress:downloadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseURL.absoluteString, URLString];
    return [super POST:urlString parameters:parameters progress:uploadProgress success:success failure:failure];
}

@end
