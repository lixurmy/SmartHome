//
//  SHLockManageViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockManageViewController.h"
#import "SHLockDetailViewController.h"
#import "SHLockTableView.h"
#import "SHLockInfoCell.h"
#import "SHRefreshHeader.h"

static NSString * const kSHLockManageViewControllerInfoCellKey = @"kSHLockManageViewControllerInfoCellKey";

@interface SHLockManageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SHLockTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allLockModels;

@end

@implementation SHLockManageViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self fetchAllLockInfos];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    @weakify(self);
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchAllLockInfos];
        [self.tableView.mj_header endRefreshing];
    }]];
}

#pragma mark - Private Method
- (void)fetchAllLockInfos {
    @weakify(self);
    NSDictionary *parameters = @{@"gwid" : [SHUserManager sharedInstance].gatewayId ?: @""};
    [[SHNetworkManager baseManager] GET:@"lock/ygs/v2/getygslock.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        if (responseObject) {
            [self handleRemoteResponse:responseObject];
        } else {
        }
        [self hideLoading:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"请求失败" duration:1.0];
        [self handleRemoteResponse:nil];
    }];
}

- (void)handleRemoteResponse:(id)responseObject {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allLockModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHLockInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kSHLockManageViewControllerInfoCellKey];
    if (!cell) {
        cell = [[SHLockInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSHLockManageViewControllerInfoCellKey];
    }
    NSInteger row = indexPath.row;
    SHLockModel *model = self.allLockModels[row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    SHLockModel *model = self.allLockModels[row];
    SHLockDetailViewController *lockDetailVC = [[SHLockDetailViewController alloc] initWithLockId:model.lockId];
    [self.navigationController pushViewController:lockDetailVC animated:YES];
}

#pragma mark - Lazy Load
- (SHLockTableView *)tableView {
    if (!_tableView) {
        _tableView = [[SHLockTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)allLockModels {
    if (!_allLockModels) {
        _allLockModels = [NSMutableArray array];
        SHLockModel *model = [[SHLockModel alloc] init];
        model.alias = @"测试锁1";
        model.lockId = @"11";
        [_allLockModels addObject:model];
    }
    return _allLockModels;
}

#pragma mark - VC Relative
- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)autoGenerateBackItem {
    return NO;
}

- (NSString *)title {
    return @"锁管理";
}

@end
