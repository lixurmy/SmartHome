//
//  SHLockModel.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockModel.h"

@implementation SHLockModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    [SHLockModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"lockId"          : @"lid",
                 @"lockMacAddress"  : @"lmac"};
    }];
    SHLockModel *lockModel = [SHLockModel mj_objectWithKeyValues:dictionary];
    return lockModel;
}

@end
