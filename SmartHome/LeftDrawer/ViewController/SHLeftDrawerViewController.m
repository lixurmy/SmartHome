//
//  SHLeftDrawerViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLeftDrawerViewController.h"
#import "SHBaseTableView.h"
#import "SHLeftDrawerCell.h"

static NSString * const kSHLeftDrawerViewControllerCellIdentifier = @"kSHLeftDrawerViewControllerCellIdentifier";
static CGFloat const kSHLeftDrawerViewCellHeight = 50;

@interface SHLeftDrawerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SHBaseTableView *tableView;

@end

@implementation SHLeftDrawerViewController

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
            tableViewCell.title = @"绑定网关";
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


#pragma mark - VC Relative
- (NSString *)title {
    return @"LeftDrawer";
}

@end
