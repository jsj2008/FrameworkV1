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

@property (atomic, copy) NSString *appLogDirectory;

/*!
 * @brief 守护池容量，默认5
 */
@property (atomic) NSUInteger daemonPoolCapacity;

/*!
 * @brief 守护池的常驻队列容量，默认2
 */
@property (atomic) NSUInteger daemonPoolPersistentQueueCapacity;

/*!
 * @brief 自由池容量，默认20
 */
@property (atomic) NSUInteger freePoolCapacity;

/*!
 * @brief 后台池容量，默认10
 */
@property (atomic) NSUInteger backgroundPoolCapacity;

/*!
 * @brief 队列负载容量，默认20
 */
@property (atomic) NSUInteger defaultQueueLoadingLimit;

@end
