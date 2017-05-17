//
//  SHRootViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHRootViewController.h"
#import "SHHomeViewController.h"
#import "SHLeftDrawerViewController.h"

@interface SHRootViewController ()

@property (nonatomic, strong) SHHomeViewController *homeVC;
@property (nonatomic, strong) SHLeftDrawerViewController *leftDrawerVC;
@property (nonatomic, strong) UIBarButtonItem *leftDrawerButtonItem;

@end

@implementation SHRootViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(22, 12, 12)];
    [self setupVCs];
}

- (void)setupVCs {
    self.homeVC = [[SHHomeViewController alloc] init];
    [self.homeVC willMoveToParentViewController:self];
    [self addChildViewController:self.homeVC];
    [self.homeVC didMoveToParentViewController:self];
    
    self.leftDrawerVC = [[SHLeftDrawerViewController alloc] init];
    [self.leftDrawerVC willMoveToParentViewController:self];
    [self addChildViewController:self.leftDrawerVC];
    [self.leftDrawerVC didMoveToParentViewController:self];
    [self.view addSubview:self.homeVC.view];
    [self.view addSubview:self.leftDrawerVC.view];
    [self.homeVC.view setFrame:CGRectMake(0, self.shNavigationBarHeight, kScreenWidth, kScreenHeight - self.shNavigationBarHeight)];
    [self.leftDrawerVC.view setFrame:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
}

#pragma mark - Private Method
- (void)showLeftDrawer {
    [UIView animateWithDuration:0.5 animations:^{
        [self.leftDrawerVC.view setFrame:CGRectMake(200 - kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        [self.homeVC.view setFrame:CGRectMake(200, self.shNavigationBarHeight, kScreenWidth, kScreenHeight - self.shNavigationBarHeight)];
    } completion:^(BOOL finished) {
        [self.leftDrawerVC.view setFrame:CGRectMake(200 - kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    }];
}

#pragma mark - Get
- (UIBarButtonItem *)leftDrawerButtonItem {
    if (!_leftDrawerButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 24, 24);
        [button setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(11, 11, 11)] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showLeftDrawer) forControlEvents:UIControlEventTouchUpInside];
        _leftDrawerButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _leftDrawerButtonItem;
}

#pragma mark - VC Relative
- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)hideNavigationBar {
    return NO;
}

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [[SHNavigationBar alloc] init];
    [navigationBar setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(0, 222, 222)] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *leftItem = [[UINavigationItem alloc] init];
    leftItem.leftBarButtonItem = self.leftDrawerButtonItem;
    [navigationBar setItems:@[leftItem]];
    return navigationBar;
}

@end
