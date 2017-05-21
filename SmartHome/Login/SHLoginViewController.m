//
//  SHLoginViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/13.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLoginViewController.h"
#import "SHHomeViewController.h"
#import "SHRootViewController.h"

static NSString * kSHLastInputUsernameKey = @"kSHLastInputUsernameKey";

@interface SHLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UILabel *confirmPasswordLabel;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) UIButton *registerAccountButton;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPassword;
@property (nonatomic, copy) NSString *changedPassword;
@property (nonatomic, copy) NSString *changedConfirmPassword;

@end

@implementation SHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFields];
    [self setupButtons];
    [self.view setBackgroundColor:RGBCOLOR(0, 0, 255)];
}

- (void)setupFields {
    self.usernameLabel.text = @"账号";
    self.usernameLabel.textColor = RGBCOLOR(255, 255, 255);
    [self.usernameLabel setFont:PingFangSCRegular(24)];
    [self.view addSubview:self.usernameLabel];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(60);
        make.width.equalTo(@50);
    }];
    [self.usernameField setFont:PingFangSCRegular(24)];
    [self.usernameField setBackgroundColor:RGBCOLOR(222, 222, 222)];
    [self.view addSubview:self.usernameField];
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.usernameLabel);
        make.left.lessThanOrEqualTo(self.usernameLabel.mas_right).offset(30);
        make.right.greaterThanOrEqualTo(self.view).offset(-60);
    }];
    self.passwordLabel.text = @"密码";
    self.passwordLabel.textColor = RGBCOLOR(255, 255, 255);
    [self.passwordLabel setFont:PingFangSCRegular(24)];
    [self.view addSubview:self.passwordLabel];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(20);
    }];
    [self.passwordField setFont:PingFangSCRegular(24)];
    [self.passwordField setBackgroundColor:RGBCOLOR(222, 222, 222)];
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordLabel);
        make.left.equalTo(self.usernameField);
        make.right.equalTo(self.usernameField);
    }];
    self.confirmPasswordLabel.text = @"密码";
    self.confirmPasswordLabel.textColor = RGBCOLOR(255, 255, 255);
    [self.confirmPasswordLabel setFont:PingFangSCRegular(24)];
    [self.confirmPasswordLabel setHidden:YES];
    [self.view addSubview:self.confirmPasswordLabel];
    [self.confirmPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordLabel);
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(20);
    }];
    [self.confirmPasswordField setFont:PingFangSCRegular(24)];
    [self.confirmPasswordField setBackgroundColor:RGBCOLOR(222, 222, 222)];
    [self.confirmPasswordField setHidden:YES];
    [self.view addSubview:self.confirmPasswordField];
    [self.confirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(20);
    }];
}

