//
//  SHKeyDetailViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"
@class SHKeyModel;

@interface SHKeyDetailViewController : SHBaseViewController

@property (nonatomic, readonly) SHKeyModel *keyModel;

//@property (nonatomic, readonly) NSString *lockId;
//@property (nonatomic, readonly) NSString *keyNo;
//
//- (instancetype)initWithLockId:(NSString *)lockId keyNo:(NSString *)keyNo;

//目前服务器不支持单独获取钥匙信息，需要从其他页面传入钥匙数据进来
- (instancetype)initWithKeyModel:(SHKeyModel *)keyModel;

@end
