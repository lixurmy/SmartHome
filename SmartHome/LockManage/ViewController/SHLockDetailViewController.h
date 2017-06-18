//
//  SHLockDetailViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHLockDetailViewController : SHBaseViewController

- (instancetype)initWithLockId:(NSString *)lockId;

@property (nonatomic, readonly) NSString *lockId;

@end
