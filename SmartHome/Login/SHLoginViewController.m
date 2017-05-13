//
//  SHLoginViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/13.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLoginViewController.h"
#import "SHHomeViewController.h"

@interface SHLoginViewController ()

@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation SHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBCOLOR(255, 255, 255)];
    [self.view addSubview:self.loginButton];
    [self.loginButton setBackgroundColor:RGBCOLOR(0, 0, 0)];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    @weakify(self);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self login];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)login {
    NSString *curpass = [SHUtils lowerCaseMd5:@"150916"];
    NSDictionary *parameters = @{@"phone" : @"15810111373", @"curpass" : curpass};
    NSURLSessionDataTask *dataTask = [[SHNetworkManager baseManager] POST:@"intelligw-server/app/userlogin" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        SHLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SHLog(@"%@", responseObject);
        [SHUserManager sharedInstance].isLogin = YES;
        SHHomeViewController *homeViewController = [[SHHomeViewController alloc] init];
        [self.view.window setRootViewController:homeViewController];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SHLog(@"%@", error);
    }];
    [dataTask resume];
}

#pragma mark - Get
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _loginButton;
}

@end
