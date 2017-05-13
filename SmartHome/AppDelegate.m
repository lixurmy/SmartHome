//
//  AppDelegate.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "AppDelegate.h"
#import "SHHomeViewController.h"
#import "SHLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (![SHUserManager sharedInstance].isLogin) {
        SHLoginViewController *loginViewController = [[SHLoginViewController alloc] init];
        [self.window setRootViewController:loginViewController];
    } else {
        SHHomeViewController *homeViewController = [[SHHomeViewController alloc] init];
        [self.window setRootViewController:homeViewController];
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
