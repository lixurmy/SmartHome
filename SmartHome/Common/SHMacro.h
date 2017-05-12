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


#endif /* SHMacro_h */
