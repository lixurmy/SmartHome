//
//  SHSecurityQuestionViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/17.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSecurityQuestionViewController.h"
#import "SHSecurityQuestionManager.h"
#import "SHSecurityQuestionCell.h"
#import "SHBaseTableView.h"

static NSString * const kSHSecurityQuestionCellIdentifiter = @"kSHSecurityQuestionCellIdentifiter";

@interface SHSecurityQuestionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) SHBaseTableView *tableView;

@end

@implementation SHSecurityQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)setupTableView {
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SHSecurityQuestionManager sharedInstance].questions.count;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHSecurityQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:kSHSecurityQuestionCellIdentifiter];
    if (!cell) {
        cell = [[SHSecurityQuestionCell alloc] init];
    }
    cell.questionModel = [SHSecurityQuestionManager sharedInstance].questions[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenHeight - self.shNavigationBarHeight) / [SHSecurityQuestionManager sharedInstance].questions.count;
}

#pragma mark - Lazy Load
- (SHBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[SHBaseTableView alloc] init];
    }
    return _tableView;
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"密保问题";
}

@end
