//
//  SHUserManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/14.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUserManager : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)sharedInstance;

@end
