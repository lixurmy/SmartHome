//
//  SHLockKeyboardViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/28.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"

@class SHLockKeyboardViewController;
@protocol SHLockKeyboardDelegate <NSObject>

@required
- (void)keyboardController:(SHLockKeyboardViewController *)keyboardController didChangeOutput:(NSString *)output;

- (void)keyboardController:(SHLockKeyboardViewController *)keyboardController didClickOpenLock:(id)info;

- (void)keyboardController:(SHLockKeyboardViewController *)keyboardController didClickClearInput:(id)info;

@end

@interface SHLockKeyboardViewController : SHBaseViewController

@property (nonatomic, weak) id <SHLockKeyboardDelegate> delegate;

@end
