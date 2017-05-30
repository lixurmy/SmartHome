//
//  SHSettingsViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/29.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSettingsViewController.h"
#import "SHSetLockPasswordViewController.h"
#import "SHSetOfflinePasswordViewController.h"
#import "SHSettingsBaseCell.h"
#import "SHBaseTableView.h"
#import "SHSettingSection.h"
#import "SHRemoteLockManager.h"
#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"

static NSString * const kSHSettingsViewControllerCell = @"kSHSettingsViewControllerCell";

@interface SHSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, sendTheValueDelegate>

@property (nonatomic, strong) SHBaseTableView *tableView;
@property (nonatomic, copy) NSString *bindPhone;
@property (nonatomic, assign) BOOL isStartTime;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

@implementation SHSettingsViewController

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bindPhone = [SHRemoteLockManager sharedInstance].bindPhone;
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[SHBaseTableView alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Private Method
- (void)bindCellPhone {
    if ([SHRemoteLockManager sharedInstance].isBind) {
        @weakify(self);
        [self showLoading:YES hint:@"解绑中..."];
        [[SHRemoteLockManager sharedInstance] unbindPhone:self.bindPhone complete:^(BOOL succ, SHRemoteLockBindStatus statusCode, id info) {
            @strongify(self);
            if (succ) {
                [self showHint:@"解绑成功" duration:1.0];
                self.bindPhone = nil;
            } else {
                [self showHint:@"解绑失败" duration:1.0];
            }
        }];
    } else {
        if (!self.bindPhone) {
            [self showHint:@"无效号码" duration:1.0];
            return;
        }
        @weakify(self);
        [self showLoading:YES hint:@"绑定中..."];
        [[SHRemoteLockManager sharedInstance] bindPhone:self.bindPhone gatewayId:[SHUserManager sharedInstance].gatewayId startTime:self.startTime endTime:self.endTime complete:^(BOOL succ, SHRemoteLockBindStatus statusCode, id info) {
            @strongify(self);
            if (succ) {
                [self showHint:@"绑定成功" duration:1.0];
            } else {
                [self showHint:@"绑定失败" duration:1.0];
            }
        }];
    }
}

- (void)showBindPhoneInputAlert {
    if ([SHRemoteLockManager sharedInstance].isBind) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"输入绑定手机号"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入手机号";
        textField.delegate = self;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SHRemoteLockManager sharedInstance].bindPhone = self.bindPhone;
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showDatePickerStart:(BOOL)isStart {
    if ([SHRemoteLockManager sharedInstance].isBind) {
        return;
    }
    self.isStartTime = isStart;
    FDAlertView *alert = [[FDAlertView alloc] init];
    RBCustomDatePickerView * contentView=[[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    contentView.delegate=self;
    alert.contentView = contentView;
    [alert.contentView.layer setCornerRadius:20];
    [alert show];
}

- (void)forceToUnbind {
    [[SHRemoteLockManager sharedInstance] forceToUnbind];
    self.bindPhone = nil;
    self.startTime = nil;
    self.endTime = nil;
}

- (void)openSetUnlockPasswordVC {
    SHSetLockPasswordViewController *setLockPasswordVC = [[SHSetLockPasswordViewController alloc] init];
    [self presentViewController:setLockPasswordVC animated:YES completion:nil];
}

- (void)openSetOfflinePasswordVC {
    SHSetOfflinePasswordViewController *offlinePasswordVC = [[SHSetOfflinePasswordViewController alloc] init];
    [self presentViewController:offlinePasswordVC animated:YES completion:nil];
}

#pragma mark - sendTheValueDelegate
- (void)getTimeToValue:(NSString *)theTimeStr {
    if (self.isStartTime) {
        self.startTime = theTimeStr;
    } else {
        self.endTime = theTimeStr;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bindPhone = textField.text;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        SHSettingSection *bindSection = [[SHSettingSection alloc] initWithTitle:@"绑定信息"];
        return bindSection;
    } else {
        SHSettingSection *passwordSection = [[SHSettingSection alloc] initWithTitle:@"开锁密码"];
        return passwordSection;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHSettingsBaseCell *cell = [[SHSettingsBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSHSettingsViewControllerCell];
    if (indexPath.section == 0) {
        NSInteger row = indexPath.row;
        if (row == 0) {
            cell.title = @"绑定状态";
            cell.showCheckMark = YES;
            RAC(cell, checked) = RACObserve([SHRemoteLockManager sharedInstance], isBind);
            [RACObserve([SHRemoteLockManager sharedInstance], isBind) subscribeNext:^(id x) {
                cell.checked = [x boolValue];
                if ([x boolValue]) {
                    cell.desc = @"已绑定";
                } else {
                    cell.desc = @"未绑定";
                }
            }];
        } else if (row == 1) {
            cell.title = @"绑定手机号";
            RAC(cell, desc) = RACObserve([SHRemoteLockManager sharedInstance], bindPhone);
        } else if (row == 2) {
            cell.title = @"有效期开始时间";
            cell.desc = @"请选择开始时间";
            [[RACObserve([SHRemoteLockManager sharedInstance], startTime) combineLatestWith:RACObserve(self, startTime)] subscribeNext:^(id x) {
                if (x[1]) {
                    cell.desc = x[1];
                } else {
                    if (x[0]) {
                        cell.desc = x[0];
                    } else {
                        cell.desc = @"请选择开始时间";
                    }
                }
            }];
        } else if (row == 3) {
            cell.title = @"有效期结束时间";
            [[RACObserve([SHRemoteLockManager sharedInstance], endTime) combineLatestWith:RACObserve(self, endTime)] subscribeNext:^(id x) {
                if (x[1]) {
                    cell.desc = x[1];
                } else {
                    if (x[0]) {
                        cell.desc = x[0];
                    } else {
                        cell.desc = @"请选择结束时间";
                    }
                }
            }];
        } else if (row == 4) {
            cell.title = @"强制解除绑定";
            cell.desc = @"";
        }
    } else if (indexPath.section == 1) {
        NSInteger row = indexPath.row;
        if (row == 0) {
            cell.title = @"设置开锁密码";
            cell.desc = @"用于手机端远程开锁";
        } else if (row == 1) {
            cell.title = @"设置离线密码";
            cell.desc = @"设置";
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        if (row == 0) {
            [self bindCellPhone];
        } else if (row == 1) {
            [self showBindPhoneInputAlert];
        } else if (row == 2) {
            [self showDatePickerStart:YES];
        } else if (row == 3) {
            [self showDatePickerStart:NO];
        } else if (row == 4) {
            [self forceToUnbind];
        }
    } else {
        if (row == 0) {
            [self openSetUnlockPasswordVC];
        } else if (row == 1) {
            [self openSetOfflinePasswordVC];
        }
    }
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"设置";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
