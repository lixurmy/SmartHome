//
//  SHNetworkManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/13.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHNetworkManager.h"
#import "SHBaseURL.h"

static SHNetworkManager * _baseManager;

@implementation SHNetworkManager

+ (instancetype)baseManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:[SHBaseURL sharedInstance].baseUrl];
        _baseManager = [[super alloc] initWithBaseURL:baseUrl];
    });
    return _baseManager;
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
