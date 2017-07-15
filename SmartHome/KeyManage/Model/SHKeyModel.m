//
//  SHKeyModel.m
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHKeyModel.h"

@implementation SHKeyModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    SHKeyModel *model = [[SHKeyModel alloc] init];
    NSInteger lid = [dictionary[@"lid"] integerValue];
    NSInteger keyNo = [dictionary[@"keyNo"] integerValue];
    NSInteger keyTYpe = [dictionary[@"keyType"] integerValue];
    NSInteger isAlertKey = [dictionary[@"isAlertKey"] integerValue];
    NSInteger isActive = [dictionary[@"isActive"] integerValue];
    NSString *alias = dictionary[@"alias"];
    NSString *addTime = dictionary[@"addTime"];
    NSString *startTime = dictionary[@"startTime"];
    NSString *endTime = dictionary[@"endTime"];
    NSString *lastUnlockTime = dictionary[@"lastUnlockTime"];
    NSInteger timesLeft = [dictionary[@"timesLeft"] integerValue];
    NSInteger timesLimit = [dictionary[@"timesLimit"] integerValue];
    
    model.lockId = [NSString stringWithFormat:@"%ld", (long)lid];
    model.keyNo = [NSString stringWithFormat:@"%ld", (long)keyNo];
    model.alias = alias;
    model.isAlertKey = isAlertKey ? YES : NO;
    model.isActive = isActive ? YES : NO;
    model.type = keyTYpe;
    model.addTime = addTime;
    model.startTime = startTime;
    model.endTime = endTime;
    model.lastUnlockTime = lastUnlockTime;
    model.timesLeft = timesLeft;
    model.timesLimit = timesLimit;
    
    return model;
}

@end
