//
//  SHLockModel.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHLockModel : SHBaseModel

@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *lockMacAddress;
@property (nonatomic, copy) NSString *hwVer;
@property (nonatomic, copy) NSString *swVer;
@property (nonatomic, assign) NSUInteger signal;
@property (nonatomic, assign) BOOL online;
@property (nonatomic, assign) BOOL inited;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