- (void)setupButtons {
    [self.loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [self.loginButton.titleLabel setFont:PingFangSCMedium(36)];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
    [self.loginButton addTarget:self
                         action:@selector(login)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [self.forgetPasswordButton.titleLabel setFont:PingFangSCRegular(20)];
    [self.view addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(100);
        make.top.equalTo(self.loginButton.mas_bottom).offset(30);
    }];
    [self.forgetPasswordButton addTarget:self
                                  action:@selector(forgetPassword)
                        forControlEvents:UIControlEventTouchUpInside];
    
    self.verticalLine = [[UIView alloc] init];
    [self.verticalLine setBackgroundColor:RGBCOLOR(255, 255, 255)];
    [self.view addSubview:self.verticalLine];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginButton);
        make.centerY.equalTo(self.forgetPasswordButton);
        make.width.equalTo(@1);
        make.height.equalTo(@20);
    }];
    [self.registerAccountButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [self.registerAccountButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [self.registerButton.titleLabel setFont:PingFangSCRegular(20)];
    [self.view addSubview:self.registerAccountButton];
    [self.registerAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-100);
        make.top.equalTo(self.forgetPasswordButton);
    }];
    [self.registerAccountButton addTarget:self
                            action:@selector(registerAccountButtonAction)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [self.registerButton.titleLabel setFont:PingFangSCMedium(24)];
    [self.registerButton setHidden:YES];
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(120);
        make.top.equalTo(self.confirmPasswordField.mas_bottom).offset(40);
    }];
    [self.registerButton addTarget:self
                            action:@selector(registerButtonAction)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:PingFangSCMedium(24)];
    [self.cancelButton setHidden:YES];
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.registerButton);
        make.right.equalTo(self.view).offset(-120);
    }];
    [self.cancelButton addTarget:self
                          action:@selector(cancelButtonAction)
                forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private Method
- (void)login {
    self.username = [self.usernameField text];
    self.password = [self.passwordField text];
    if (!self.username || ![self.username length]) {
        [self showHint:@"请输入手机号" duration:1.0];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:kSHLastInputUsernameKey];
    if (!self.password || ![self.password length]) {
        [self showHint:@"请输入密码" duration:1.0];
        return;
    }
    [self showLoading:YES hint:@"登陆中..."];
    @weakify(self);
    [[SHUserManager sharedInstance] loginWithUsername:self.username password:self.password complete:^(BOOL succ, SHLoginOrRegisterStatus statusCode, id info) {
        @strongify(self);
        if (succ) {
            [SHUserManager sharedInstance].isLogin = YES;
            SHRootViewController *rootViewController = [[SHRootViewController alloc] init];
            [self.view.window setRootViewController:rootViewController];
            [self hideLoading:YES];
        } else {
            if (statusCode == 0) {
                [self showHint:@"服务器请求错误" duration:1.0];
            } else if (statusCode == SHLoginStatusPasswordWrong) {
                [self showHint:@"密码错误" duration:1.0];
            } else if (statusCode == SHLoginStatusUnRegistered) {
                [self showHint:@"手机号未注册" duration:1.0];
            } else if (statusCode == SHLoginStatusPasswordShouldChange) {
                [self showHint:@"账号有风险，请先修改密码" duration:1.0];
            }
        }
    }];
}

- (void)forgetPassword {
    if (!self.username) {
        [self showHint:@"请输入手机号哦" duration:1.0];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重置密码"
                                                                   message:@"将要重置密码，请确认"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self showLoading:YES hint:@"重置密码..."];
        [[SHUserManager sharedInstance] resetPasswordForUsername:self.username complete:^(BOOL succ, SHLoginOrRegisterStatus statusCode, id info) {
            if (succ) {
                [self hideLoading:YES];
                NSString *newPassword = (NSString *)info;
                [self resetPassword:newPassword];
            } else {
                if (statusCode == SHLoginStatusUnRegistered) {
                    [self showHint:@"未注册的号码" duration:1.0];
                } else {
                    [self showHint:@"重置密码失败" duration:1.0];
                }
            }
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetPassword:(NSString *)curPassword {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重置密码"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"设置新密码";
        textField.secureTextEntry = YES;
        textField.delegate = self;
        textField.tag = 1001;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"确认新密码";
        textField.secureTextEntry = YES;
        textField.delegate = self;
        textField.tag = 1002;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    @weakify(self);
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![self.changedConfirmPassword isEqualToString:self.changedPassword]) {
            return;
        }
        [self showLoading:YES hint:@"修改密码中..."];
        @strongify(self);
        [[SHUserManager sharedInstance] changePasswordForUsername:self.username oldPassword:curPassword newPassword:self.changedPassword complete:^(BOOL succ, SHLoginOrRegisterStatus statusCode, id info) {
            if (succ) {
                [self showHint:@"修改密码成功" duration:1.0];
            } else {
                if (statusCode == SHLoginStatusUnRegistered) {
                    [self showHint:@"未注册的号码" duration:1.0];
                } else if (statusCode == SHLoginStatusPasswordWrong) {
                    [self showHint:@"原密码输入错误" duration:1.0];
                } else {
                    [self showHint:@"服务器请求错误" duration:1.0];
                }
            }
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)registerAccountButtonAction {
    if ([self.registerAccountButton isHidden]) {
        return;
    }
    [self showRegisterUI:YES];
}

- (void)registerButtonAction {
    self.username = self.usernameField.text;
    self.password = self.passwordField.text;
    self.confirmPassword = self.confirmPasswordField.text;
    if (!self.username || ![self.username length]) {
        [self showHint:@"请输入手机号" duration:1.0];
        return;
    }
    if (!self.password || ![self.password length]) {
        [self showHint:@"请设置登录密码" duration:1.0];
        return;
    }
    if (![self.password isEqualToString:self.confirmPassword]) {
        [self showHint:@"登录密码不一致" duration:1.0];
        [self.confirmPasswordField becomeFirstResponder];
        return;
    }
    [self showLoading:YES hint:@"注册中..."];
    @weakify(self);
    [[SHUserManager sharedInstance] registerWithUsername:self.username password:self.password complete:^(BOOL succ, SHLoginOrRegisterStatus statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self showHint:@"注册成功" duration:1.0];
            [self showRegisterUI:NO];
        } else {
            if (statusCode == SHRegisterStatusAlreadyRegistered) {
                [self showHint:@"该手机号已注册" duration:1.0];
            } else {
                [self showHint:@"服务器请求错误" duration:1.0];
            }
        }
    }];
}

- (void)cancelButtonAction {
    if (![self.registerAccountButton isHidden]) {
        return;
    }
    [self showRegisterUI:NO];
}

- (void)showRegisterUI:(BOOL)shouldShow {
    [self.loginButton setHidden:shouldShow];
    [self.forgetPasswordButton setHidden:shouldShow];
    [self.registerAccountButton setHidden:shouldShow];
    [self.verticalLine setHidden:shouldShow];
    [self.confirmPasswordLabel setHidden:!shouldShow];
    [self.confirmPasswordField setHidden:!shouldShow];
    [self.registerButton setHidden:!shouldShow];
    [self.cancelButton setHidden:!shouldShow];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.changedPassword = textField.text;
    } else if (textField.tag == 1002) {
        if (![textField.text isEqualToString:self.changedPassword]) {
            [self showHint:@"两次密码不一致哦" duration:1.0];
            textField.text = @"";
        } else {
            self.changedConfirmPassword = textField.text;
        }
    }
}

#pragma mark - Get
- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
    }
    return _usernameLabel;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
    }
    return _passwordLabel;
}

