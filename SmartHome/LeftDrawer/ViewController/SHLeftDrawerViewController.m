//
//  SHLeftDrawerViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLeftDrawerViewController.h"
#import "SHLoginViewController.h"
#import "SHChangePasswordViewController.h"
#import "SHBindGatewayViewController.h"
#import "SHBaseTableView.h"
#import "SHLeftDrawerCell.h"

typedef NS_ENUM(NSInteger, SHLeftDrawerIndexRow) {
    SHLeftDrawerIndexRowRevisePassword = 0,
    SHLeftDrawerIndexRowBindGateway = 1,
    SHLEftDrawerIndexRowLogout = 2
};

static NSString * const kSHLeftDrawerViewControllerCellIdentifier = @"kSHLeftDrawerViewControllerCellIdentifier";
static CGFloat const kSHLeftDrawerViewCellHeight = 50;

@interface SHLeftDrawerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SHBaseTableView *tableView;

@end

@implementation SHLeftDrawerViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(255, 255, 255)];
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[SHBaseTableView alloc] init];
    [self.tableView setBackgroundColor:RGBCOLOR(0, 255, 0)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(3 * kSHLeftDrawerViewCellHeight));
    }];
}

#pragma mark - Private Method
- (void)changePassword {
    SHChangePasswordViewController *changePasswordVC = [[SHChangePasswordViewController alloc] init];
    [self.parentViewController presentViewController:changePasswordVC animated:YES completion:nil];
}

- (void)bindGateway {
    SHBindGatewayViewController *bindGatewayVC = [[SHBindGatewayViewController alloc] init];
    [self.parentViewController presentViewController:bindGatewayVC animated:YES completion:nil];
}

- (void)logout {
    [self showLoading:YES hint:@"退出登录..."];
    [[SHUserManager sharedInstance] logoutWithComplete:^(BOOL succ, SHLoginOrRegisterStatus statusCode, id info) {
        if (succ) {
            [self hideLoading:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SHLoginViewController *loginViewController = [[SHLoginViewController alloc] init];
                [self.view.window setRootViewController:loginViewController];
            });
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHLeftDrawerCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:kSHLeftDrawerViewControllerCellIdentifier];
    if (!tableViewCell) {
        tableViewCell = [[SHLeftDrawerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSHLeftDrawerViewControllerCellIdentifier];
        if (indexPath.row == 0) {
            tableViewCell.title = @"修改密码";
        } else if (indexPath.row == 1) {
            [RACObserve([SHUserManager sharedInstance], gatewayId) subscribeNext:^(id x) {
                tableViewCell.title = [NSString stringWithFormat:@"绑定网关(%@)", x];
                
            }];
        } else if (indexPath.row == 2) {
            tableViewCell.title = [NSString stringWithFormat:@"退出登录(%@)", [SHUserManager sharedInstance].phone];
        }
    }
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSHLeftDrawerViewCellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHLeftDrawerIndexRow row = indexPath.row;
    switch (row) {
        case SHLeftDrawerIndexRowRevisePassword:
            [self changePassword];
            break;
        case SHLeftDrawerIndexRowBindGateway:
            [self bindGateway];
            break;
        case SHLEftDrawerIndexRowLogout:
            [self logout];
            break;
    }
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"LeftDrawer";
}

@end
