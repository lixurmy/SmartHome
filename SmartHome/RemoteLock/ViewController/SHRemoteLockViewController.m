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
#import "SHRemoteLockManager.h"

@interface SHRemoteLockViewController () <SHLockKeyboardDelegate, UITextFieldDelegate>

@property (nonatomic, strong) SHLockKeyboardViewController *lockKeyboardVC;
@property (nonatomic, strong) UITextField *inputPasswordLabel;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) NSString *inputString;
@property (nonatomic, strong) UILabel *hintLabel;

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
    [self.view addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lockKeyboardVC.view.mas_top).offset(-10);
        make.centerX.equalTo(self.lockKeyboardVC.view);
        make.left.equalTo(self.view).offset(150);
        make.right.equalTo(self.view).offset(-150);
        make.height.equalTo(@20);
    }];
    [self.view addSubview:self.inputPasswordLabel];
    [self.inputPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hintLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(150);
        make.right.equalTo(self.view).offset(-150);
        make.height.equalTo(@20);
    }];
}

#pragma mark - Private Method
- (void)openSetting {
    SHSettingsViewController *settingsVC = [[SHSettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)unlock {
    if (![SHRemoteLockManager sharedInstance].bindPhone) {
        [self showHint:@"未绑定手机号" duration:1.0];
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self openSetting];
        });
        return;
    }
    if ([self.inputString isEqualToString:[SHRemoteLockManager sharedInstance].lockPassword]) {
        @weakify(self);
        [self showLoading:YES hint:@"开锁中..."];
        [[SHRemoteLockManager sharedInstance] unlockPhone:[SHRemoteLockManager sharedInstance].bindPhone complete:^(BOOL succ, SHRemoteLockBindStatus statusCode, id info) {
            @strongify(self);
            if (succ) {
                [self showHint:@"开锁成功" duration:1.0];
            } else {
                [self showHint:[NSString stringWithFormat:@"开锁失败 code = %ld", statusCode] duration:1.0];
            }
            self.inputString = nil;
            [self.inputPasswordLabel setText:nil];
        }];
    } else {
        [self showHint:@"开锁密码验证失败" duration:1.0];
        [self.hintLabel setText:@"密码验证失败"];
    }
}

#pragma mark - SHLockKeyboardDelegate
- (void)keyboardController:(SHLockKeyboardViewController *)keyboardController didChangeOutput:(NSString *)output {
    if (!self.inputString) {
        self.inputString = output;
    } else {
        self.inputString = [NSString stringWithFormat:@"%@%@", self.inputString, output];
    }
    if (self.inputString.length == [[SHRemoteLockManager sharedInstance].lockPassword length]) {
        [self unlock];
    }
    [self.inputPasswordLabel setText:self.inputString];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.inputString = nil;
    [self.hintLabel setText:@"输入密码"];
    return YES;
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

- (UITextField *)inputPasswordLabel {
    if (!_inputPasswordLabel) {
        _inputPasswordLabel = [[UITextField alloc] init];
        _inputPasswordLabel.font = PingFangSCRegular(15);
        _inputPasswordLabel.secureTextEntry = YES;
        _inputPasswordLabel.textAlignment = NSTextAlignmentCenter;
        _inputPasswordLabel.clearButtonMode = UITextFieldViewModeAlways;
        _inputPasswordLabel.delegate = self;
    }
    return _inputPasswordLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = RGBCOLOR(11, 11, 11);
        _hintLabel.font = PingFangSCRegular(18);
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = @"输入密码";
    }
    return _hintLabel;
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
