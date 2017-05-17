//
//  SHLeftDrawerViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHLeftDrawerViewController.h"

@interface SHLeftDrawerViewController ()

@end

@implementation SHLeftDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(0, 0, 0)];
}

#pragma mark - VC Relative
- (NSString *)title {
    return @"LeftDrawer";
}

@end
