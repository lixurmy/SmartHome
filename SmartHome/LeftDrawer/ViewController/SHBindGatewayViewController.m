//
//  SHBindGatewayViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/27.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBindGatewayViewController.h"

@interface SHBindGatewayViewController ()

@property (nonatomic, strong) UITextField *bindGatewayField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation SHBindGatewayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    [self.view addSubview:self.bindGatewayField];
    [self.bindGatewayField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bindGatewayField).offset(30);
        make.right.equalTo(self.bindGatewayField).offset(-30);
        make.top.equalTo(self.bindGatewayField.mas_bottom).offset(30);
        make.height.equalTo(@(50));
    }];
}

#pragma mark - Private
- (void)bindGateway {
    [self.bindGatewayField endEditing:YES];
    NSString *gatewayId = self.bindGatewayField.text;
    if (!gatewayId || !gatewayId.length) {
        [self showHint:@"请输入网关Id" duration:1.0];
        return;
    }
    @weakify(self);
    [[SHUserManager sharedInstance] bindGatewayWithId:gatewayId complete:^(BOOL succ, SHLoginOrRegisterStatus statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self showHint:@"绑定成功" duration:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        } else {
            [self showHint:@"绑定失败" duration:1.0];
        }
    }];
}

#pragma mark - Get
- (UITextField *)bindGatewayField {
    if (!_bindGatewayField) {
        _bindGatewayField = [[UITextField alloc] init];
        [_bindGatewayField.layer setBorderWidth:1.0];
        [_bindGatewayField.layer setBorderColor:RGBCOLOR(111, 111, 111).CGColor];
        _bindGatewayField.font = PingFangSCRegular(20);
        _bindGatewayField.placeholder = @"输入网关Id";
    }
    return _bindGatewayField;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton.layer setBorderWidth:1.0];
        [_confirmButton.layer setBorderColor:RGBCOLOR(111, 111, 111).CGColor];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(bindGateway)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"绑定网关";
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
