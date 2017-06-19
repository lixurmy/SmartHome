//
//  SHLockInfoCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockInfoCell.h"

@interface SHLockInfoCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signalLabel;
@property (nonatomic, strong) UILabel *batteryLabel;
@property (nonatomic, strong) UIButton *updateAliasButton;

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
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        _updateAliasButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateAliasButton setTitle:@"设置别名" forState:UIControlStateNormal];
        [_updateAliasButton.titleLabel setFont:PingFangSCRegular(10)];
        [_updateAliasButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        [_updateAliasButton.layer setBorderColor:RGBCOLOR(0, 0, 0).CGColor];
        [_updateAliasButton.layer setBorderWidth:px];
        [_updateAliasButton.layer setCornerRadius:10];
        [self.contentView addSubview:_updateAliasButton];
        [_updateAliasButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [_updateAliasButton addTarget:self
                               action:@selector(updateAlias:)
                     forControlEvents:UIControlEventTouchUpInside];
        @weakify(self);
        [RACObserve(self, model.alias) subscribeNext:^(id x) {
            @strongify(self);
            if (x) {
                [self.nameLabel setText:x];
            } else {
                [self.nameLabel setText:@"添加别名"];
            }
        }];
    }
    return self;
}

#pragma mark - Cell Action
- (void)updateAlias:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleActionForCell:info:)]) {
        [self.delegate handleActionForCell:self info:nil];
    }
}

#pragma mark - Set
- (void)setModel:(SHLockModel *)model {
    _model = model;
}

@end
