//
//  SHRegisterViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/17.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHRegisterViewController.h"
#import "SHQRCodeScannerViewController.h"
#import "SHSecurityRegisterViewController.h"
#import "SHRegisterInputModel.h"

@interface SHRegisterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *cellphoneField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confrimPasswordField;
@property (nonatomic, strong) UITextField *mixedIdField; //网关Id或者注册码
@property (nonatomic, strong) UIButton *qrCodeButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) SHRegisterInputModel *inputModel;

@end

@implementation SHRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.cellphoneField];
    [self.cellphoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(100 * kScreenScale);
        make.right.equalTo(self.view).offset(-100 * kScreenScale);
        make.height.equalTo(@(40));
    }];
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellphoneField.mas_bottom).offset(30);
        make.left.right.equalTo(self.cellphoneField);
        make.height.equalTo(@(40));
    }];
    [self.view addSubview:self.confrimPasswordField];
    [self.confrimPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(30);
        make.left.right.equalTo(self.passwordField);
        make.height.equalTo(@(40));
    }];
    [self.view addSubview:self.mixedIdField];
    [self.mixedIdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confrimPasswordField.mas_bottom).offset(30);
        make.left.right.equalTo(self.confrimPasswordField);
        make.height.equalTo(@(40));
    }];
    [self.view addSubview:self.qrCodeButton];
    [self.qrCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mixedIdField.mas_bottom).offset(10);
        make.left.right.equalTo(self.mixedIdField);
        make.height.equalTo(@(50));
    }];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).offset(-50);
        make.size.mas_equalTo(CGSizeMake(100 * kScreenScale, 60 * kScreenScale));
    }];
}

#pragma mark - Private Method
- (void)openQRCodeScanner {
    SHQRCodeScannerViewController *qrScannerVC = [[SHQRCodeScannerViewController alloc] init];
    @weakify(self);
    qrScannerVC.scanHandler = ^(SHQRCodeScannerViewController *scannerVC, NSString *result) {
        @strongify(self);
        [self.mixedIdField setText:result ?: @"未扫描到结果"];
        [scannerVC dismiss];
    };
    [self.navigationController pushViewController:qrScannerVC animated:YES];
}

- (BOOL)canOpenNextStep {
    if (!self.cellphoneField.text || !self.cellphoneField.text.length) {
        [self showHint:@"请输入手机号" duration:1.0];
        return NO;
    }
    if (!self.passwordField.text || !self.passwordField.text.length) {
        [self showHint:@"请输入密码" duration:1.0];
        return NO;
    }
    if (!self.confrimPasswordField.text || !self.confrimPasswordField.text.length) {
        [self showHint:@"请输入确认密码" duration:1.0];
        return NO;
    }
    if (![self.confrimPasswordField.text isEqualToString:self.passwordField.text]) {
        [self showHint:@"两次密码输入不一致" duration:1.0];
        return NO;
    }
    if (!self.mixedIdField.text || !self.mixedIdField.text.length) {
        [self showHint:@"请输入网关Id或者注册码" duration:1.0];
        return NO;
    }
    [self.inputModel setCellphone:self.cellphoneField.text];
    [self.inputModel setPassword:self.passwordField.text];
    [self.inputModel setMixedId:self.mixedIdField.text];
    return YES;
}

- (void)openSecurityQuestion {
    if ([self canOpenNextStep]) {
        SHSecurityRegisterViewController *securityVC = [[SHSecurityRegisterViewController alloc] init];
        securityVC.userInfo = self.inputModel;
        [self.navigationController pushViewController:securityVC animated:YES];
    }
}

#pragma mark - Lazy Load
- (UITextField *)cellphoneField {
    if (!_cellphoneField) {
        _cellphoneField = [[UITextField alloc] init];
        _cellphoneField.delegate = self;
        _cellphoneField.placeholder = @"手机号";
        _cellphoneField.textAlignment = NSTextAlignmentCenter;
        [_cellphoneField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_cellphoneField.layer setBorderWidth:px];
    }
    return _cellphoneField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.delegate = self;
        _passwordField.placeholder = @"密码";
        _passwordField.textAlignment = NSTextAlignmentCenter;
        [_passwordField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_passwordField.layer setBorderWidth:px];
    }
    return _passwordField;
}

- (UITextField *)confrimPasswordField {
    if (!_confrimPasswordField) {
        _confrimPasswordField = [[UITextField alloc] init];
        _confrimPasswordField.delegate = self;
        _confrimPasswordField.placeholder = @"确认密码";
        _confrimPasswordField.textAlignment = NSTextAlignmentCenter;
        [_confrimPasswordField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_confrimPasswordField.layer setBorderWidth:px];
    }
    return _confrimPasswordField;
}

- (UITextField *)mixedIdField {
    if (!_mixedIdField) {
        _mixedIdField = [[UITextField alloc] init];
        _mixedIdField.delegate = self;
        _mixedIdField.placeholder = @"网关Id或者注册码";
        _mixedIdField.textAlignment = NSTextAlignmentCenter;
        [_mixedIdField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_mixedIdField.layer setBorderWidth:px];
    }
    return _mixedIdField;
}

- (UIButton *)qrCodeButton {
    if (!_qrCodeButton) {
        _qrCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrCodeButton setTitle:@"扫码" forState:UIControlStateNormal];
        [_qrCodeButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_qrCodeButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_qrCodeButton.layer setBorderWidth:px];
        [_qrCodeButton addTarget:self
                          action:@selector(openQRCodeScanner)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_nextButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_nextButton.layer setBorderWidth:px];
        [_nextButton addTarget:self
                        action:@selector(openSecurityQuestion)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (SHRegisterInputModel *)inputModel {
    if (!_inputModel) {
        _inputModel = [[SHRegisterInputModel alloc] init];
    }
    return _inputModel;
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"注册";
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)hideNavigationBar {
    return YES;
}

@end
