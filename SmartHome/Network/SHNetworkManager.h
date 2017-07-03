//
//  SHNetworkManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/13.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface SHNetworkManager : AFHTTPSessionManager

+ (instancetype)baseManager;

+ (instancetype)lockManager;

+ (instancetype)keyManager;

+ (instancetype)waterManager;

@end
