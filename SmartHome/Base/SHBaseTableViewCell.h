//
//  SHBaseTableViewCell.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/21.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHBaseTableViewCell;

@protocol SHBaseTableViewCellDelegate <NSObject>

@optional
- (void)handleActionForCell:(SHBaseTableViewCell *)cell info:(id)info;

@end

@interface SHBaseTableViewCell : UITableViewCell

@property (nonatomic, weak) id <SHBaseTableViewCellDelegate> delegate;

@end
