//
//  SHKeyDetailViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/7/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHKeyDetailViewController.h"
#import "SHKeyManager.h"

@interface SHKeyDetailViewController ()

@property (nonatomic, copy) NSString *lockId;
@property (nonatomic, copy) NSString *keyNo;

@end

@implementation SHKeyDetailViewController

- (instancetype)initWithLockId:(NSString *)lockId keyNo:(NSString *)keyNo {
    self = [super init];
    if (self) {
        _lockId = lockId;
        _keyNo = keyNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self fetchKeyDetailInfo];
}

- (void)setupView {
    
}

- (void)fetchKeyDetailInfo {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
