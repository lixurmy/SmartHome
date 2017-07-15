//
//  SHLockDetailCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockDetailCell.h"
#import "SHKeyModel.h"

@interface SHLockDetailCell ()

@property (nonatomic, strong) UILabel *aliasLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *lastUnlockLabel;

@end

@implementation SHLockDetailCell

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
        _aliasLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_aliasLabel];
        [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
        RAC(self, aliasLabel.text) = RACObserve(self, keyModel.alias);
        _typeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        @weakify(self);
        [RACObserve(self, keyModel.type) subscribeNext:^(id x) {
            @strongify(self);
            SHKeyType type = [x integerValue];
            switch (type) {
                case SHKeyTypeUnknown0:
                    [self.typeLabel setText:@"未知类型0"];
                    break;
                case SHKeyTypeUnknown1:
                    [self.typeLabel setText:@"未知类型1"];
                    break;
                case SHKeyTypeUnknown2:
                    [self.typeLabel setText:@"未知类型2"];
                    break;
                case SHKeyTypeTemp:
                    [self.typeLabel setText:@"临时钥匙"];
                    break;
                case SHKeyTypeUser:
                    [self.typeLabel setText:@"普通钥匙"];
                    break;
            }
        }];
        _lastUnlockLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_lastUnlockLabel];
        [_lastUnlockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.typeLabel.mas_left).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        RAC(self, lastUnlockLabel.text) = RACObserve(self, keyModel.lastUnlockTime);
    }
    return self;
}

@end
