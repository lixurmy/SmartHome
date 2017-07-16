//
//  SHSecurityVerifyViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/7/16.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"
typedef void(^dismissCompleteBlock)();

@interface SHSecurityVerifyViewController : SHBaseViewController

@property (nonatomic, readonly) NSString *username;

- (instancetype)initWithUsername:(NSString *)username dismissComplete:(dismissCompleteBlock)complete;

@end
