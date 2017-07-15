//
//  SHAddKeyViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHAddKeyViewController.h"
#import "SHKeyManager.h"
#import "SHKeyModel.h"
#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"

@interface SHAddKeyViewController () <UITextFieldDelegate, sendTheValueDelegate>

@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, assign) SHKeyType addKeyType;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) BOOL isStartTime;

@property (nonatomic, strong) UITextField *aliasField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;
@property (nonatomic, strong) UITextField *timesLimitField;
@property (nonatomic, strong) UIButton *alertKeyButton;
@property (nonatomic, strong) UIButton *addKeyButton;
@property (nonatomic, strong) UIButton *startTimeButton;
@property (nonatomic, strong) UIButton *endTimeButton;

@end

@implementation SHAddKeyViewController

- (instancetype)initWithLockId:(NSString *)lockId {
    self = [super init];
    if (self) {
        _lockId = lockId;
    }
    return self;
}

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showKeyTypeAlert];
}

- (void)showKeyTypeAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择要添加的钥匙类型" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *userTypeAction = [UIAlertAction actionWithTitle:@"普通用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupViewWithType:SHKeyTypeUser];
    }];
    UIAlertAction *tempTypeAction = [UIAlertAction actionWithTitle:@"临时钥匙" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupViewWithType:SHKeyTypeTemp];
    }];
    [alert addAction:userTypeAction];
    [alert addAction:tempTypeAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupViewWithType:(SHKeyType)keyType {
    CGFloat hSpace = 30 * kScreenScale;
    CGFloat height = 50 * kScreenScale;
    self.addKeyType = keyType;
    [self setupView];
    if (self.addKeyType == SHKeyTypeUser) {
        [self.view addSubview:self.addKeyButton];
        [self.addKeyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertKeyButton.mas_bottom).offset(hSpace);
            make.left.right.equalTo(self.alertKeyButton);
            make.height.equalTo(@(height));
        }];
    } else { //目前只有临时用户和普通用户
        hSpace = hSpace / 2;
        [self.view addSubview:self.timesLimitField];
        [self.timesLimitField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertKeyButton.mas_bottom).offset(hSpace);
            make.left.right.equalTo(self.alertKeyButton);
            make.height.equalTo(@(height));
        }];
        [self.view addSubview:self.startTimeButton];
        [self.startTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timesLimitField.mas_bottom).offset(hSpace);
            make.left.right.equalTo(self.timesLimitField);
            make.height.equalTo(@(height));
        }];
        [self.view addSubview:self.endTimeButton];
        [self.endTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startTimeButton.mas_bottom).offset(hSpace);
            make.left.right.equalTo(self.startTimeButton);
            make.height.equalTo(@(height));
        }];
        [self.view addSubview:self.addKeyButton];
        [self.addKeyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.endTimeButton.mas_bottom).offset(hSpace);
            make.left.right.equalTo(self.endTimeButton);
            make.height.equalTo(@(height));
        }];
    }
}

- (void)setupView {
    CGFloat hSpace = 30 * kScreenScale;
    CGFloat height = 50 * kScreenScale;
    if (self.addKeyType == SHKeyTypeTemp) {
        hSpace = hSpace / 2;
    }
    [self.view addSubview:self.aliasField];
    [self.aliasField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight + hSpace);
        make.left.equalTo(self.view).offset(hSpace);
        make.right.equalTo(self.view).offset(-hSpace);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliasField.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.aliasField);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.confirmPasswordField];
    [self.confirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.passwordField);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.alertKeyButton];
    [self.alertKeyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordField.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.confirmPasswordField);
        make.height.equalTo(@(height));
    }];
}

#pragma mark - Private
- (void)alertKeyButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)addKeyAction:(UIButton *)sender {
    if (![self canSubmitAddKeyAction]) {
        return;
    }
    @weakify(self);
    [self showLoading:YES hint:@"正在添加..."];
    [[SHKeyManager sharedInstance] addKeyForLock:self.lockId password:self.passwordField.text keyType:self.addKeyType active:YES alias:self.aliasField.text keyNo:@"" alert:self.alertKeyButton.selected complete:^(BOOL succ, SHKeyHttpStatus statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self showHint:@"设置成功" duration:1.0];
            [self dismiss];
        } else {
            [self showHint:@"添加失败" duration:1.0];
        }
    }];
}

- (void)startTimeAction:(UIButton *)sender {
    self.isStartTime = YES;
    FDAlertView *alert = [[FDAlertView alloc] init];
    RBCustomDatePickerView *contentView = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    contentView.delegate = self;
    alert.contentView = contentView;
    [alert.contentView.layer setCornerRadius:20];
    [alert show];
}

- (void)endTimeAction:(UIButton *)sender {
    self.isStartTime = NO;
    FDAlertView *alert = [[FDAlertView alloc] init];
    RBCustomDatePickerView *contentView = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    contentView.delegate = self;
    alert.contentView = contentView;
    [alert.contentView.layer setCornerRadius:20];
    [alert show];
}

