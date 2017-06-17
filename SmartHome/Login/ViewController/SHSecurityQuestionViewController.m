//
//  SHSecurityQuestionViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/17.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSecurityQuestionViewController.h"

@interface SHSecurityQuestionViewController ()

@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation SHSecurityQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"密保问题";
}

@end
