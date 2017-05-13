//
//  SHBaseURL.h
//  SmartHome
//
//  Created by Xu Li on 2017/5/13.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBaseURL : NSObject

+ (instancetype)sharedInstance;

- (NSString *)baseUrl;

@end
