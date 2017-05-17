//
//  SHMacro.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#ifndef SHMacro_h
#define SHMacro_h

#pragma - mark DEBUG
#ifdef DEBUG

#define SHLog(format, ...) NSLog(@"Line[%d] %s " format, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)

#else

#define SHLog(format, ...)

#endif

#pragma - mark COLOR

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#pragma - mark SCREEN

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kStatusBarHeight 20
#define kNavigationBarHeight 44

#endif /* SHMacro_h */
