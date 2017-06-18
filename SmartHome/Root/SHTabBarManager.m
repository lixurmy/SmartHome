//
//  SHTabBarManager.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHTabBarManager.h"
#import "SHRootViewController.h"
#import "SHLockManageViewController.h"
#import "SHBaseNavigationViewController.h"
#import <CYLTabBarController/CYLTabBarController.h>

@interface SHTabBarManager ()

@property (nonatomic, strong) CYLTabBarController *tabBarViewController;
@property (nonatomic, strong) NSArray *viewContollers;
@property (nonatomic, strong) NSArray *tabBarItemAttributes;

@end

@implementation SHTabBarManager

#pragma mark - Lazy Load
- (CYLTabBarController *)tabBarViewController {
    if (!_tabBarViewController) {
        _tabBarViewController = [[CYLTabBarController alloc] initWithViewControllers:self.viewContollers tabBarItemsAttributes:self.tabBarItemAttributes];
    }
    return _tabBarViewController;
}

- (NSArray *)viewContollers {
    if (!_viewContollers) {
        NSMutableArray *mArray = [NSMutableArray array];
        SHRootViewController *rootVC = [[SHRootViewController alloc] init];
        UINavigationController *rootNaviVC = [[SHBaseNavigationViewController alloc] initWithRootViewController:rootVC];
        [mArray addObject:rootNaviVC];
        
        SHLockManageViewController *lockManageVC = [[SHLockManageViewController alloc] init];
        UINavigationController *lockNaviVC = [[SHBaseNavigationViewController alloc] initWithRootViewController:lockManageVC];
        [mArray addObject:lockNaviVC];
        
        _viewContollers = [mArray copy];
    }
    return _viewContollers;
}

- (NSArray *)tabBarItemAttributes {
    if (!_tabBarItemAttributes) {
        NSDictionary *rootItemAttributes = @{CYLTabBarItemImage : @"sh_tabbar_icon_root",
                                             CYLTabBarItemTitle : @"开锁"};
        NSDictionary *lockManagerItemAttributes = @{CYLTabBarItemImage : @"sh_tabbar_icon_lockmanager",
                                                    CYLTabBarItemTitle : @"锁管理"};
        _tabBarItemAttributes = @[rootItemAttributes, lockManagerItemAttributes];
    }
    return _tabBarItemAttributes;
}

@end
