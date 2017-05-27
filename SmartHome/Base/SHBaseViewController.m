//
//  SHBaseViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SHBaseViewController ()

@end

@implementation SHBaseViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
    [self.view setBackgroundColor:RGBCOLOR(255, 255, 255)];
}

- (void)setupAppearance {
    if ([self hideNavigationBar]) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    if ([self hasSHNavigationBar]) {
        self.shNavigationBar = [self createSHNavigationBar];
        [self.view addSubview:self.shNavigationBar];
        [self.shNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(self.shNavigationBarHeight));
        }];
    }
}

#pragma mark - Public Method
- (void)showLoading:(BOOL)animated {
    [MBProgressHUD showHUDAddedTo:self.view animated:animated];
}

- (void)showLoading:(BOOL)animated hint:(NSString *)hint {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:animated];
    [hud.label setText:hint];
}

- (void)hideLoading:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self.view animated:animated];
}

- (void)showHint:(NSString *)hint duration:(CGFloat)duration {
    [self hideLoading:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud.label setText:hint];
    [hud hideAnimated:YES afterDelay:duration];
}

- (BOOL)hasSHNavigationBar {
    return NO;
}

- (BOOL)hideNavigationBar {
    return NO;
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [[SHNavigationBar alloc] init];
    [navigationBar setBackgroundImage:[UIImage imageWithColor:NavigationBarColor]
                        forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributed = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [navigationBar setTitleTextAttributes:attributed];
    return navigationBar;
}

#pragma mark - Get
- (CGFloat)shNavigationBarHeight {
    return kNavigationBarHeight + kStatusBarHeight;
}

@end
