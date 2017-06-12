//
//  SHQRCodeMaskView.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseView.h"

@interface SHQRCodeMaskView : SHBaseView

@property (nonatomic, assign) CGRect scanRect;

- (instancetype)initWithScanRect:(CGRect)scanRect;

@end
