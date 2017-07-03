//
//  SHAddKeyViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHAddKeyViewController : SHBaseViewController

@property (nonatomic, readonly) NSString *lockId;

- (instancetype)initWithLockId:(NSString *)lockId;

@end
