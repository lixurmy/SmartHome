//
//  SHKeyDetailBaseCell.h
//  SmartHome
//
//  Created by Xu Li on 2017/7/15.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseTableViewCell.h"

@interface SHKeyDetailBaseCell : SHBaseTableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isEditable;

@end
