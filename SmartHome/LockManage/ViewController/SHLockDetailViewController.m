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
    [[SHLockManager sharedInstance] fetchLockWithId:self.lockId complete:^(BOOL succ, SHLockHttpStatusCode statusCode, id info) {
        @strongify(self);
        switch (statusCode) {
            case SHLockHttpStatusSuccess: {
                [self hideLoading:YES];
                NSArray *locks = info[@"data"][@"info"];
                if (locks) {
                    self.lockModel = [SHLockModel modelWithDictionary:locks[0]];
                } else {
                    self.lockModel = nil;
                }
                [self.tableView reloadData];
                break;
            }
            case SHLockHttpStatusLockExist:
            case SHLockHttpStatusLockNotFound:
            case SHLockHttpStatusLockIdOrMacErr:
                [self showHint:info[@"msg"] duration:1.0];
                [[SHLockManager sharedInstance] updateCurrentLock:nil];
            default:
                break;
        }
    }];
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
        _lockHeader.backgroundColor = NavigationBarColor;
        RAC(_lockHeader, lockModel) = RACObserve(self, lockModel);
    }
    return _lockHeader;
}

- (UIButton *)unlockRecordButton {
    if (!_unlockRecordButton) {
        _unlockRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unlockRecordButton setTitle:@"开锁记录" forState:UIControlStateNormal];
        [_unlockRecordButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
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
        [_addKeyButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_addKeyButton addTarget:self
                          action:@selector(openAddKeyVC)
                forControlEvents:UIControlEventTouchUpInside];
        _addKeyButton.backgroundColor = NavigationBarColor;
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
