//
//  SPTaskFreePool.m
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskFreePool.h"

@implementation SPTaskFreePool

- (void)start
{
    _stop = NO;
}

- (BOOL)addTasks:(NSArray<SPTask *> *)tasks
{
    if (_stop)
    {
        return NO;
    }
    
    __block BOOL success = NO;
    
    dispatch_sync(_syncQueue, ^{
        
        // 队列未满，创建新队列添加task
        if ([_taskQueues count] < self.poolCapacity)
        {
            SPTaskQueue *queue = [[SPTaskQueue alloc] init];
            
            queue.loadsLimit = self.taskQueueLoadsLimit;
            
            queue.owner = self;
            
            success = [queue addTasks:tasks];
            
            [_taskQueues addObject:queue];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSThread *thread = [NSThread currentThread];
                
                [thread.threadDictionary setObject:SPTaskFreePoolThreadIdentifier forKey:SPTaskPoolThreadDictionaryKey_Identifier];
                
                [queue run];
            });
        }
        // 队列已满，强行在负荷最低的队列中添加task
        else
        {
            NSArray *sortedQueues = [_taskQueues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                SPTaskQueue *queue1 = obj1;
                SPTaskQueue *queue2 = obj2;
                
                if ([queue1 loads] < [queue2 loads])
                {
                    return NSOrderedAscending;
                }
                else if ([queue1 loads] > [queue2 loads])
                {
                    return NSOrderedDescending;
                }
                else
                {
                    return NSOrderedSame;
                }
            }];
            
            for (SPTaskQueue *queue in sortedQueues)
            {
                if ((success = [queue addTasks:tasks]))
                {
                    break;
                }
            }
            
            // 一般来说，到本步仍无法添加成功的，是因为所有的队列正在执行结束工作，此时可以创建新队列添加task，即使超过队列容量，队列容量也会很快恢复
            if (!success)
            {
                SPTaskQueue *queue = [[SPTaskQueue alloc] init];
                
                queue.loadsLimit = self.taskQueueLoadsLimit;
                
                queue.owner = self;
                
                success = [queue addTasks:tasks];
                
                [_taskQueues addObject:queue];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSThread *thread = [NSThread currentThread];
                    
                    [thread.threadDictionary setObject:SPTaskFreePoolThreadIdentifier forKey:SPTaskPoolThreadDictionaryKey_Identifier];
                    
                    [queue run];
                });
            }
        }
    });
    
    return success;
}

@end


NSString * const SPTaskFreePoolThreadIdentifier = @"free_pool";
