//
//  SHSettingsViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/29.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSettingsViewController.h"
#import "SHSettingsBaseCell.h"
#import "SHBaseTableView.h"
#import "SHSettingSection.h"

static NSString * const kSHSettingsViewControllerCell = @"kSHSettingsViewControllerCell";

@interface SHSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SHBaseTableView *tableView;

@end

@implementation SHSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[SHBaseTableView alloc] init];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
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
    SHSettingsBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kSHSettingsViewControllerCell];
    if (!cell) {
        cell = [[SHSettingsBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSHSettingsViewControllerCell];
    }
    if (indexPath.section == 0) {
        NSInteger row = indexPath.row;
        if (row == 0) {
            cell.title = @"绑定状态";
            cell.desc = @"未绑定";
            cell.showCheckMark = YES;
        } else if (row == 1) {
            cell.title = @"绑定手机号";
            cell.desc = @"";
        } else if (row == 2) {
            cell.title = @"有效期开始时间";
            cell.desc = @"请选择开始时间";
        } else if (row == 3) {
            cell.title = @"有效期结束时间";
            cell.desc = @"请选择结束时间";
        } else if (row == 4) {
            cell.title = @"强制解除绑定";
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
