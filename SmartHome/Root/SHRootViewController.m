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

CGFloat const kSHLeftDrawerAnimationDuration = 0.2;
#define kSHLeftDrawerVCWidth 250*kScreenScale

@interface SHRootViewController ()

@property (nonatomic, strong) SHHomeViewController *homeVC;
@property (nonatomic, strong) SHLeftDrawerViewController *leftDrawerVC;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIBarButtonItem *leftDrawerButtonItem;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UINavigationController *navigationVC;

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
    [self addChildViewController:self.homeVC];
    [self addChildViewController:self.leftDrawerVC];
    [self.view addSubview:self.homeVC.view];
    [self.view addSubview:self.leftDrawerVC.view];
    [self.homeVC.view setFrame:CGRectMake(0, self.shNavigationBarHeight, kScreenWidth, kScreenHeight - self.shNavigationBarHeight)];
    [self.leftDrawerVC.view setFrame:CGRectMake(-kSHLeftDrawerVCWidth, self.shNavigationBarHeight, kSHLeftDrawerVCWidth, kScreenHeight)];
    @weakify(self);
    [RACObserve(self, homeVC.maskView.hidden) subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [self hideLeftDrawer];
        }
    }];
}

#pragma mark - Private Method
- (void)showLeftDrawer {
    if ([self.homeVC.maskView isHidden]) {
        [UIView animateWithDuration:kSHLeftDrawerAnimationDuration animations:^{
            [self.leftDrawerVC.view setFrame:CGRectMake(0, self.shNavigationBarHeight, kSHLeftDrawerVCWidth, kScreenHeight)];
            [self.homeVC.view setFrame:CGRectMake(kSHLeftDrawerVCWidth, self.shNavigationBarHeight, kScreenWidth, kScreenHeight - self.shNavigationBarHeight)];
            [self.homeVC showMaskView:YES];
        } completion:^(BOOL finished) {
            [self.leftDrawerVC.view setFrame:CGRectMake(0, self.shNavigationBarHeight, kSHLeftDrawerVCWidth, kScreenHeight)];
        }];
    } else {
        [self.homeVC hideMaskView];
    }
    [self.menuButton setSelected:YES];
}

- (void)hideLeftDrawer {
    [UIView animateWithDuration:kSHLeftDrawerAnimationDuration animations:^{
        [self.leftDrawerVC.view setFrame:CGRectMake(-kSHLeftDrawerVCWidth, self.shNavigationBarHeight, kSHLeftDrawerVCWidth, kScreenHeight)];
        [self.homeVC.view setFrame:CGRectMake(0, self.shNavigationBarHeight, kScreenWidth, kScreenHeight - self.shNavigationBarHeight)];
    } completion:^(BOOL finished) {
        [self.leftDrawerVC.view setFrame:CGRectMake(-kSHLeftDrawerVCWidth, self.shNavigationBarHeight, kSHLeftDrawerVCWidth, kScreenHeight)];
        [self.homeVC.view setFrame:CGRectMake(0, self.shNavigationBarHeight, kScreenWidth, kScreenHeight - self.shNavigationBarHeight)];
    }];
    [self.menuButton setSelected:NO];
}

#pragma mark - Get
- (UIBarButtonItem *)leftDrawerButtonItem {
    if (!_leftDrawerButtonItem) {
        _leftDrawerButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    }
    return _leftDrawerButtonItem;
}

- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuButton setBackgroundImage:[UIImage imageNamed:@"home_left_menu_normal"] forState:UIControlStateNormal];
        [_menuButton setBackgroundImage:[UIImage imageNamed:@"home_left_menu_back"] forState:UIControlStateSelected];
        [_menuButton sizeToFit];
        [_menuButton addTarget:self action:@selector(showLeftDrawer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (SHHomeViewController *)homeVC {
    if (!_homeVC) {
        _homeVC = [[SHHomeViewController alloc] init];
    }
    return _homeVC;
}

- (SHLeftDrawerViewController *)leftDrawerVC {
    if (!_leftDrawerVC) {
        _leftDrawerVC = [[SHLeftDrawerViewController alloc] init];
    }
    return _leftDrawerVC;
}

#pragma mark - VC Relative
- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)hideNavigationBar {
    return NO;
}

- (NSString *)title {
    return @"SmartHome";
}

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [super createSHNavigationBar];
    NSDictionary *attributed = @{NSForegroundColorAttributeName : RGBCOLOR(0, 0, 0), NSFontAttributeName : PingFangSCMedium(20)};
    [navigationBar setTitleTextAttributes:attributed];
    self.shNavigationItem.leftBarButtonItem = self.leftDrawerButtonItem;
    return navigationBar;
}

@end
