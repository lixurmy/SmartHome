//
//  SHHomeViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHHomeViewController.h"
#import "SHLoginViewController.h"

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
    @weakify(self);
    [[self.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [SHUserManager sharedInstance].isLogin = NO;
        [self showHint:@"退出登录" duration:1.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SHLoginViewController *loginViewController = [[SHLoginViewController alloc] init];
            [self.view.window setRootViewController:loginViewController];
        });
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

@end
