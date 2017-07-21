//
//  SHKeyDetailViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHKeyDetailViewController.h"
#import "SHKeyManager.h"
#import "SHKeyModel.h"
#import "SHKeyDetailTableView.h"
#import "SHKeyDetailBaseCell.h"

typedef NS_ENUM(NSInteger, SHKeyDetailRow) {
    SHKeyDetailRowAlias     = 0,
    SHKeyDetailRowType      = 1,
    SHKeyDetailRowActive    = 2,
    SHKeyDetailRowAlert     = 3,
    SHKeyDetailRowTimeLimit = 4,
    SHKeyDetailRowTimeLeft  = 5,
    SHKeyDetailRowAddTime   = 6,
    SHKeyDetailRowStartTime = 8,
    SHKeyDetailRowEndTime   = 9,
    SHKeyDetailRowLastUnlock= 7
};

static NSString * const kSHKeyDetailCellIdentifiter = @"kSHKeyDetailCellIdentifiter";

@interface SHKeyDetailViewController () <UITableViewDelegate, UITableViewDataSource, SHBaseTableViewCellDelegate>

@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, copy) NSString *keyNo;
@property (nonatomic, strong) SHKeyModel *keyModel;
@property (nonatomic, strong) NSArray *showInfos;

@property (nonatomic, strong) SHKeyDetailTableView *tableView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UITextField *aliasField;

@end

@implementation SHKeyDetailViewController

#pragma mark - Init
- (instancetype)initWithKeyModel:(SHKeyModel *)keyModel {
    self = [super init];
    if (self) {
        _keyModel = keyModel;
    }
    return self;
}

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupApperance];
    [self setupView];
}

- (void)setupApperance {
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.updateButton];
//    [self.updateButton sizeToFit];
//    [self.shNavigationItem setRightBarButtonItem:rightBarItem];
}

