//
//  SHWaterReaderViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/2.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHWaterReaderViewController.h"
#import "SHWaterReaderManager.h"
#import "SHWaterReaderModel.h"

@interface SHWaterReaderViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SHWaterReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(400, 300));
    }];
    [[SHWaterReaderManager sharedInstance] fetchColdWaterImageComplete:^(BOOL succ, SHWaterReaderStatus statusCode, id info) {
        SHLog(@"%@", info);
        if (!info) {
            return;
        }
        SHWaterReaderModel *model = info[0];
        NSString *urlString = [NSString stringWithFormat:@"%@/img/w/%@.jpg?gwid=%@", [SHNetworkManager waterManager].baseURL.absoluteString, model.timestamp, [SHUserManager sharedInstance].gatewayId];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }];
}


#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"远程抄表";
}

@end
