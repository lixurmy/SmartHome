//
//  SHSecurityQuestionCell.m
//  SmartHome
//
//  Created by Xu.Li on 2017/7/7.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSecurityQuestionCell.h"
#import "SHSecurityQuestionModel.h"

@interface SHSecurityQuestionCell ()

@property (nonatomic, strong) UILabel *questionLabel;

@end

@implementation SHSecurityQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_questionLabel];
        [_questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        RAC(self, questionLabel.text) = RACObserve(self, questionModel.question);
    }
    return self;
}

@end