- (void)setupView {
    [self.view addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@60);
    }];
    
    self.tableView = [[SHKeyDetailTableView alloc] init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.deleteButton.mas_top);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHKeyDetailRow row = indexPath.row;
    SHKeyDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kSHKeyDetailCellIdentifiter];
    if (!cell) {
        cell = [[SHKeyDetailBaseCell alloc] init];
    }
    switch (row) {
        case SHKeyDetailRowAlias: {
            cell.title = [NSString stringWithFormat:@"钥匙名称:%@", self.keyModel.alias];
            cell.isEditable = YES;
            break;
        }
        case SHKeyDetailRowType: {
            NSString *type = [self keyTypeName];
            cell.title = [NSString stringWithFormat:@"钥匙类型:%@", type];
            break;
        }
        case SHKeyDetailRowActive: {
            cell.title = [NSString stringWithFormat:@"激活状态:%@", self.keyModel.isActive ? @"激活" : @"未激活"];
            break;
        }
        case SHKeyDetailRowAlert: {
            cell.title = [NSString stringWithFormat:@"报警钥匙:%@", self.keyModel.isAlertKey ? @"是" : @"否"];
            cell.isEditable = YES;
            break;
        }
        case SHKeyDetailRowAddTime: {
            cell.title = [NSString stringWithFormat:@"添加时间:%@", self.keyModel.addTime];
            break;
        }
        case SHKeyDetailRowStartTime: {
            cell.title = [NSString stringWithFormat:@"生效时间:%@", self.keyModel.startTime ?: @"无"];
            break;
        }
        case SHKeyDetailRowEndTime: {
            cell.title = [NSString stringWithFormat:@"失效时间:%@", self.keyModel.endTime ?: @"无"];
            break;
        }
        case SHKeyDetailRowTimeLimit: {
            if (self.keyModel.type == SHKeyTypeTemp) {
                cell.title = [NSString stringWithFormat:@"最大使用次数:%ld", (long)self.keyModel.timesLimit];
            } else {
                cell.title = [NSString stringWithFormat:@"最大使用次数:无效"];
            }
            break;
        }
        case SHKeyDetailRowTimeLeft: {
            if (self.keyModel.type == SHKeyTypeTemp) {
                cell.title = [NSString stringWithFormat:@"剩余使用次数:%ld", (long)self.keyModel.timesLeft];
            } else {
                cell.title = [NSString stringWithFormat:@"剩余使用次数:无效"];
            }
            break;
        }
        case SHKeyDetailRowLastUnlock: {
            cell.title = [NSString stringWithFormat:@"上一次开锁时间:%@", self.keyModel.lastUnlockTime];
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHKeyDetailRow row = indexPath.row;
    if (row == SHKeyDetailRowAlias) {
        [self showUpdateAliasAlert];
    } else if (row == SHKeyDetailRowAlert) {
        [self showUpdateAlertAction];
    }
}

#pragma mark - Private
- (void)showUpdateAliasAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"修改名称" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.aliasField = textField;
        textField.placeholder = @"请填写新的名称";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAlias];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showUpdateAlertAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否设置为报警钥匙" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"设置报警" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAlert:YES];
    }];
    UIAlertAction *removeAlertAction = [UIAlertAction actionWithTitle:@"取消报警" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAlert:NO];
    }];
    [alert addAction:alertAction];
    [alert addAction:removeAlertAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateAlias {
    if (self.aliasField.text.length && ![self.keyModel.alias isEqualToString:self.aliasField.text]) {
        NSString *alias = self.aliasField.text;
        @weakify(self);
        [self showLoading:YES hint:@"修改中..."];
        [[SHKeyManager sharedInstance] updateKeyWithLockId:self.keyModel.lockId keyNo:self.keyModel.keyNo alias:alias alert:self.keyModel.isAlertKey complete:^(BOOL succ, SHKeyHttpStatus statusCode, id info) {
            @strongify(self);
            if (succ) {
                [self showHint:@"修改成功" duration:1.0];
                self.keyModel.alias = self.aliasField.text;
                [self.tableView reloadData];
            } else {
                [self showHint:[NSString stringWithFormat:@"修改失败:%ld", (long)statusCode] duration:1.0];
            }
        }];
    } else {
        [self showHint:@"未修改名称" duration:1.0];
    }
}

- (void)updateAlert:(BOOL)isAlert {
    if (!(self.keyModel.isAlertKey == isAlert)) {
        @weakify(self);
        [self showLoading:YES hint:@"修改中..."];
        [[SHKeyManager sharedInstance] updateKeyWithLockId:self.keyModel.lockId keyNo:self.keyModel.keyNo alias:self.keyModel.alias alert:isAlert complete:^(BOOL succ, SHKeyHttpStatus statusCode, id info) {
            @strongify(self);
            if (succ) {
                [self showHint:@"设置成功" duration:1.0];
                self.keyModel.isAlertKey = isAlert;
                [self.tableView reloadData];
            } else {
                [self showHint:[NSString stringWithFormat:@"修改失败:%ld", (long)statusCode] duration:1.0];
            }
        }];
    } else {
        [self showHint:@"修改成功" duration:1.0];
    }
}

- (void)deleteAction:(UIButton *)sender {
    NSString *message = [NSString stringWithFormat:@"确定要删除钥匙:%@", self.keyModel.alias];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteKeyModel];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteKeyModel {
    @weakify(self);
    [[SHKeyManager sharedInstance] deleteKeyWithLockId:self.keyModel.lockId keyNo:self.keyModel.keyNo complete:^(BOOL succ, SHKeyHttpStatus statusCode, id info) {
        @strongify(self);
        if (succ) {
            [self handleDeleteSuccessReponse:info];
        } else {
            [self handleDeleteFailureResponse:info];
        }
    }];
}

- (void)handleDeleteSuccessReponse:(id)responseObject {

}

- (void)handleDeleteFailureResponse:(id)responseObject {
    
}

- (NSString *)keyTypeName {
    NSString *type;
    switch (self.keyModel.type) {
        case SHKeyTypeTemp:
            type = @"临时钥匙";
            break;
        case SHKeyTypeUser:
            type = @"普通钥匙";
            break;
        case SHKeyTypeUnknown0:
            type = @"未知钥匙0";
            break;
        case SHKeyTypeUnknown1:
            type = @"未知钥匙1";
            break;
        case SHKeyTypeUnknown2:
            type = @"未知钥匙2";
            break;
    }
    return type;
}

#pragma mark - Lazy Load
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除钥匙" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        _deleteButton.backgroundColor = NavigationBarColor;
        [_deleteButton addTarget:self
                          action:@selector(deleteAction:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_updateButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
    }
    return _updateButton;
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"钥匙详情";
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)autoGenerateBackItem {
    return YES;
}

@end
