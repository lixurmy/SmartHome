//
//  SHLockInfoCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockInfoCell.h"
#import "SHLockManager.h"

@interface SHLockInfoCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *currentLockLabel;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UILabel *initedLabel;
@property (nonatomic, strong) UIButton *updateAliasButton;
@property (nonatomic, strong) UIButton *setCurrentLockButton;
@property (nonatomic, strong) UIButton *openLockButton;

@end

@implementation SHLockInfoCell

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@(px));
        }];
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = PingFangSCMedium(24);
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView).offset(-12);
        }];
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.font = PingFangSCRegular(11);
        [self.contentView addSubview:_onlineLabel];
        [_onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        }];
        @weakify(self);
        [RACObserve(self, model.online) subscribeNext:^(id x) {
            @strongify(self);
            BOOL online = [x boolValue];
            if (online) {
                [self.onlineLabel setText:@"在线"];
            } else {
                [self.onlineLabel setText:@"离线"];
            }
        }];
        _initedLabel = [self commonLabelWithTitle:@"未配对"];
        [self.contentView addSubview:_initedLabel];
        [_initedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_onlineLabel.mas_right).offset(5);
            make.top.equalTo(_onlineLabel);
        }];
        [RACObserve(self, model.inited) subscribeNext:^(id x) {
            @strongify(self);
            BOOL inited = [x boolValue];
            if (inited) {
                [self.initedLabel setText:@"已配对"];
            } else {
                [self.initedLabel setText:@"未配对"];
            }
        }];
        _currentLockLabel = [self commonLabelWithTitle:@"常用锁"];
        [self.contentView addSubview:_currentLockLabel];
        [_currentLockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_initedLabel.mas_right).offset(5);
            make.top.equalTo(_initedLabel);
        }];
        _updateAliasButton = [self commonButtonWithTitle:@"设置别名"];
        [self.contentView addSubview:_updateAliasButton];
        [_updateAliasButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [_updateAliasButton addTarget:self
                               action:@selector(updateAlias:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        _setCurrentLockButton = [self commonButtonWithTitle:@"常用"];
        [self.contentView addSubview:_setCurrentLockButton];
        [_setCurrentLockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_updateAliasButton.mas_left).offset(-10);
            make.top.equalTo(_updateAliasButton);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [_setCurrentLockButton addTarget:self
                                  action:@selector(updateCurrentLock:)
                        forControlEvents:UIControlEventTouchUpInside];
        _openLockButton = [self commonButtonWithTitle:@"开锁"];
        [self.contentView addSubview:_openLockButton];
        [_openLockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_setCurrentLockButton.mas_left).offset(-10);
            make.top.equalTo(_updateAliasButton);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [_openLockButton addTarget:self
                            action:@selector(openLock:)
                  forControlEvents:UIControlEventTouchUpInside];
        [RACObserve(self, model.alias) subscribeNext:^(id x) {
            @strongify(self);
            if (x) {
                [self.nameLabel setText:x];
            } else {
                [self.nameLabel setText:@"添加别名"];
            }
        }];
        [RACObserve(self, model.lockId) subscribeNext:^(NSString *lockId) {
            @strongify(self);
            if ([lockId isEqualToString:[SHLockManager sharedInstance].currentLock.lockId]) {
                [self.currentLockLabel setHidden:NO];
            } else {
                [self.currentLockLabel setHidden:YES];
            }
        }];
    }
    return self;
}

#pragma mark - Private
- (UILabel *)commonLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.font = PingFangSCRegular(11);
    label.text = title;
    return label;
}

- (UIButton *)commonButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
    [button.titleLabel setFont:PingFangSCRegular(10)];
    [button.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
    [button.layer setBorderWidth:px];
    [button.layer setCornerRadius:10];
    return button;
}

#pragma mark - Cell Action
- (void)updateAlias:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleActionForCell:info:)]) {
        [self.delegate handleActionForCell:self info:@"updateAlias"];
    }
}

- (void)updateCurrentLock:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleActionForCell:info:)]) {
        [self.delegate handleActionForCell:self info:@"updateCurrentLock"];
    }
}

- (void)openLock:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleActionForCell:info:)]) {
        [self.delegate handleActionForCell:self info:@"openLock"];
    }
}

#pragma mark - Set
- (void)setModel:(SHLockModel *)model {
    _model = model;
}

@end
