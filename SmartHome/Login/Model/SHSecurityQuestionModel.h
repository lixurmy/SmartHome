//
//  SHSecurityQuestionModel.h
//  SmartHome
//
//  Created by Xu.Li on 2017/7/7.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseModel.h"

@interface SHSecurityQuestionModel : SHBaseModel

@property (nonatomic, readonly) NSString *questionId;
@property (nonatomic, readonly) NSString *question;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithQuestionId:(NSString *)questionId question:(NSString *)question;

@end
