//
//  SHLockManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/18.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SHLockHttpStatusCode) {
    SHLockHttpStatusSuccess         = 200,
    SHLockHttpStatusLockExist       = 4105,
    SHLockHttpStatusLockNotFound    = 4107
};

@interface SHLockManager : NSObject

@end
