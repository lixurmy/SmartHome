//
//  SHQRCodeMaskView.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHQRCodeMaskView.h"

@implementation SHQRCodeMaskView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
//    CGMutablePathRef screenPath = CGPathCreateMutable();
//    CGPathAddRect(screenPath, NULL, self.bounds);
//    CGMutablePathRef scanPath = CGPathCreateMutable();
//    CGPathAddRect(scanPath, NULL, CGRectMake(80, 80, 160, 160));
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddPath(path, NULL, screenPath);
//    CGPathAddPath(path, NULL, scanPath);
//    CGContextAddPath(ctx, path);
//    CGContextDrawPath(ctx, kCGPathEOFill); // kCGPathEOFill 方式
//    CGPathRelease(screenPath);
//    CGPathRelease(scanPath);
//    CGPathRelease(path);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
