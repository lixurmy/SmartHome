//
//  SHRemoteLockViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/28.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHRemoteLockViewController.h"
#import "SHShowVideoViewController.h"
#import "SHLockKeyboardViewController.h"
#import "SHLockDetailViewController.h"
#import "SHSettingsViewController.h"
#import "SHRemoteLockManager.h"
#import "SHLockManager.h"
#import "SHLockModel.h"

@interface SHRemoteLockViewController () <SHLockKeyboardDelegate, UITextFieldDelegate>

@property (nonatomic, strong) SHLockKeyboardViewController *lockKeyboardVC;
@property (nonatomic, strong) UIImageView *houseImageView;
@property (nonatomic, strong) UITextField *inputPasswordLabel;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) NSString *inputString;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation SHRemoteLockViewController

#pragma mark - Init
- (instancetype)initWithLockModel:(SHLockModel *)lockModel {
    self = [super init];
    if (self) {
        _lockModel = lockModel;
    }
    return self;
}

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.lockModel) {
        [self setupView];
    } else {
        [self showHint:@"请添加常用锁" duration:1.0];
    }
}

- (void)setupView {
    [self.view addSubview:self.houseImageView];
    [self.houseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight + 20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@328);
    }];
    [self addChildViewController:self.lockKeyboardVC];
    [self.view addSubview:self.lockKeyboardVC.view];
    [self.lockKeyboardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kScreenHeight * 0.35));
    }];
    [self.view addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lockKeyboardVC.view.mas_top).offset(-10 * kScreenScale);
        make.centerX.equalTo(self.lockKeyboardVC.view);
        make.left.equalTo(self.view).offset(120 * kScreenScale);
        make.right.equalTo(self.view).offset(-120 * kScreenScale);
        make.height.equalTo(@20);
    }];
    [self.view addSubview:self.inputPasswordLabel];
    [self.inputPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hintLabel.mas_top).offset(-10 * kScreenScale);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(120 * kScreenScale);
        make.right.equalTo(self.view).offset(-120 * kScreenScale);
        make.height.equalTo(@20);
    }];
}

#pragma mark - Private Method
- (void)openSetting {
    SHLockDetailViewController *lockDetailVC = [[SHLockDetailViewController alloc] initWithLockId:self.lockModel.lockId];
    [self.navigationController pushViewController:lockDetailVC animated:YES];
}

- (void)openLock {
    @weakify(self);
    [self showLoading:YES hint:@"开锁中"];
    [[SHLockManager sharedInstance] openLockWithId:[SHLockManager sharedInstance].currentLock.lockId password:@"123444" complete:^(BOOL succ, SHLockHttpStatusCode statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self showHint:@"开锁成功" duration:1.0];
            [self.houseImageView setImage:[UIImage imageNamed:@"sh_remote_home_unlocked"]];
        } else {
            [self showHint:info duration:1.0];
        }
    }];
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

- (void)keyboardController:(SHLockKeyboardViewController *)keyboardController didClickOpenLock:(id)info {
    if (info) {
        [self openLock];
    }
}

- (void)keyboardController:(SHLockKeyboardViewController *)keyboardController didClickClearInput:(id)info {
    [self.view endEditing:YES];
    [self.inputPasswordLabel setText:nil];
    self.inputString = nil;
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

- (UIImageView *)houseImageView {
    if (!_houseImageView) {
        _houseImageView = [[UIImageView alloc] init];
        _houseImageView.contentMode = UIViewContentModeCenter;
        _houseImageView.image = [UIImage imageNamed:@"sh_remote_home_locked"];
    }
    return _houseImageView;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_settingButton.titleLabel setFont:PingFangSCRegular(20 * kScreenScale)];
        [_settingButton addTarget:self
                           action:@selector(openSetting)
                 forControlEvents:UIControlEventTouchUpInside];
        if (!self.lockModel) {
            [_settingButton setHidden:YES];
        }
    }
    return _settingButton;
}

- (UITextField *)inputPasswordLabel {
    if (!_inputPasswordLabel) {
        _inputPasswordLabel = [[UITextField alloc] init];
        _inputPasswordLabel.font = PingFangSCRegular(15 * kScreenScale);
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
        _hintLabel.textColor = RGBCOLOR(0, 0, 0);
        _hintLabel.font = PingFangSCRegular(18 * kScreenScale);
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = @"输入密码";
    }
    return _hintLabel;
}

#pragma mark - VC Relative
- (NSString *)title {
    return self.lockModel.alias ?: @"远程开锁";
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [super createSHNavigationBar];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    [self.settingButton sizeToFit];
    [self.shNavigationItem setRightBarButtonItem:settingItem];
    return navigationBar;
}

@end
