//
//  SHSetLockPasswordViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/30.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSetLockPasswordViewController.h"
#import "SHRemoteLockManager.h"

@interface SHSetLockPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *originPasswordField;
@property (nonatomic, strong) UITextField *changedPasswordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation SHSetLockPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    [self.view setBackgroundColor:RGBCOLOR(255, 255, 255)];
    if ([SHRemoteLockManager sharedInstance].lockPassword) {
        [self.view addSubview:self.originPasswordField];
        [self.originPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(100);
            make.centerX.equalTo(self.view);
            make.left.equalTo(self.view).offset(30);
            make.right.equalTo(self.view).offset(-30);
        }];
        [self.view addSubview:self.changedPasswordField];
        [self.changedPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.originPasswordField.mas_bottom).offset(30);
            make.left.right.equalTo(self.originPasswordField);
        }];
        [self.view addSubview:self.confirmPasswordField];
        [self.confirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.changedPasswordField.mas_bottom).offset(30);
            make.left.right.equalTo(self.changedPasswordField);
        }];
    } else {
        [self.view addSubview:self.changedPasswordField];
        [self.changedPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(100);
            make.centerX.equalTo(self.view);
            make.left.equalTo(self.view).offset(30);
            make.right.equalTo(self.view).offset(-30);
        }];
        [self.view addSubview:self.confirmPasswordField];
        [self.confirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.changedPasswordField.mas_bottom).offset(30);
            make.left.right.equalTo(self.changedPasswordField);
        }];
    }
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordField.mas_bottom).offset(30);
        make.left.equalTo(self.confirmPasswordField).offset(30);
        make.right.equalTo(self.confirmPasswordField).offset(-30);
        make.height.equalTo(@(50));
    }];
}

#pragma mark - Private
- (void)changePassword {
    [self.view endEditing:YES];
    NSString *originPassword = self.originPasswordField.text;
    NSString *changedPassword = self.changedPasswordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    if ([SHRemoteLockManager sharedInstance].lockPassword && (!originPassword || !originPassword.length)) {
        [self showHint:@"请输入原密码" duration:1.0];
        return;
    }
    if (!changedPassword || !changedPassword.length) {
        [self showHint:@"请输入新密码" duration:1.0];
        return;
    }
    if (![changedPassword isEqualToString:confirmPassword]) {
        [self showHint:@"两次密码不一致" duration:1.0];
        [self.confirmPasswordField becomeFirstResponder];
        return;
    }
    if (![SHRemoteLockManager sharedInstance].lockPassword) {
        [[SHRemoteLockManager sharedInstance] updateLockPassword:changedPassword];
        [self showHint:@"设置成功" duration:1.0];
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self dismiss];
        });
    } else {
        if ([originPassword isEqualToString:[SHRemoteLockManager sharedInstance].lockPassword]) {
            [[SHRemoteLockManager sharedInstance] updateLockPassword:changedPassword];
            [self showHint:@"设置成功" duration:1.0];
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self dismiss];
            });
        } else {
            [self showHint:@"原开锁密码验证失败" duration:1.0];
        }
    }
}

#pragma mark - Get
- (UITextField *)originPasswordField {
    if (!_originPasswordField) {
        _originPasswordField = [[UITextField alloc] init];
        [_originPasswordField.layer setBorderWidth:1.0];
        [_originPasswordField.layer setBorderColor:RGBCOLOR(111,111,111).CGColor];
        _originPasswordField.font = PingFangSCRegular(20);
        _originPasswordField.secureTextEntry = YES;
        _originPasswordField.placeholder = @"输入原密码";
        _originPasswordField.delegate = self;
    }
    return _originPasswordField;
}

- (UITextField *)changedPasswordField {
    if (!_changedPasswordField) {
        _changedPasswordField = [[UITextField alloc] init];
        [_changedPasswordField.layer setBorderWidth:1.0];
        [_changedPasswordField.layer setBorderColor:RGBCOLOR(111, 111, 111).CGColor];
        _changedPasswordField.font = PingFangSCRegular(20);
        _changedPasswordField.secureTextEntry = YES;
        _changedPasswordField.placeholder = @"输入新密码";
        _changedPasswordField.delegate = self;
    }
    return _changedPasswordField;
}

- (UITextField *)confirmPasswordField {
    if (!_confirmPasswordField) {
        _confirmPasswordField = [[UITextField alloc] init];
        [_confirmPasswordField.layer setBorderWidth:1.0];
        [_confirmPasswordField.layer setBorderColor:RGBCOLOR(111, 111, 111).CGColor];
        _confirmPasswordField.font = PingFangSCRegular(20);
        _confirmPasswordField.secureTextEntry = YES;
        _confirmPasswordField.placeholder = @"确认新密码";
        _confirmPasswordField.delegate = self;
    }
    return _confirmPasswordField;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"设置开锁密码" forState:UIControlStateNormal];
        [_confirmButton.layer setBorderWidth:1.0];
        [_confirmButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_confirmButton.layer setBorderColor:RGBCOLOR(111, 111, 111).CGColor];
        [_confirmButton addTarget:self
                           action:@selector(changePassword)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"开锁密码";
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [super createSHNavigationBar];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.title];
    [item setLeftBarButtonItem:cancelItem];
    [navigationBar setItems:@[item]];
    return navigationBar;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
