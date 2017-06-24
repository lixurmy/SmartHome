//
//  SHSettingsBaseCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/29.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSettingsBaseCell.h"

@interface SHSettingsBaseCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *checkMark;

@end

@implementation SHSettingsBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = PingFangSCRegular(18);
        _titleLabel.textColor = RGBCOLOR(9, 9, 9);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(10);
            make.height.equalTo(@20);
        }];
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = PingFangSCRegular(14);
        _descLabel.textColor = RGBCOLOR(33, 33, 33);
        [self.contentView addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.height.equalTo(@18);
        }];
        _checkMark = [[UIImageView alloc] init];
        [self.contentView addSubview:_checkMark];
        [_checkMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setBackgroundColor:RGBCOLOR(0, 0, 0)];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@(px));
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    [self.titleLabel setText:_title];
}

- (void)setDesc:(NSString *)desc {
    _desc = [desc copy];
    [self.descLabel setText:_desc];
    if (!_desc || !_desc.length) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@20);
        }];
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(10);
            make.height.equalTo(@20);
        }];
    }
}

- (void)setChecked:(BOOL)checked {
    if (checked) {
        [self.checkMark setImage:[UIImage imageNamed:@"settings_cell_checkmark_checked"]];
    } else {
        [self.checkMark setImage:[UIImage imageNamed:@"settings_cell_checkmark_unchecked"]];
    }
}

- (void)setShowCheckMark:(BOOL)showCheckMark {
    [self.checkMark setHidden:!showCheckMark];
}

@end
