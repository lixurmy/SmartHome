//
//  SHRemoteLockViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/28.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"
@class SHLockModel;

@interface SHRemoteLockViewController : SHBaseViewController

@property (nonatomic, readonly, strong) SHLockModel *lockModel;

- (instancetype)initWithLockModel:(SHLockModel *)lockModel;

@end
