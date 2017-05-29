//
//  SHSettingsBaseCell.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/29.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseTableViewCell.h"

@interface SHSettingsBaseCell : SHBaseTableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL showCheckMark;

@end
