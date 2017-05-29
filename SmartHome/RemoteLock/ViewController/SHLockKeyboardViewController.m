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
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    // Do any additional setup after loading the view.
    [self setupButtons];
}

- (void)setupButtons {
    CGFloat wSpace = (kScreenWidth - 300) / 4;
    CGFloat hSpace = (kScreenHeight * 0.35 - 160 - 40)/3;
    UIButton *zeroButton = [self createCommonButton:@"0"];
    [self.view addSubview:zeroButton];
    [zeroButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *twoButton = [self createCommonButton:@"2"];
    [self.view addSubview:twoButton];
    [twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zeroButton);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *oneButton = [self createCommonButton:@"1"];
    [self.view addSubview:oneButton];
    [oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoButton);
        make.left.equalTo(self.view).offset(wSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *threeButton = [self createCommonButton:@"3"];
    [self.view addSubview:threeButton];
    [threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoButton);
        make.right.equalTo(self.view).offset(-wSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *fiveButton = [self createCommonButton:@"5"];
    [self.view addSubview:fiveButton];
    [fiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(twoButton);
        make.top.equalTo(twoButton.mas_bottom).offset(hSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *fourButton = [self createCommonButton:@"4"];
    [self.view addSubview:fourButton];
    [fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fiveButton);
        make.left.equalTo(self.view).offset(wSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *sixButton = [self createCommonButton:@"6"];
    [self.view addSubview:sixButton];
    [sixButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fiveButton);
        make.right.equalTo(self.view).offset(-wSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *eightButton = [self createCommonButton:@"8"];
    [self.view addSubview:eightButton];
    [eightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fiveButton);
        make.top.equalTo(fiveButton.mas_bottom).offset(hSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *sevenButton = [self createCommonButton:@"7"];
    [self.view addSubview:sevenButton];
    [sevenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eightButton);
        make.left.equalTo(self.view).offset(wSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    UIButton *nineButton = [self createCommonButton:@"9"];
    [self.view addSubview:nineButton];
    [nineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eightButton);
        make.right.equalTo(self.view).offset(-wSpace);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

#pragma mark - Private Method
- (void)commonButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(keyboardController:didChangeOutput:)]) {
        [self.delegate keyboardController:self didChangeOutput:sender.titleLabel.text];
    }
}

- (UIButton *)createCommonButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setBorderColor:RGBCOLOR(11, 11, 11).CGColor];
    [button.layer setBorderWidth:px];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(11, 11, 11) forState:UIControlStateNormal];
    [button.titleLabel setFont:PingFangSCRegular(20)];
    [button addTarget:self
               action:@selector(commonButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
