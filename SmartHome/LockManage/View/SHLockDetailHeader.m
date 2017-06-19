//
//  SHLockDetailHeader.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLockDetailHeader.h"
#import "SHLockModel.h"

@interface SHLockDetailHeader ()

@property (nonatomic, strong) UILabel *aliasLabel;
@property (nonatomic, strong) UILabel *batteryLabel;
@property (nonatomic, strong) UILabel *signalLabel;

@end

@implementation SHLockDetailHeader

#pragma mark - Init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _aliasLabel = [[UILabel alloc] init];
        [self addSubview:_aliasLabel];
        [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        RAC(_aliasLabel, text) = RACObserve(self, lockModel.lockMacAddress);
    }
    return self;
}

@end
