//
//  SHKeyModel.h
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseModel.h"
#import "SHKeyManager.h"

@interface SHKeyModel : SHBaseModel

@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, copy) NSString *keyNo;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, assign) SHKeyType type;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isAlertKey;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *lastUnlockTime;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) NSUInteger timesLimit;
@property (nonatomic, assign) NSUInteger timesLeft;

@end
