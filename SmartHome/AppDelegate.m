//
//  AppDelegate.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "AppDelegate.h"
#import "SHTabBarManager.h"
#import "SHLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (![SHUserManager sharedInstance].isLogin) {
        SHLoginViewController *loginViewController = [[SHLoginViewController alloc] init];
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self.window setRootViewController:navigationVC];
    } else {
        SHTabBarManager *tabBarMananger = [[SHTabBarManager alloc] init];
        [self.window setRootViewController:(UIViewController *)tabBarMananger.tabBarViewController];
    }
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
