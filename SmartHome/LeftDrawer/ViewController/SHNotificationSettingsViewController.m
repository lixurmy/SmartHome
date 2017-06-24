//
//  SHNotificationSettingsViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/25.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHNotificationSettingsViewController.h"

@interface SHNotificationSettingsViewController ()

@end

@implementation SHNotificationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"通知设置";
}

@end
