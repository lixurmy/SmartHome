//
//  SHSecurityRegisterViewController.m
//  SmartHome
//
//  Created by Xu.Li on 2017/7/7.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSecurityRegisterViewController.h"
#import "SHSecurityQuestionManager.h"
#import "SHSecurityQuestionModel.h"

@interface SHSecurityRegisterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *firstQuestionButton;
@property (nonatomic, strong) UIButton *secondQuestionButton;
@property (nonatomic, strong) UIButton *thirdQuestionButton;
@property (nonatomic, strong) UITextField *firstField;
@property (nonatomic, strong) UITextField *secondField;
@property (nonatomic, strong) UITextField *thirdField;
@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation SHSecurityRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    CGFloat hSpace = 20;
    CGFloat height = 50;
    [self.view addSubview:self.firstQuestionButton];
    [self.firstQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight + hSpace);
        make.left.equalTo(self.view).offset(hSpace);
        make.right.equalTo(self.view).offset(-hSpace);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.firstField];
    [self.firstField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstQuestionButton.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.firstQuestionButton);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.secondQuestionButton];
    [self.secondQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstField.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.firstField);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.secondField];
    [self.secondField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondQuestionButton.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.secondQuestionButton);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.thirdQuestionButton];
    [self.thirdQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondField.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.secondField);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.thirdField];
    [self.thirdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdQuestionButton.mas_bottom).offset(hSpace);
        make.left.right.equalTo(self.thirdQuestionButton);
        make.height.equalTo(@(height));
    }];
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdField.mas_bottom).offset(2 * hSpace);
        make.left.right.equalTo(self.thirdField);
        make.height.equalTo(@(height));
    }];
}

- (void)showQuestionAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择密保问题" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [self setupActionSheetForAlert:alert button:sender];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupActionSheetForAlert:(UIAlertController *)alert button:(UIButton *)button {
    for (NSUInteger index = 0; index < [SHSecurityQuestionManager sharedInstance].questions.count; ++index) {
        SHSecurityQuestionModel *questionModel = [SHSecurityQuestionManager sharedInstance].questions[index];
        if (!questionModel.selected) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:questionModel.question style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (button.tag != -1) {
                    SHSecurityQuestionModel *selectedModel = [SHSecurityQuestionManager sharedInstance].questions[button.tag];
                    selectedModel.selected = NO;
                }
                [button setTitle:questionModel.question forState:UIControlStateNormal];
                button.tag = index;
                questionModel.selected = YES;
            }];
            [alert addAction:action];
        }
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
}

- (UIButton *)commonQuestionButtonWithIndex:(NSUInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = -1;
    NSString *title = [NSString stringWithFormat:@"问题%ld:请选择密保问题", index];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
    [button.layer setCornerRadius:15];
    [button.layer setBorderWidth:px];
    [button.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
    [button addTarget:self
               action:@selector(showQuestionAction:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UITextField *)commonQuestionField {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入密保问题答案";
    [textField.layer setCornerRadius:15];
    [textField.layer setBorderWidth:px];
    [textField.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
    textField.delegate = self;
    return textField;
}

#pragma mark - 
- (void)registerAction:(UIButton *)sender {
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

#pragma mark - Lazy Load
- (UIButton *)firstQuestionButton {
    if (!_firstQuestionButton) {
        _firstQuestionButton = [self commonQuestionButtonWithIndex:1];
    }
    return _firstQuestionButton;
}

- (UIButton *)secondQuestionButton {
    if (!_secondQuestionButton) {
        _secondQuestionButton = [self commonQuestionButtonWithIndex:2];
    }
    return _secondQuestionButton;
}

- (UIButton *)thirdQuestionButton {
    if (!_thirdQuestionButton) {
        _thirdQuestionButton = [self commonQuestionButtonWithIndex:3];
    }
    return _thirdQuestionButton;
}

- (UITextField *)firstField {
    if (!_firstField) {
        _firstField = [self commonQuestionField];
    }
    return _firstField;
}

- (UITextField *)secondField {
    if (!_secondField) {
        _secondField = [self commonQuestionField];
    }
    return _secondField;
}

- (UITextField *)thirdField {
    if (!_thirdField) {
        _thirdField = [self commonQuestionField];
    }
    return _thirdField;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton.layer setCornerRadius:15];
        [_registerButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_registerButton.layer setBorderWidth:px];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:RGBCOLOR(33, 33, 33) forState:UIControlStateDisabled];
        [_registerButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_registerButton addTarget:self
                            action:@selector(registerAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_registerButton setEnabled:NO];
    }
    return _registerButton;
}

#pragma mark - VC Relative
- (BOOL)autoGenerateBackItem {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"密保问题";
}

- (void)dismiss {
    [super dismiss];
    [[SHSecurityQuestionManager sharedInstance] resetAllQuestions];
}

@end
