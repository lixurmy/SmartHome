//
//  SHUnlockRecordViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHUnlockRecordViewController : SHBaseViewController

@property (nonatomic, readonly) NSString *lockId;

- (instancetype)initWithLockId:(NSString *)lockId;

@end
