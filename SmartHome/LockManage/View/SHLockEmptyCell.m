//
//  SHLockEmptyCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/20.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockEmptyCell.h"

@interface SHLockEmptyCell ()

@property (nonatomic, strong) UIButton *addLockButton;

@end

@implementation SHLockEmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _addLockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addLockButton setTitle:@"请添加一把锁" forState:UIControlStateNormal];
        [self.contentView addSubview:_addLockButton];
        [_addLockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(200, 100));
        }];
        [_addLockButton addTarget:self action:@selector(addLockAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addLockAction {
    if ([self.delegate respondsToSelector:@selector(handleActionForCell:info:)]) {
        [self.delegate handleActionForCell:self info:nil];
    }
}

@end
