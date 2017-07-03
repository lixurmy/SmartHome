//
//  SHKeyDetailViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHKeyDetailViewController : SHBaseViewController

@property (nonatomic, readonly) NSString *lockId;
@property (nonatomic, readonly) NSString *keyNo;

- (instancetype)initWithLockId:(NSString *)lockId keyNo:(NSString *)keyNo;

@end
