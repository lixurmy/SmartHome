//
//  SHLeftDrawerCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/21.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLeftDrawerCell.h"

@interface SHLeftDrawerCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SHLeftDrawerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBCOLOR(255, 255, 255);
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = RGBCOLOR(0, 0, 255);
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@(1));
        }];
    }
    return self;
}

#pragma mark - Set
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}

@end
