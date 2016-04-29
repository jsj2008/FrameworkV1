//
//  StorageUnit.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StorageUnitDelegate;


/*********************************************************
 
    @class
        StorageUnit
 
    @abstract
        存储服务单元，负责启动和关闭存储服务
 
    @discussion
        1，应当在主线程启动和关闭存储服务
        2，应当在应用启动后尽快启动存储服务，在应用结束前关闭存储服务
        3，必须为单元指定一个代理对象，在接收到启动结束消息后才能使用存储服务
 
 *********************************************************/

@interface StorageUnit : NSObject

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<StorageUnitDelegate> delegate;

/*!
 * @brief 消息线程，代理对象将在该线程上接收消息，不能为空
 */
@property (nonatomic) NSThread *notifyThread;

/*!
 * @brief 单例
 */
+ (StorageUnit *)sharedInstance;

/*!
 * @brief 启动存储服务
 * @discussion 启动过程中将向代理对象发送启动消息
 */
- (void)start;

/*!
 * @brief 关闭存储服务
 * @discussion 关闭过程中将向代理对象发送关闭消息
 */
- (void)stop;

@end


/*********************************************************
 
    @protocol
        StorageUnitDelegate
 
    @abstract
        存储服务消息
 
 *********************************************************/

@protocol StorageUnitDelegate <NSObject>

@optional

/*!
 * @brief 存储服务启动成功消息
 * @param unit 存储服务单元
 * @param successfully 成功标志
 */
- (void)storageUnit:(StorageUnit *)unit didStartSuccessfully:(BOOL)successfully;

/*!
 * @brief 存储服务启动进度消息
 * @param unit 存储服务单元
 * @param progress 执行进度
 */
- (void)storageUnit:(StorageUnit *)unit isStartingWithProgress:(float)progress;

/*!
 * @brief 存储服务关闭成功消息
 * @param unit 存储服务单元
 * @param successfully 成功标志
 */
- (void)storageUnit:(StorageUnit *)unit didStopSuccessfully:(BOOL)successfully;

/*!
 * @brief 存储服务关闭进度消息
 * @param unit 存储服务单元
 * @param progress 执行进度
 */
- (void)storageUnit:(StorageUnit *)unit isStopingWithProgress:(float)progress;

@end
