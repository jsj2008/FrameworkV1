//
//  Task.m
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTask.h"

@interface SPTask ()

/*!
 * @brief 运行线程
 */
@property (nonatomic) NSThread *mainThread;

/*!
 * @brief 执行消息操作
 * @param notification 消息块
 */
- (void)notify:(void (^)(void))notification;

@end


@implementation SPTask

- (id)init
{
    if (self = [super init])
    {
        self.loadSize = 0;
        
        self.runStatus = SPTaskRunStatus_Prepare;
    }
    
    return self;
}

- (NSThread *)runningThread
{
    return self.mainThread;
}

- (NSUInteger)totalLoadSize
{
    return self.loadSize;
}

- (void)main
{
    self.runStatus = SPTaskRunStatus_Running;
    
    self.mainThread = [NSThread currentThread];
    
    [self run];
}

- (void)run
{
    
}

- (void)cancel
{
    self.runStatus = SPTaskRunStatus_Finish;
}

- (void)notify:(void (^)(void))notification onThread:(NSThread *)thread
{
    [self performSelector:@selector(notify:) onThread:thread ? thread : [NSThread currentThread] withObject:notification waitUntilDone:NO];
}

- (void)notify:(void (^)(void))notification
{
    if (notification)
    {
        notification();
    }
}

@end
