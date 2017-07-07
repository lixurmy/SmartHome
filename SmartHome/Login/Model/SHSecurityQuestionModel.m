//
//  SHSecurityQuestionModel.m
//  SmartHome
//
//  Created by Xu.Li on 2017/7/7.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSecurityQuestionModel.h"

@interface SHSecurityQuestionModel ()

@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *question;

@end

@implementation SHSecurityQuestionModel

- (instancetype)initWithQuestionId:(NSString *)questionId question:(NSString *)question {
    self = [super init];
    if (self) {
        _questionId = questionId;
        _question = question;
        _answer = nil;
        _selected = NO;
    }
    return self;
}

@end
