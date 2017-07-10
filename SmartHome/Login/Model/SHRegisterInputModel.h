//
//  SHRegisterInputModel.h
//  SmartHome
//
//  Created by Xu.Li on 2017/7/10.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseModel.h"

@interface SHRegisterInputModel : SHBaseModel

@property (nonatomic, copy) NSString *cellphone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *mixedId; //网关Id或者注册码

@end
