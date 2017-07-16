//
//  SHKeyDetailBaseCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/7/15.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHKeyDetailBaseCell.h"

@interface SHKeyDetailBaseCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *editHintLabel;

@end

@implementation SHKeyDetailBaseCell

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
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
        RAC(self, titleLabel.text) = RACObserve(self, title);
        _editHintLabel = [[UILabel alloc] init];
        _editHintLabel.text = @"编辑";
        [self.contentView addSubview:_editHintLabel];
        [_editHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        RAC(self, editHintLabel.hidden) = RACObserve(self, isEditable).not;
        
    }
    return self;
}

@end
