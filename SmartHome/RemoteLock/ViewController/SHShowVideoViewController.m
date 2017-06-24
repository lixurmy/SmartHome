//
//  SHShowVideoViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/5/30.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHShowVideoViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface SHShowVideoViewController ()

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@end

@implementation SHShowVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(0, 0, 0)];
    [self setupPlayer];
}

- (void)setupPlayer {
    NSURL * url =[NSURL URLWithString:@"rtsp://13.112.216.206:10554/55201.dsp"];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    [self.view addSubview:self.player.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.player && ![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.player && ![self.player isPlaying]) {
        [self.player play];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player pause];
}


@end
