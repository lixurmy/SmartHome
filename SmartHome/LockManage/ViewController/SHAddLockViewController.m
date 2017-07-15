//
//  SHAddLockViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHAddLockViewController.h"
#import "SHQRCodeScannerViewController.h"
#import "SHLockManager.h"

@interface SHAddLockViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *qrCodeButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, copy) NSString *lockMacAddress;

@end

@implementation SHAddLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight + 60);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@(50));
    }];
    [self.view addSubview:self.qrCodeButton];
    [self.qrCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.equalTo(self.inputField);
        make.height.equalTo(@(50));
    }];
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeButton.mas_bottom).offset(30);
        make.centerX.equalTo(self.qrCodeButton);
        make.left.right.equalTo(self.qrCodeButton);
        make.height.equalTo(@(50));
    }];
}

#pragma mark - Private Method
- (void)openQRCodeScanner {
    SHQRCodeScannerViewController *qrCodeScanner = [[SHQRCodeScannerViewController alloc] init];
    @weakify(self);
    qrCodeScanner.scanHandler = ^(SHQRCodeScannerViewController * qrCodeScanner, NSString *result) {
        @strongify(self);
        [qrCodeScanner dismiss];
        [self showHint:result duration:1.0];
        [self.inputField setText:result];
        [self addLock];
    };
}

- (void)addLock {
    [self.view endEditing:YES];
    [self showLoading:YES];
    @weakify(self);
    [[SHLockManager sharedInstance] addLockWithMacAddress:self.lockMacAddress alias:nil complete:^(BOOL succ, SHLockHttpStatusCode statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self showHint:@"添加成功" duration:1.0];
        } else {
            [self showHint:@"更新失败" duration:1.0];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.lockMacAddress = textField.text;
}

#pragma mark - Lazy Load
- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] init];
        _inputField.placeholder = @"输入Mac地址";
        _inputField.textAlignment = NSTextAlignmentCenter;
        _inputField.delegate = self;
        [_inputField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_inputField.layer setBorderWidth:px];
        [_inputField.layer setCornerRadius:15];
    }
    return _inputField;
}

- (UIButton *)qrCodeButton {
    if (!_qrCodeButton) {
        _qrCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrCodeButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_qrCodeButton.layer setBorderWidth:px];
        [_qrCodeButton.layer setCornerRadius:15];
        [_qrCodeButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_qrCodeButton setTitle:@"扫码添加" forState:UIControlStateNormal];
        [_qrCodeButton addTarget:self
                          action:@selector(openQRCodeScanner)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_addButton.layer setBorderWidth:px];
        [_addButton.layer setCornerRadius:15];
        [_addButton setTitle:@"确认" forState:UIControlStateNormal];
        [_addButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_addButton addTarget:self
                       action:@selector(addLock)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"添加新锁";
}

@end
