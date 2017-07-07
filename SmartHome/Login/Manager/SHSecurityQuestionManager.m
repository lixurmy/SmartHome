//
//  SHSecurityQuestionManager.m
//  SmartHome
//
//  Created by Xu.Li on 2017/7/7.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHSecurityQuestionManager.h"
#import "SHSecurityQuestionModel.h"

static SHSecurityQuestionManager * _instance;

@interface SHSecurityQuestionManager ()

@property (nonatomic, strong) NSArray <SHSecurityQuestionModel *> *question;
@property (nonatomic, strong) NSArray *questionDescs;

@end

@implementation SHSecurityQuestionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHSecurityQuestionManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSUInteger i = 1; i <= self.questionDescs.count; ++i) {
            SHSecurityQuestionModel *model = [self questionModelForId:i];
            [mArray addObject:model];
        }
        _questions = [NSArray arrayWithArray:mArray];
    }
    return self;
}

- (SHSecurityQuestionModel *)questionModelForId:(NSUInteger)questionId {
    SHSecurityQuestionModel *model = nil;
    NSString *stringId = [NSString stringWithFormat:@"%ld", questionId];
    if (questionId - 1 < self.questionDescs.count) {
        model = [[SHSecurityQuestionModel alloc] initWithQuestionId:stringId question:self.questionDescs[questionId - 1]];
    }
    return model;
}

#pragma mark - Public
- (void)resetAllQuestions {
    for (SHSecurityQuestionModel *model in self.questions) {
        model.selected = NO;
        model.answer = nil;
    }
}

#pragma mark - Lazy Load
- (NSArray *)questionDescs {
    if (!_questionDescs) {
        _questionDescs = @[@"您的出生地是？",
                           @"您母亲的姓名是？",
                           @"您父亲的姓名是？",
                           @"您高中班主任的名字是？",
                           @"您最喜欢的球队名字是？",
                           @"您最熟悉的童年好友是？",
                           @"您曾经使用过的名字是？",
                           @"您最喜欢的城市名字是？"];
    }
    return _questionDescs;
}

@end
