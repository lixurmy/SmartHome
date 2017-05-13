//
//  SHBaseViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHBaseViewController ()

@end

@implementation SHBaseViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
}

- (void)setupAppearance {
    if ([self hideNavigationBar]) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    if ([self hasSHNavigationBar]) {
        self.shNavigationBar = [[SHNavigationBar alloc] init];
        [self.view addSubview:self.shNavigationBar];
        [self.shNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(self.shNavigationBarHeight));
        }];
    }
}

#pragma mark - Public Method
- (BOOL)hasSHNavigationBar {
    return NO;
}

- (BOOL)hideNavigationBar {
    return NO;
}

#pragma mark - Get
- (CGFloat)shNavigationBarHeight {
    return kNavigationBarHeight + kStatusBarHeight;
}

@end
