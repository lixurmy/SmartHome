//
//  SHLockManageViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockManageViewController.h"
#import "SHLockDetailViewController.h"
#import "SHRemoteLockViewController.h"
#import "SHAddLockViewController.h"
#import "SHLockTableView.h"
#import "SHLockInfoCell.h"
#import "SHLockEmptyCell.h"
#import "SHRefreshHeader.h"
#import "SHLockManager.h"

static NSString * const kSHLockManageViewControllerInfoCellKey = @"kSHLockManageViewControllerInfoCellKey";

@interface SHLockManageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,SHBaseTableViewCellDelegate>

@property (nonatomic, strong) UIButton *addLockButton;
@property (nonatomic, strong) SHLockTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allLockModels;
@property (nonatomic, copy) NSString *aliasString;

@end

@implementation SHLockManageViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
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
    }]];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Private Method
- (void)fetchAllLockInfos {
    @weakify(self);
    [[SHLockManager sharedInstance] fetchAllLocksWithComplete:^(BOOL succ, SHLockHttpStatusCode statusCode, id info) {
        @strongify(self);
        switch (statusCode) {
            case SHLockHttpStatusSuccess: {
                [self.allLockModels removeAllObjects];
                NSArray *locks = info[@"data"][@"info"];
                for (NSDictionary *lock in locks) {
                    SHLockModel *model = [SHLockModel modelWithDictionary:lock];
                    [self.allLockModels addObject:model];
                }
                if (![SHLockManager sharedInstance].currentLock) {
                    [[SHLockManager sharedInstance] updateCurrentLock:self.allLockModels.firstObject];
                }
                [self.tableView reloadData];
                break;
            }
            case SHLockHttpStatusLockExist:
                [self showHint:@"LockExist" duration:1.0];
                break;
            case SHLockHttpStatusLockNotFound:
                [self showHint:@"LockNotFound" duration:1.0];
                break;
            default:
                break;
        }
        [self.tableView.mj_header endRefreshing];
        if (succ) {
            [self showHint:@"更新成功" duration:1.0];
        } else {
            [self showHint:@"更新失败" duration:1.0];
        }
    }];
}

- (void)openAddLockVC {
    SHAddLockViewController *addLockVC = [[SHAddLockViewController alloc] init];
    [self.navigationController pushViewController:addLockVC animated:YES];
}

- (void)showUpdateAliasAlert:(NSString *)lockId {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新别名"
                                                                   message:@"设置锁别名"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入锁别名";
        textField.delegate = self;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAlias:lockId];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateAlias:(NSString *)lockId {
    @weakify(self);
    [self showLoading:YES];
    [[SHLockManager sharedInstance] updateAlias:self.aliasString lockId:lockId complete:^(BOOL succ, SHLockHttpStatusCode statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self fetchAllLockInfos];
        } else {
            [self showHint:@"更新失败" duration:1.0];
        }
    }];
}

- (void)showUpdateCurrentLockAlert:(SHLockModel *)lockModel {
    NSString *message = [NSString stringWithFormat:@"确定设置%@为常用锁?", lockModel.alias];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateCurrentLock:lockModel];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateCurrentLock:(SHLockModel *)lockModel {
    if ([lockModel.lockId isEqualToString:[SHLockManager sharedInstance].currentLock.lockId]) {
        [self showHint:@"已是常用锁" duration:1.0];
        return;
    }
    [self showLoading:YES];
    [[SHLockManager sharedInstance] updateCurrentLock:lockModel];
    [self fetchAllLockInfos];
}

- (void)openLockWithModel:(SHLockModel *)lockModel {
    SHRemoteLockViewController *remoteLockVC = [[SHRemoteLockViewController alloc] initWithLockModel:lockModel];
    [self.navigationController pushViewController:remoteLockVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allLockModels.count ?: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allLockModels.count) {
        SHLockInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kSHLockManageViewControllerInfoCellKey];
        if (!cell) {
            cell = [[SHLockInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSHLockManageViewControllerInfoCellKey];
        }
        cell.delegate = self;
        NSInteger row = indexPath.row;
        SHLockModel *model = self.allLockModels[row];
        cell.model = model;
        return cell;
    } else {
        SHLockEmptyCell *cell = [[SHLockEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.allLockModels.count ? 100 : kScreenHeight - self.shNavigationBarHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    SHLockModel *model = self.allLockModels[row];
    SHLockDetailViewController *lockDetailVC = [[SHLockDetailViewController alloc] initWithLockId:model.lockId];
    [self.navigationController pushViewController:lockDetailVC animated:YES];
}

#pragma mark - SHBaseTableViewCellDelegate
- (void)handleActionForCell:(SHBaseTableViewCell *)cell info:(id)info {
    if ([cell isKindOfClass:[SHLockInfoCell class]]) {
        SHLockInfoCell *infoCell = (SHLockInfoCell *)cell;
        SHLockModel *lockModel = infoCell.model;
        if ([info isEqualToString:@"updateAlias"]) {
            [self showUpdateAliasAlert:lockModel.lockId];
        } else if ([info isEqualToString:@"updateCurrentLock"]) {
            [self showUpdateCurrentLockAlert:lockModel];
        } else if([info isEqualToString:@"openLock"]) {
            [self openLockWithModel:lockModel];
        }
    } else if ([cell isKindOfClass:[SHLockEmptyCell class]]) {
        [self openAddLockVC];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.aliasString = textField.text;
}

#pragma mark - Lazy Load
- (UIButton *)addLockButton {
    if (!_addLockButton) {
        _addLockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addLockButton setTitle:@"添加锁" forState:UIControlStateNormal];
        [_addLockButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_addLockButton addTarget:self
                           action:@selector(openAddLockVC)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _addLockButton;
}

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

- (SHNavigationBar *)createSHNavigationBar {
    SHNavigationBar *navigationBar = [super createSHNavigationBar];
    UIBarButtonItem *addLockItem = [[UIBarButtonItem alloc] initWithCustomView:self.addLockButton];
    [self.shNavigationItem setRightBarButtonItem:addLockItem];
    [self.addLockButton sizeToFit];
    return navigationBar;
}

@end
