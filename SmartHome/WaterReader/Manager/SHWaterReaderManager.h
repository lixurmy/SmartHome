//
//  SHWaterReaderManager.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/3.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SHWaterReaderStatus) {
    SHWaterReaderStatusSuccess = 200,
    SHWaterReaderStatusMacInvalid = 4011,
    SHWaterReaderStatusFileOpenError = 4012,
    SHWaterReaderStatusCOMDataError = 4051,
    SHWaterReaderStatusReceivingDataTimeOut = 4058,
    SHWaterReaderStatusInternalError = 4085,
    SHWaterReaderStatusFailedCreateJSON = 4087
};

typedef void(^SHWaterReaderComplete)(BOOL succ, SHWaterReaderStatus statusCode, id info);

@interface SHWaterReaderManager : NSObject

@property (nonatomic, readonly) NSString *lastColdWaterRecordTime;
@property (nonatomic, readonly) NSString *lastHotWaterRecordTime;

+ (instancetype)sharedInstance;

/**
 获取冷水表读数
 返回个时间戳，根据这个时间戳拼接出图片地址，再获取该图片地址
 可以直接使用下面的获取图片的方法，内部会调用此方法
 @param complete 返回结果回调
 */
- (void)fetchColdWaterReaderComplete:(SHWaterReaderComplete)complete;

/**
 获取热水表读数
 返回个时间戳，根据这个时间戳拼接出图片地址，再获取该图片地址
 可以直接使用下面的获取图片的方法，内部会调用此方法
 @param complete 返回结果回调
 */
- (void)fetchHotWaterReaderComplete:(SHWaterReaderComplete)complete;

/**
 获取冷水表读数图片
 @param complete 返回结果回调，图片链接返回在info中
 */
- (void)fetchColdWaterImageComplete:(SHWaterReaderComplete)complete;

/**
 获取热水表读数图片
 @param complete 返回结果回调，图片链接返回在info中
 */
- (void)fetchHotWaterImageComplete:(SHWaterReaderComplete)complete;

@end
