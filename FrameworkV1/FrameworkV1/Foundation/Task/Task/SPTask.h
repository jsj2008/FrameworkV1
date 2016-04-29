//
//  SPTask.h
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @enum
        SPTaskRunStatus
 
    @abstract
        SPTask运行状态标志
 
 **********************************************************/

typedef enum
{
    SPTaskRunStatus_Prepare = 1,    // 准备阶段（尚未运行）
    SPTaskRunStatus_Running = 2,    // 运行阶段
    SPTaskRunStatus_Finish  = 3     // 结束阶段
}SPTaskRunStatus;


/**********************************************************
 
    @class
        SPTask
 
    @abstract
        完成特定功能的任务的对象
 
    @discussion
        1、每一个Task对象都有自己的负载量，在任务调度的时候使用
        2、运行状态通过执行Task的方法自行调整，不建议子类手动更改。在初始化时为准备状态，执行main方法后为运行状态，执行cancel方法后为结束阶段
 
 **********************************************************/

@interface SPTask : NSObject

/*!
 * @brief 协议消息的代理
 */
@property (nonatomic, weak) id delegate;

/*!
 * @brief task自身负载量，默认为0
 */
@property (nonatomic) NSUInteger loadSize;

/*!
 * @brief 运行状态
 */
@property (nonatomic) SPTaskRunStatus runStatus;

/*!
 * @brief 接收消息的线程
 * @discussion 值为nil表征总是在当前线程接收消息
 */
@property (nonatomic) NSThread *notifyThread;

/*!
 * @brief 运行线程，指向执行run方法的线程
 * @result 运行线程
 */
- (NSThread *)runningThread;

/*!
 * @brief 总负载
 * @result 总负载
 */
- (NSUInteger)totalLoadSize;

/*!
 * @brief 任务入口，配置Task并调用run方法
 * @discussion 本方法在调用run方法前会做一些准备工作，是真正启动任务的方法。对于子类，不需要重写本方法
 */
- (void)main;

/*!
 * @brief 任务实现，在这里实现Task要实现的功能
 * @discussion 需要子类重新实现该方法以实现不同的任务功能
 */
- (void)run;

/*!
 * @brief 取消任务
 * @discussion 执行清理内部变量并修改运行状态为结束。在SPTask结束前必须执行本方法以彻底释放资源并调整运行状态
 * @discussion 子类若重写cancel方法需先调用父类cancel方法
 */
- (void)cancel;

/*!
 * @brief 消息通知
 * @discussion 内部调用notify:onThread:方法
 * @param notification 消息块
 * @see notify:onThread:
 */
- (void)notify:(void (^)(void))notification;

/*!
 * @brief 消息通知
 * @discussion 通知在指定线程发送
 * @param notification 消息块
 * @param thread 消息发送线程，若为nil，将直接执行消息块，否则将消息块放入指定线程的下一个runloop中执行
 */
- (void)notify:(void (^)(void))notification onThread:(NSThread *)thread;

@end
