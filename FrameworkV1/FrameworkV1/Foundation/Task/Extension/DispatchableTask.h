//
//  DispatchableTask.h
//  Demo
//
//  Created by Baymax on 13-10-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTask.h"
#import "SPTaskDispatcher.h"

/*********************************************************
 
    @class
        DispatchableTask
 
    @abstract
        基础Task，扩展了账户和用户字典属性
 
    @discussion
        1、DispatchableTask支持任务嵌套，即支持执行子任务，通过taskDispatcher属性管理子任务
        2，DispatchableTask初始化时将生成一个原始的taskDispatcher，子类需自行配制taskDispatcher才能使之正确工作
        3，DispatchableTask的总负载包括自身负载和同步子任务
 
 *********************************************************/

@interface DispatchableTask : SPTask

/*!
 * @brief 子任务派发器，管理和调度子任务
 */
@property (nonatomic, readonly) SPTaskDispatcher *taskDispatcher;

@end
