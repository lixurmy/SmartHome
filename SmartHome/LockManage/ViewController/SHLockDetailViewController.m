//
//  SHLockDetailViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockDetailViewController.h"
#import "SHLockDetailHeader.h"
#import "SHBaseTableView.h"
#import "SHLockDetailCell.h"

static NSString * const kSHLockDetailViewControllerCellKey = @"kSHLockDetailViewControllerCellKey";

@interface SHLockDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, strong) SHBaseTableView *tableView;
@property (nonatomic, strong) SHLockDetailHeader *lockHeader;

@end

@implementation SHLockDetailViewController

#pragma mark - Init
- (instancetype)initWithLockId:(NSString *)lockId {
    self = [super init];
    if (self) {
        _lockId = lockId;
    }
    return self;
}

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self showLoading:YES hint:@"请求中..."];
    [self fetchLockDetailInfo];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - Private Method
- (void)fetchLockDetailInfo {
    @weakify(self);
    NSDictionary *parameters = @{@"gwid" : [SHUserManager sharedInstance].gatewayId ?: @"",
                                 @"lid"  : self.lockId ?: @""};
    [[SHNetworkManager lockManager] GET:@"lock/ygs/v2/getygslock.cgi" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self handleRemoteResponse:responseObject];
        [self hideLoading:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        [self showHint:@"请求失败" duration:1.0];
    }];
}

- (void)handleRemoteResponse:(id)responseObject {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.lockHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHLockDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kSHLockDetailViewControllerCellKey];
    if (!cell) {
        cell = [[SHLockDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSHLockDetailViewControllerCellKey];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

#pragma mark - Lazy Load
- (SHBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[SHBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (SHLockDetailHeader *)lockHeader {
    if (!_lockHeader) {
        _lockHeader = [[SHLockDetailHeader alloc] init];
        _lockHeader.backgroundColor = [UIColor greenColor];
    }
    return _lockHeader;
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"门锁详情";
}

@end
