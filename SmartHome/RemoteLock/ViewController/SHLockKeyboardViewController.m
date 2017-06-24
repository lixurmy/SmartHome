//
//  SHLockKeyboardViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/28.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockKeyboardViewController.h"

@interface SHLockKeyboardViewController ()

@end

@implementation SHLockKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBCOLOR(162, 162, 162)];
    [self setupButtons];
}

- (void)setupButtons {
    CGFloat wSpace = (kScreenWidth - 300 * kScreenScale) / 4;
    CGFloat hSpace = (kScreenHeight * 0.35 - 200 * kScreenScale)/3;
    CGSize size = CGSizeMake(100 * kScreenScale, 40 * kScreenScale);
    UIButton *zeroButton = [self createCommonButton:@"0"];
    [self.view addSubview:zeroButton];
    [zeroButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20 * kScreenScale);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(size);
    }];
    UIButton *twoButton = [self createCommonButton:@"2"];
    [self.view addSubview:twoButton];
    [twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zeroButton);
        make.top.equalTo(self.view).offset(20 * kScreenScale);
        make.size.mas_equalTo(size);
    }];
    UIButton *oneButton = [self createCommonButton:@"1"];
    [self.view addSubview:oneButton];
    [oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoButton);
        make.left.equalTo(self.view).offset(wSpace);
        make.size.mas_equalTo(size);
    }];
    UIButton *threeButton = [self createCommonButton:@"3"];
    [self.view addSubview:threeButton];
    [threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoButton);
        make.right.equalTo(self.view).offset(-wSpace);
        make.size.mas_equalTo(size);
    }];
    UIButton *fiveButton = [self createCommonButton:@"5"];
    [self.view addSubview:fiveButton];
    [fiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(twoButton);
        make.top.equalTo(twoButton.mas_bottom).offset(hSpace);
        make.size.mas_equalTo(size);
    }];
    UIButton *fourButton = [self createCommonButton:@"4"];
    [self.view addSubview:fourButton];
    [fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fiveButton);
        make.left.equalTo(self.view).offset(wSpace);
        make.size.mas_equalTo(size);
    }];
    UIButton *sixButton = [self createCommonButton:@"6"];
    [self.view addSubview:sixButton];
    [sixButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fiveButton);
        make.right.equalTo(self.view).offset(-wSpace);
        make.size.mas_equalTo(size);
    }];
    UIButton *eightButton = [self createCommonButton:@"8"];
    [self.view addSubview:eightButton];
    [eightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fiveButton);
        make.top.equalTo(fiveButton.mas_bottom).offset(hSpace);
        make.size.mas_equalTo(size);
    }];
    UIButton *sevenButton = [self createCommonButton:@"7"];
    [self.view addSubview:sevenButton];
    [sevenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eightButton);
        make.left.equalTo(self.view).offset(wSpace);
        make.size.mas_equalTo(size);
    }];
    UIButton *nineButton = [self createCommonButton:@"9"];
    [self.view addSubview:nineButton];
    [nineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eightButton);
        make.right.equalTo(self.view).offset(-wSpace);
        make.size.mas_equalTo(size);
    }];
    
    UIButton *openLockButton = [self createCommonButton:@"开锁"];
    [self.view addSubview:openLockButton];
    [openLockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zeroButton);
        make.left.equalTo(self.view).offset(wSpace);
        make.size.mas_equalTo(size);
    }];
    [openLockButton removeTarget:self
                          action:@selector(commonButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [openLockButton addTarget:self
                       action:@selector(openLockAction:)
             forControlEvents:UIControlEventTouchUpInside];
    UIButton *clearButton = [self createCommonButton:@"清空"];
    [self.view addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zeroButton);
        make.right.equalTo(self.view).offset(-wSpace);
        make.size.mas_equalTo(size);
    }];
    [clearButton removeTarget:self
                       action:@selector(commonButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
    [clearButton addTarget:self
                    action:@selector(clearInputAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Private Method
- (void)commonButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(keyboardController:didChangeOutput:)]) {
        [self.delegate keyboardController:self didChangeOutput:sender.titleLabel.text];
    }
}

- (void)openLockAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(keyboardController:didClickOpenLock:)]){
        [self.delegate keyboardController:self didClickOpenLock:sender];
    }
}

- (void)clearInputAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(keyboardController:didClickClearInput:)]) {
        [self.delegate keyboardController:self didClickClearInput:sender];
    }
}

- (UIButton *)createCommonButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
    [button.layer setBorderWidth:px];
    [button.layer setCornerRadius:5];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateHighlighted];
    [button.titleLabel setFont:PingFangSCRegular(20 * kScreenScale)];
    [button addTarget:self
               action:@selector(commonButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
