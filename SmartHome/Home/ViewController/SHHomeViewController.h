//
//  SHHomeViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHHomeViewController : SHBaseViewController

@property (nonatomic, strong) UIView *maskView;

- (void)showMaskView:(BOOL)animated;
- (void)hideMaskView;

@end
