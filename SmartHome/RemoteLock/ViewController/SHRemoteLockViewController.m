//
//  SHRemoteLockViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/28.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHRemoteLockViewController.h"
#import "SHLockKeyboardViewController.h"
#import "SHSettingsViewController.h"

@interface SHRemoteLockViewController () <SHLockKeyboardDelegate>

@property (nonatomic, strong) SHLockKeyboardViewController *lockKeyboardVC;
@property (nonatomic, strong) UIButton *settingButton;


@end

@implementation SHRemoteLockViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.lockKeyboardVC];
    [self.view addSubview:self.lockKeyboardVC.view];
    [self.lockKeyboardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kScreenHeight * 0.35));
    }];
}

#pragma mark - Private Method
- (void)openSetting {
    SHSettingsViewController *settingsVC = [[SHSettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark - SHLockKeyboardDelegate
- (void)keyboardController:(SHLockKeyboardViewController *)keyboardController didChangeOutput:(NSString *)output {
    SHLog(@"%@", output);
}

#pragma mark - Get
- (SHLockKeyboardViewController *)lockKeyboardVC {
    if (!_lockKeyboardVC) {
        _lockKeyboardVC = [[SHLockKeyboardViewController alloc] init];
        _lockKeyboardVC.delegate = self;
    }
    return _lockKeyboardVC;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_settingButton.titleLabel setFont:PingFangSCRegular(20)];
        [_settingButton addTarget:self
                           action:@selector(openSetting)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"远程开锁";
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [super createSHNavigationBar];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    [self.settingButton sizeToFit];
    [self.shNavigationItem setRightBarButtonItem:settingItem];
    return navigationBar;
}

@end
