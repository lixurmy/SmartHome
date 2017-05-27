//
//  SHBaseTableViewCell.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/21.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseTableViewCell.h"

@implementation SHBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (selected) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backgroundColor = [UIColor lightGrayColor];
        } completion:^(BOOL finished) {
            if (finished) {
                self.backgroundColor = [UIColor whiteColor];
            }
        }];
    }
}

@end
