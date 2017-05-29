//
//  SHSettingSection.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/29.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSettingSection.h"

@interface SHSettingSection ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SHSettingSection

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = PingFangSCRegular(14);
        _titleLabel.textColor = RGBCOLOR(11, 11, 11);
        _titleLabel.text = title;
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
}

@end
