//
//  SHHomeViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHHomeViewController.h"
#import "SHLoginViewController.h"
#import "SHRootViewController.h"
#import "SHHomeMessageViewController.h"
#import "SHRemoteLockViewController.h"

@interface SHHomeViewController ()

@property (nonatomic, strong) SHHomeMessageViewController *messageVC;
@property (nonatomic, strong) UIButton *remoteLockButton;

@end

@implementation SHHomeViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVCs];
    [self setupViews];
}

- (void)setupVCs {
    [self.messageVC willMoveToParentViewController:self];
    [self addChildViewController:self.messageVC];
    [self.messageVC didMoveToParentViewController:self];
    [self.messageVC.view.layer setBorderColor:RGBCOLOR(111, 111, 111).CGColor];
    [self.messageVC.view.layer setBorderWidth:px];
    [self.messageVC.view.layer setCornerRadius:5.0];
    [self.view addSubview:self.messageVC.view];
    [self.messageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@((kScreenHeight - self.shNavigationBarHeight) * 0.6));
    }];
}

- (void)setupViews {
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.maskView setHidden:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMaskView)];
    [self.maskView addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:self.remoteLockButton];
    [self.remoteLockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.messageVC.view.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}

#pragma mark - Public Method
- (void)showMaskView:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:kSHLeftDrawerAnimationDuration animations:^{
            [self.maskView setAlpha:0.7];
        } completion:^(BOOL finished) {
            [self.maskView setHidden:NO];
        }];
    } else {
        [self.maskView setHidden:NO];
    }
}

#pragma mark - Private Method
- (void)hideMaskView {
    [UIView animateWithDuration:kSHLeftDrawerAnimationDuration animations:^{
        [self.maskView setHidden:YES];
    } completion:^(BOOL finished) {
        [self.maskView setHidden:YES];
    }];
}

- (void)openRemoteLock {
    SHRemoteLockViewController *remoteLockVC = [[SHRemoteLockViewController alloc] init];
    [self.navigationController pushViewController:remoteLockVC animated:YES];
}

#pragma mark - GET
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    }
    return _maskView;
}

- (SHHomeMessageViewController *)messageVC {
    if (!_messageVC) {
        _messageVC = [[SHHomeMessageViewController alloc] init];
    }
    return _messageVC;
}

- (UIButton *)remoteLockButton {
    if (!_remoteLockButton) {
        _remoteLockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remoteLockButton setTitle:@"远程开锁" forState:UIControlStateNormal];
        [_remoteLockButton setTitleColor:RGBCOLOR(11, 11, 11) forState:UIControlStateNormal];
        [_remoteLockButton.titleLabel setFont:PingFangSCRegular(20)];
        [_remoteLockButton.layer setCornerRadius:5.0];
        [_remoteLockButton.layer setBorderWidth:px];
        [_remoteLockButton.layer setBorderColor:RGBCOLOR(11, 11, 11).CGColor];
        [_remoteLockButton addTarget:self
                              action:@selector(openRemoteLock)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _remoteLockButton;
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

@end
