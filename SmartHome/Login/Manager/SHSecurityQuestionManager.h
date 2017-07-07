//
//  SHSecurityQuestionManager.h
//  SmartHome
//
//  Created by Xu.Li on 2017/7/7.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHSecurityQuestionModel;

@interface SHSecurityQuestionManager : NSObject

+ (instancetype)sharedInstance;

- (void)resetAllQuestions;

@property (nonatomic, readonly) NSArray <SHSecurityQuestionModel *> *questions;

@end
