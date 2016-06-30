//
//  APPConfiguration.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        APPConfiguration
 
    @abstract
        APP配置
 
 *********************************************************/

@interface APPConfiguration : NSObject

/*!
 * @brief 单例
 * @result APPConfiguration全局对象
 */
+ (APPConfiguration *)sharedInstance;

#pragma mark - File directory

/*!
 * @brief app日志目录，默认$cache/APPLog
 */
@property (atomic, copy) NSString *appLogDirectory;

/*!
 * @brief 图片目录，默认$cache/Image
 */
@property (atomic, copy) NSString *imageDirectory;

#pragma mark - Task onfiguration

/*!
 * @brief 守护池容量，默认5
 */
@property (atomic) NSUInteger daemonTaskPoolCapacity;

/*!
 * @brief 守护池的常驻队列容量，默认2
 */
@property (atomic) NSUInteger daemonTaskPoolPersistentQueueCapacity;

/*!
 * @brief 自由池容量，默认20
 */
@property (atomic) NSUInteger freeTaskPoolCapacity;

/*!
 * @brief 后台池容量，默认10
 */
@property (atomic) NSUInteger backgroundTaskPoolCapacity;

/*!
 * @brief 队列负载容量，默认20
 */
@property (atomic) NSUInteger defaultTaskQueueLoadingLimit;

@end
