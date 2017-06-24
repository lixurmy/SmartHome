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
@property (nonatomic, strong) UILabel *initedLabel;
@property (nonatomic, strong) UILabel *hwVerLabel;
@property (nonatomic, strong) UILabel *swVerLabel;
@property (nonatomic, strong) UILabel *onlineLabel;

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
        _aliasLabel.font = PingFangSCMedium(45);
        [self addSubview:_aliasLabel];
        [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-20);
        }];
        RAC(_aliasLabel, text) = RACObserve(self, lockModel.alias);
        
        _initedLabel = [self commonLabelWithTitle:@"未配对"];
        [self addSubview:_initedLabel];
        [_initedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(_aliasLabel.mas_bottom).offset(30);
        }];
        @weakify(self);
        [RACObserve(self, lockModel.inited) subscribeNext:^(id x) {
            @strongify(self);
            BOOL inited = [x boolValue];
            if (inited) {
                [self.initedLabel setText:@"已配对"];
            } else {
                [self.initedLabel setText:@"未配对"];
            }
        }];
        
        _onlineLabel = [self commonLabelWithTitle:@"离线"];
        [self addSubview:_onlineLabel];
        [_onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_initedLabel.mas_right).offset(10);
            make.top.equalTo(_initedLabel);
        }];
        [RACObserve(self, lockModel.online) subscribeNext:^(id x) {
            BOOL online = [x boolValue];
            if (online) {
                [self.onlineLabel setText:@"在线"];
            } else {
                [self.onlineLabel setText:@"离线"];
            }
        }];
        
        _signalLabel = [self commonLabelWithTitle:@"信号:0"];
        [self addSubview:_signalLabel];
        [_signalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_onlineLabel.mas_right).offset(10);
            make.top.equalTo(_initedLabel);
        }];
        [RACObserve(self, lockModel.signal) subscribeNext:^(id x) {
            @strongify(self);
            NSUInteger signal = [x integerValue];
            [self.signalLabel setText:[NSString stringWithFormat:@"信号: %ld", (unsigned long)signal]];
        }];
        
        _hwVerLabel = [self commonLabelWithTitle:@"hsVer:"];
        [self addSubview:_hwVerLabel];
        [_hwVerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_signalLabel.mas_right).offset(10);
            make.top.equalTo(_signalLabel);
        }];
        [RACObserve(self, lockModel.hwVer) subscribeNext:^(id x) {
            @strongify(self);
            NSString *hwVer = (NSString *)x;
            if (hwVer) {
                [self.hwVerLabel setText:[NSString stringWithFormat:@"hwVer: %@", hwVer]];
            } else {
                [self.hwVerLabel setText:@"hwVer:0.0"];
            }
        }];
        
        _swVerLabel = [self commonLabelWithTitle:@"swVer:"];
        [self addSubview:_swVerLabel];
        [_swVerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hwVerLabel.mas_right).offset(10);
            make.top.equalTo(_hwVerLabel);
        }];
        [RACObserve(self, lockModel.swVer) subscribeNext:^(id x) {
            @strongify(self);
            NSString *swVer = (NSString *)x;
            if (swVer) {
                [self.swVerLabel setText:[NSString stringWithFormat:@"swVer: %@", swVer]];
            } else {
                [self.swVerLabel setText:@"swVer: 0.0"];
            }
        }];
        [RACObserve(self, lockModel) subscribeNext:^(id x) {
            @strongify(self);
            if (x) {
                self.hidden = NO;
            } else {
                self.hidden = YES;
            }
        }];
    }
    return self;
}

#pragma mark - Private
- (UILabel *)commonLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.font = PingFangSCRegular(15);
    label.text = title;
    return label;
}

@end
