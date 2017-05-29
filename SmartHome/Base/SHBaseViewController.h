//
//  SHBaseViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHNavigationBar.h"
#import "SHNavigationItem.h"

@interface SHBaseViewController : UIViewController

@property (nonatomic, strong) SHNavigationBar *shNavigationBar;
@property (nonatomic, strong) SHNavigationItem *shNavigationItem;
@property (nonatomic, assign) CGFloat shNavigationBarHeight;

- (BOOL)hideNavigationBar;
- (BOOL)hasSHNavigationBar;
- (BOOL)autoGenerateBackItem;
- (void)showLoading:(BOOL)animated;
- (void)hideLoading:(BOOL)animated;
- (void)showLoading:(BOOL)animated hint:(NSString *)hint;
- (void)showHint:(NSString *)hint duration:(CGFloat)duration;
- (void)dismiss;
- (SHNavigationBar *)createSHNavigationBar;
- (UIBarButtonItem *)createBackBarItem;

@end
