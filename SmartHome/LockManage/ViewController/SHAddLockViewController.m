//
//  SHAddLockViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHAddLockViewController.h"
#import "SHQRCodeScannerViewController.h"

@interface SHAddLockViewController ()

@property (nonatomic, strong) UIButton *qrCodeButton;

@end

@implementation SHAddLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.qrCodeButton];
    [self.qrCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
}

#pragma mark - Private Method
- (void)openQRCodeScanner {
    SHQRCodeScannerViewController *qrCodeScanner = [[SHQRCodeScannerViewController alloc] init];
    @weakify(self);
    qrCodeScanner.scanHandler = ^(SHQRCodeScannerViewController * qrCodeScanner, NSString *result) {
        @strongify(self);
        [self showHint:result duration:1.0];
        [qrCodeScanner dismiss];
    };
}

#pragma mark - Lazy Load
- (UIButton *)qrCodeButton {
    if (!_qrCodeButton) {
        _qrCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrCodeButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_qrCodeButton.layer setBorderWidth:px];
        [_qrCodeButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_qrCodeButton setTitle:@"扫码添加" forState:UIControlStateNormal];
        [_qrCodeButton addTarget:self
                          action:@selector(openQRCodeScanner)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeButton;
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
