//
//  SHBaseURL.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/13.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseURL.h"

static SHBaseURL * _instance;

@implementation SHBaseURL

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHBaseURL alloc] init];
    });
    return _instance;
}

- (NSString *)baseUrl {
    return @"http://13.112.216.206:8088";
}

- (NSString *)lockUrl {
    return @"http://13.112.216.206:8083";
}

@end