- (UILabel *)confirmPasswordLabel {
    if (!_confirmPasswordLabel) {
        _confirmPasswordLabel = [[UILabel alloc] init];
    }
    return _confirmPasswordLabel;
}

- (UITextField *)usernameField {
    if (!_usernameField) {
        NSString *lastInputUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kSHLastInputUsernameKey];
        _usernameField = [[UITextField alloc] init];
        _usernameField.placeholder = @"手机号";
        _usernameField.delegate = self;
        RAC(self, username) = RACObserve(_usernameField, text);
        if (lastInputUsername) {
            _usernameField.text = lastInputUsername;
        }
    }
    return _usernameField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.placeholder = @"请输入登录密码";
        _passwordField.keyboardType = UIKeyboardTypeAlphabet;
        _passwordField.secureTextEntry = YES;
        _passwordField.delegate = self;
        RAC(self, password) = RACObserve(_passwordField, text);
    }
    return _passwordField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _loginButton;
}

- (UIButton *)forgetPasswordButton {
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _forgetPasswordButton;
}

- (UIButton *)registerAccountButton {
    if (!_registerAccountButton) {
        _registerAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _registerAccountButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    }
    return _registerButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _cancelButton;
}

- (UITextField *)confirmPasswordField {
    if (!_confirmPasswordField) {
        _confirmPasswordField = [[UITextField alloc] init];
        _confirmPasswordField.placeholder = @"再次输入登录密码";
        _confirmPasswordField.delegate = self;
        _confirmPasswordField.secureTextEntry = YES;
        RAC(self, confirmPassword) = RACObserve(_confirmPasswordField, text);
    }
    return _confirmPasswordField;
}

@end
