//
//  SHHomeMessageViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/28.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHHomeMessageViewController.h"

@interface SHHomeMessageViewController ()

@property (nonatomic, strong) UILabel *welcomeLabel;

@end

@implementation SHHomeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    [self.view addSubview:self.welcomeLabel];
    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.top.equalTo(self.view).offset(30);
        make.bottom.right.equalTo(self.view).offset(-30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get
- (UILabel *)welcomeLabel {
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc] init];
        _welcomeLabel.text = @"家中一切安好 \n请问有何吩咐";
        _welcomeLabel.textAlignment = NSTextAlignmentCenter;
        _welcomeLabel.numberOfLines = 2;
        _welcomeLabel.font = PingFangSCMedium(28);
    }
    return _welcomeLabel;
}

@end
