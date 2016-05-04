//
//  SPTaskDispatcher.m
//  Task
//
//  Created by Baymax on 13-10-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskDispatcher.h"
#import "SPTask.h"
#import "SPTaskDaemonPool.h"
#import "SPTaskFreePool.h"
#import "SPTaskBackgroundPool.h"

#pragma mark - SPTaskQueuedDispatchContext

@interface SPTaskQueuedDispatchContext ()

/*!
 * @brief task
 */
@property (nonatomic) SPTask *task;

/*!
 * @brief 任务池标识符
 */
@property (nonatomic, copy) NSString *poolIdentifier;

@end


@implementation SPTaskQueuedDispatchContext

@end


#pragma mark - SPTaskDependence

@implementation SPTaskDependence

@end


#pragma mark - SPTaskDispatcher

@interface SPTaskDispatcher ()
{
    // 异步执行的Task等待队列
    NSMutableArray *_asyncQueuedTaskContexts;
    
    // 异步执行的Task依赖关系
    NSMutableArray *_asyncTaskDependences;
}

/*!
 * @brief 运行等候队列中的任务
 */
- (void)runQueuedTasks;

/*!
 * @brief 异步任务是否准备就绪
 * @param task 异步任务
 * @result 依赖解除时返回YES，未解除时返回NO
 */
- (BOOL)isAsyncTaskPreparedToRun:(SPTask *)task;

@end


@implementation SPTaskDispatcher

- (id)init
{
    if (self = [super init])
    {
        _syncTasks = [[NSMutableArray alloc] init];
        
        _asyncTasks = [[NSMutableArray alloc] init];
        
        _asyncQueuedTaskContexts = [[NSMutableArray alloc] init];
        
        _asyncTaskDependences = [[NSMutableArray alloc] init];
        
        self.asyncTaskCapacity = 100;
    }
    
    return self;
}

- (void)setAsyncTaskCapacity:(NSUInteger)asyncTaskCapacity
{
    _asyncTaskCapacity = asyncTaskCapacity;
    
    if (_asyncTaskCapacity < 1)
    {
        _asyncTaskCapacity = 1;
    }
}

- (NSArray<SPTask *> *)allSyncTasks
{
    return [_syncTasks count] ? [NSArray arrayWithArray:_syncTasks] : nil;
}

- (NSArray<SPTask *> *)allAsyncTasks
{
    NSMutableArray *tasks = [NSMutableArray array];
    
    [tasks addObjectsFromArray:_asyncTasks];
    
    for (SPTaskQueuedDispatchContext *context in _asyncQueuedTaskContexts)
    {
        SPTask *task = context.task;
        
        if (task)
        {
            [tasks addObject:task];
        }
    }
    
    return [tasks count] ? tasks : nil;
}

- (NSUInteger)syncTaskLoads
{
    NSUInteger loads = 0;
    
    for (SPTask *task in _syncTasks)
    {
        loads += [task totalLoadSize];
    }
    
    return loads;
}

- (void)syncAddTask:(SPTask *)task
{
    [self syncAddTask:task onNextRunLoop:NO];
}