- (BOOL)canSubmitAddKeyAction {
    if (!self.aliasField.text.length) {
        [self showHint:@"请填写钥匙名称" duration:1.0];
        return NO;
    }
    if (!self.passwordField.text.length) {
        [self showHint:@"请设置开锁密码" duration:1.0];
        return NO;
    }
    if (!self.confirmPasswordField.text.length) {
        [self showHint:@"请确认开锁密码" duration:1.0];
        return NO;
    }
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        [self showHint:@"两次密码不一致" duration:1.0];
        return NO;
    }
    if (!(self.addKeyType == SHKeyTypeTemp)) {
        return YES;
    }
    if (!self.timesLimitField.text.length && !self.startTime && !self.endTime) {
        [self showHint:@"请设置临时钥匙次数或有效时间段" duration:1.0];
        return NO;
    }
    if (self.timesLimitField.text.length) {
        return YES;
    }
    if (!self.startTime) {
        [self showHint:@"请设置临时钥匙次数或有效时间段" duration:1.0];
        return NO;
    }
    if (!self.endTime) {
        [self showHint:@"请设置临时钥匙失效时间" duration:1.0];
        return NO;
    }
    return YES;
}

#pragma mark - sendTheValueDelegate
- (void)getTimeToValue:(NSString *)theTimeStr {
    if (self.isStartTime) {
        self.startTime = theTimeStr;
        [self.startTimeButton setTitle:self.startTime forState:UIControlStateNormal];
    } else {
        self.endTime = theTimeStr;
        [self.endTimeButton setTitle:self.endTime forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy Load
- (UITextField *)aliasField {
    if (!_aliasField) {
        _aliasField = [[UITextField alloc] init];
        [_aliasField.layer setCornerRadius:15];
        [_aliasField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_aliasField.layer setBorderWidth:px];
        _aliasField.textAlignment = NSTextAlignmentCenter;
        _aliasField.placeholder = @"请填写钥匙名称";
    }
    return _aliasField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        [_passwordField.layer setCornerRadius:15];
        _passwordField.delegate = self;
        _passwordField.placeholder = @"密码";
        _passwordField.secureTextEntry = YES;
        _passwordField.textAlignment = NSTextAlignmentCenter;
        [_passwordField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_passwordField.layer setBorderWidth:px];
    }
    return _passwordField;
}

- (UITextField *)confirmPasswordField {
    if (!_confirmPasswordField) {
        _confirmPasswordField = [[UITextField alloc] init];
        [_confirmPasswordField.layer setCornerRadius:15];
        _confirmPasswordField.delegate = self;
        _confirmPasswordField.secureTextEntry = YES;
        _confirmPasswordField.placeholder = @"确认密码";
        _confirmPasswordField.textAlignment = NSTextAlignmentCenter;
        [_confirmPasswordField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_confirmPasswordField.layer setBorderWidth:px];
    }
    return _confirmPasswordField;
}

- (UITextField *)timesLimitField {
    if (!_timesLimitField) {
        _timesLimitField = [[UITextField alloc] init];
        [_timesLimitField.layer setCornerRadius:15];
        [_timesLimitField.layer setBorderWidth:px];
        [_timesLimitField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        _timesLimitField.delegate = self;
        _timesLimitField.placeholder = @"请设置密码有效次数";
        _timesLimitField.textAlignment = NSTextAlignmentCenter;
    }
    return _timesLimitField;
}

- (UIButton *)alertKeyButton {
    if (!_alertKeyButton) {
        _alertKeyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertKeyButton.layer setCornerRadius:15];
        [_alertKeyButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_alertKeyButton.layer setBorderWidth:px];
        [_alertKeyButton setTitle:@"警报钥匙已关闭" forState:UIControlStateNormal];
        [_alertKeyButton setTitle:@"警报钥匙已开启" forState:UIControlStateSelected];
        [_alertKeyButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_alertKeyButton addTarget:self
                            action:@selector(alertKeyButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertKeyButton;
}

- (UIButton *)addKeyButton {
    if (!_addKeyButton) {
        _addKeyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addKeyButton.layer setCornerRadius:15];
        [_addKeyButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_addKeyButton.layer setBorderWidth:px];
        [_addKeyButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_addKeyButton setTitle:@"确认添加" forState:UIControlStateNormal];
        [_addKeyButton addTarget:self
                          action:@selector(addKeyAction:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _addKeyButton;
}

- (UIButton *)startTimeButton {
    if (!_startTimeButton) {
        _startTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startTimeButton.layer setCornerRadius:15];
        [_startTimeButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_startTimeButton.layer setBorderWidth:px];
        [_startTimeButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_startTimeButton setTitle:@"选择钥匙生效时间" forState:UIControlStateNormal];
        [_startTimeButton addTarget:self
                             action:@selector(startTimeAction:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _startTimeButton;
}

- (UIButton *)endTimeButton {
    if (!_endTimeButton) {
        _endTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endTimeButton.layer setCornerRadius:15];
        [_endTimeButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_endTimeButton.layer setBorderWidth:px];
        [_endTimeButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_endTimeButton setTitle:@"选择钥匙失效时间" forState:UIControlStateNormal];
        [_endTimeButton addTarget:self
                           action:@selector(endTimeAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _endTimeButton;
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"添加钥匙";
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)autoGenerateBackItem {
    return YES;
}

@end
