//
//  SHAddKeyViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHAddKeyViewController.h"

@interface SHAddKeyViewController ()

@property (nonatomic, copy) NSString *lockId;

@end

@implementation SHAddKeyViewController

- (instancetype)initWithLockId:(NSString *)lockId {
    self = [super init];
    if (self) {
        _lockId = lockId;
    }
    return self;
}

#pragma mark - VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"添加钥匙";
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (BOOL)autoGenerateBackItem {
    return YES;
}

@end
