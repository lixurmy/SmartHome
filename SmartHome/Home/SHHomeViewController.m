//
//  SHHomeViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHHomeViewController.h"

@interface SHHomeViewController ()

@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIButton *openLockButton;
@property (nonatomic, strong) UIButton *alertButton;

@end

@implementation SHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBCOLOR(255, 0, 0)];
    [self.view addSubview:self.logoutButton];
    [self.logoutButton setBackgroundColor:RGBCOLOR(0, 0, 0)];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    [[self.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [SHUserManager sharedInstance].isLogin = NO;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - GET
- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _logoutButton;
}

#pragma mark - VC Relative
- (BOOL)hasSHNavigationBar {
    return NO;
}

- (BOOL)hideNavigationBar {
    return NO;
}

@end
