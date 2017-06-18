//
//  SHLockDetailViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockDetailViewController.h"
#import "SHUnlockRecordViewController.h"
#import "SHLockManager.h"
#import "SHLockModel.h"
#import "SHLockDetailHeader.h"
#import "SHBaseTableView.h"
#import "SHLockDetailCell.h"

static NSString * const kSHLockDetailViewControllerCellKey = @"kSHLockDetailViewControllerCellKey";

@interface SHLockDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, strong) SHLockModel *lockModel;
@property (nonatomic, strong) SHBaseTableView *tableView;
@property (nonatomic, strong) SHLockDetailHeader *lockHeader;
@property (nonatomic, strong) UIButton *unlockRecordButton;
@property (nonatomic, strong) UIButton *addKeyButton;

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
    [self.view addSubview:self.addKeyButton];
    [self.addKeyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(60));
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addKeyButton.mas_top);
    }];
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
        //FIXME:handle failue
        [self showHint:@"请求失败" duration:1.0];
        self.lockModel = [SHLockModel modelWithDictionary:@{@"alias" : @"test"}];
    }];
}

- (void)handleRemoteResponse:(id)responseObject {
    if (!responseObject) {
        [self showHint:@"服务器错误" duration:1.0];
        return;
    }
    SHLockHttpStatusCode status = [responseObject[@"status"] integerValue];
    switch (status) {
        case SHLockHttpStatusSuccess: {
            [self hideLoading:YES];
            NSArray *info = responseObject[@"data"][@"info"];
            if (info) {
                self.lockModel = [SHLockModel modelWithDictionary:info[0]];
            }
            break;
        }
        case SHLockHttpStatusLockExist:
        case SHLockHttpStatusLockNotFound:
            [self showHint:responseObject[@"msg"] duration:1.0];
        default:
            break;
    }
    
}

- (void)openUnlockRecord {
    SHUnlockRecordViewController *unlockRecordVC = [[SHUnlockRecordViewController alloc] initWithLockId:self.lockId];
    [self.navigationController pushViewController:unlockRecordVC animated:YES];
}

- (void)openAddKeyVC {

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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SHLockDetailHeader *)lockHeader {
    if (!_lockHeader) {
        _lockHeader = [[SHLockDetailHeader alloc] init];
        _lockHeader.backgroundColor = [UIColor greenColor];
        RAC(_lockHeader, lockModel) = RACObserve(self, lockModel);
    }
    return _lockHeader;
}

- (UIButton *)unlockRecordButton {
    if (!_unlockRecordButton) {
        _unlockRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unlockRecordButton setTitle:@"开锁记录" forState:UIControlStateNormal];
        [_unlockRecordButton addTarget:self
                                action:@selector(openUnlockRecord)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _unlockRecordButton;
}

- (UIButton *)addKeyButton {
    if (!_addKeyButton) {
        _addKeyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addKeyButton setTitle:@"添加钥匙" forState:UIControlStateNormal];
        [_addKeyButton addTarget:self
                          action:@selector(openAddKeyVC)
                forControlEvents:UIControlEventTouchUpInside];
        _addKeyButton.backgroundColor = [UIColor greenColor];
    }
    return _addKeyButton;
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

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [super createSHNavigationBar];
    UIBarButtonItem *unlockRecordItem = [[UIBarButtonItem alloc] initWithCustomView:self.unlockRecordButton];
    [self.unlockRecordButton sizeToFit];
    [self.shNavigationItem setRightBarButtonItem:unlockRecordItem];
    return navigationBar;
}

@end
