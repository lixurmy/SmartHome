//
//  SHUnlockRecordViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHUnlockRecordViewController.h"
#import "SHUnlockRecordCell.h"
#import "SHBaseTableView.h"
#import "SHLockManager.h"

static NSString * const kSHUnlockRecordViewControllerCellKey = @"kSHUnlockRecordViewControllerCellKey";

@interface SHUnlockRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SHBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allRecords;

@end

@implementation SHUnlockRecordViewController

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
    [self showLoading:YES hint:@"加载中..."];
    [self fetchRemoteRecords];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Private Method
- (void)fetchRemoteRecords {
    [self hideLoading:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHUnlockRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kSHUnlockRecordViewControllerCellKey];
    if (!cell) {
        cell = [[SHUnlockRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSHUnlockRecordViewControllerCellKey];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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

- (NSMutableArray *)allRecords {
    if (!_allRecords) {
        _allRecords = [NSMutableArray array];
    }
    return _allRecords;
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"开锁记录";
}

@end