- (void)syncAddTask:(SPTask *)task onNextRunLoop:(BOOL)on
{
    if (task)
    {
        [_syncTasks addObject:task];
        
        if (on)
        {
            [task performSelector:@selector(main) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
        }
        else
        {
            [task main];
        }
    }
}

- (BOOL)asyncAddTask:(SPTask *)task inPool:(NSString *)poolIdentifier
{
    if (!task || !poolIdentifier)
    {
        return YES;
    }
    
    BOOL success = YES;
    
    if (!task.notifyThread)
    {
        task.notifyThread = [NSThread currentThread];
    }
    
    if ([_asyncTasks count] < self.asyncTaskCapacity && [self isAsyncTaskPreparedToRun:task])
    {
        success = [(SPTaskPool *)[self.pools objectForKey:poolIdentifier] addTasks:[NSArray arrayWithObject:task]];
        
        if (success)
        {
            [_asyncTasks addObject:task];
        }
    }
    else
    {
        SPTaskQueuedDispatchContext *context = [[SPTaskQueuedDispatchContext alloc] init];
        
        context.task = task;
        
        context.poolIdentifier = poolIdentifier;
        
        [_asyncQueuedTaskContexts addObject:context];
        
        success = YES;
    }
    
    return success;
}

- (void)addAsyncTaskDependence:(SPTaskDependence *)dependence
{
    BOOL dependenceExist = NO;
    
    for (SPTaskDependence *existingDependence in _asyncTaskDependences)
    {
        if (existingDependence.task == dependence.task)
        {
            [existingDependence.dependedOnTasks addObjectsFromArray:dependence.dependedOnTasks];
            
            dependenceExist = YES;
            
            break;
        }
    }
    
    if (!dependenceExist)
    {
        SPTaskDependence *newDependence = [[SPTaskDependence alloc] init];
        
        newDependence.task = dependence.task;
        
        newDependence.dependedOnTasks = [NSMutableArray arrayWithArray:dependence.dependedOnTasks];
        
        [_asyncTaskDependences addObject:newDependence];
    }
}

- (void)removeAsyncTaskDependence:(SPTaskDependence *)dependence
{
    NSMutableArray *toRemoveDependences = [NSMutableArray array];
    
    for (SPTaskDependence *selfDependence in _asyncTaskDependences)
    {
        if (dependence.task == selfDependence.task)
        {
            [selfDependence.dependedOnTasks removeObjectsInArray:dependence.dependedOnTasks];
            
            if (![selfDependence.dependedOnTasks count])
            {
                [toRemoveDependences addObject:selfDependence];
            }
        }
    }
    
    [_asyncTaskDependences removeObjectsInArray:toRemoveDependences];
}

- (void)removeAsyncTaskDependenceOfTask:(SPTask *)task
{
    NSMutableArray *toRemoveDependences = [NSMutableArray array];
    
    for (SPTaskDependence *dependence in _asyncTaskDependences)
    {
        if (dependence.task == task)
        {
            [toRemoveDependences addObject:dependence];
        }
    }
    
    [_asyncTaskDependences removeObjectsInArray:toRemoveDependences];
}

- (void)removeTask:(SPTask *)task
{
    if (task)
    {
        if ([_syncTasks containsObject:task])
        {
            task.delegate = nil;
            
            [_syncTasks removeObject:task];
        }
        else if ([_asyncTasks containsObject:task])
        {
            task.delegate = nil;
            
            [_asyncTasks removeObject:task];
            
            if ([_asyncTaskDependences count])
            {
                NSMutableArray *toRemoveDependences = [NSMutableArray array];
                
                for (SPTaskDependence *dependence in _asyncTaskDependences)
                {
                    if (dependence.task == task)
                    {
                        [toRemoveDependences addObject:dependence];
                    }
                    
                    [dependence.dependedOnTasks removeObject:task];
                    
                    if ([dependence.dependedOnTasks count] == 0)
                    {
                        [toRemoveDependences addObject:dependence];
                    }
                }
                
                [_asyncTaskDependences removeObjectsInArray:toRemoveDependences];
            }
            
            [self runQueuedTasks];
        }
    }
}

- (void)cancel
{
    for (SPTask *task in _syncTasks)
    {
        task.delegate = nil;
        
        [task cancel];
    }
    
    [_syncTasks removeAllObjects];
    
    for (SPTask *task in _asyncTasks)
    {
        task.delegate = nil;
        
        // 对于异步任务，这里设置结束标记非常重要，可以帮助task尽快从taskqueue中移除（若未设置结束标记，cancel操作将被放在taskqueue线程中所有未执行的selector之后执行）
        // 若不设置此标记，存在漏洞：在task还未在taskqueue中run之前执行cancel操作，cancel操作将无效
        task.runStatus = SPTaskRunStatus_Finish;
        
        if ([[task runningThread] isExecuting])
        {
            [task performSelector:@selector(cancel) onThread:[task runningThread] withObject:nil waitUntilDone:NO];
        }
    }
    
    [_asyncTasks removeAllObjects];
    
    [_asyncQueuedTaskContexts removeAllObjects];
    
    [_asyncTaskDependences removeAllObjects];
}

- (void)cancelTask:(SPTask *)task
{
    if ([_syncTasks containsObject:task])
    {
        task.delegate = nil;
        
        [task cancel];
    }
    
    if ([_asyncTasks containsObject:task])
    {
        task.delegate = nil;
        
        // 对于异步任务，这里设置结束标记非常重要，可以帮助task尽快从taskqueue中移除（若未设置结束标记，cancel操作将被放在taskqueue线程中所有未执行的selector之后执行）
        // 若不设置此标记，存在漏洞：在task还未在taskqueue中run之前执行cancel操作，cancel操作将无效
        task.runStatus = SPTaskRunStatus_Finish;
        
        if ([[task runningThread] isExecuting])
        {
            [task performSelector:@selector(cancel) onThread:[task runningThread] withObject:nil waitUntilDone:NO];
        }
    }
    
    [self removeTask:task];
}

- (void)runQueuedTasks
{
    if (([_asyncQueuedTaskContexts count] && [_asyncTasks count] < self.asyncTaskCapacity))
    {
        NSMutableArray *toRemoveContexts = [NSMutableArray array];
        
        for (SPTaskQueuedDispatchContext *context in _asyncQueuedTaskContexts)
        {
            SPTask *task = context.task;
            
            if ([self isAsyncTaskPreparedToRun:task])
            {
                [self asyncAddTask:task inPool:context.poolIdentifier];
                
                [toRemoveContexts addObject:context];
            }
            
            if ([_asyncTasks count] >= self.asyncTaskCapacity)
            {
                break;
            }
        }
        
        [_asyncQueuedTaskContexts removeObjectsInArray:toRemoveContexts];
    }
}

- (BOOL)isAsyncTaskPreparedToRun:(SPTask *)task
{
    BOOL prepared = YES;
    
    for (SPTaskDependence *dependence in _asyncTaskDependences)
    {
        if (dependence.task == task)
        {
            prepared = NO;
            
            break;
        }
    }
    
    return prepared;
}

@end


NSString * const kTaskDispatcherPoolIdentifier_Daemon = @"daemon";

NSString * const kTaskDispatcherPoolIdentifier_Free = @"free";

NSString * const kTaskDispatcherPoolIdentifier_Background= @"background";
