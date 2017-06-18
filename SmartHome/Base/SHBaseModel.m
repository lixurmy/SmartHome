//
//  SHBaseModel.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseModel.h"

@implementation SHBaseModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    SHBaseModel *model = [[[self class] alloc] init];
    return model;
}

@end
