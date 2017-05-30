//
//  SHSetOfflinePasswordViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/30.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSetOfflinePasswordViewController.h"
#import "SHRemoteLockManager.h"

@interface SHSetOfflinePasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *originPasswordField;
@property (nonatomic, strong) UITextField *changedPasswordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation SHSetOfflinePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    [self.view setBackgroundColor:RGBCOLOR(255, 255, 255)];
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
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordField.mas_bottom).offset(30);
        make.left.equalTo(self.confirmPasswordField).offset(30);
        make.right.equalTo(self.confirmPasswordField).offset(-30);
        make.height.equalTo(@(50));
    }];
}

#pragma mark - Private
- (void)updateOfflinePassword {
    [self.view endEditing:YES];
    NSString *originPassword = self.originPasswordField.text;
    NSString *changedPassword = self.changedPasswordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    if (!originPassword || !originPassword.length) {
        [self showHint:@"请输入开锁密码" duration:1.0];
        return;
    }
    if (!changedPassword || !changedPassword.length) {
        [self showHint:@"请输入离线密码" duration:1.0];
        return;
    }
    if (![changedPassword isEqualToString:confirmPassword]) {
        [self showHint:@"两次密码不一致" duration:1.0];
        [self.confirmPasswordField becomeFirstResponder];
        return;
    }
    if (![originPassword isEqualToString:[SHRemoteLockManager sharedInstance].lockPassword]) {
        [self showHint:@"开锁密码验证失败" duration:1.0];
        return;
    }
    if (changedPassword.length != 6) {
        [self showHint:@"离线密码必须为6位数字" duration:1.0];
        return;
    }
    @weakify(self);
    [[SHRemoteLockManager sharedInstance] updateOfflinePassword:confirmPassword phone:[SHRemoteLockManager sharedInstance].bindPhone gatewayId:[SHUserManager sharedInstance].gatewayId startTime:[SHRemoteLockManager sharedInstance].startTime endTime:[SHRemoteLockManager sharedInstance].endTime usableTime:10 complete:^(BOOL succ, SHRemoteLockBindStatus statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self showHint:@"设置离线密码成功" duration:1.0];
        } else {
            [self showHint:@"设置离线密码失败" duration:1.0];
        }
    }];
}

#pragma mark - Get
- (UITextField *)originPasswordField {
    if (!_originPasswordField) {
        _originPasswordField = [[UITextField alloc] init];
        [_originPasswordField.layer setBorderWidth:1.0];
        [_originPasswordField.layer setBorderColor:RGBCOLOR(111,111,111).CGColor];
        _originPasswordField.font = PingFangSCRegular(20);
        _originPasswordField.secureTextEntry = YES;
        _originPasswordField.placeholder = @"验证开锁密码";
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
        _changedPasswordField.placeholder = @"设置离线密码";
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
        _confirmPasswordField.placeholder = @"确认离线密码";
        _confirmPasswordField.delegate = self;
    }
    return _confirmPasswordField;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"设置离线密码" forState:UIControlStateNormal];
        [_confirmButton.layer setBorderWidth:1.0];
        [_confirmButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_confirmButton.layer setBorderColor:RGBCOLOR(111, 111, 111).CGColor];
        [_confirmButton addTarget:self
                           action:@selector(updateOfflinePassword)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"离线密码";
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
