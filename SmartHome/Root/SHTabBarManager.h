//
//  SHTabBarManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYLTabBarController;

@interface SHTabBarManager : NSObject

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarViewController;

@end
