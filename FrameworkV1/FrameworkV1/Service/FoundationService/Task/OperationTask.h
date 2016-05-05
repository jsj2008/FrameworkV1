//
//  OperationTask.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "FoundationTask.h"

/*********************************************************
 
    @class
        OperationTask
 
    @abstract
        操作任务，具体任务的公共父类
 
    @discussion
        1，OperationTask初始化时将对内部taskDispatcher使用默认的任务池（包括daemon，free，background类型的全局单例）初始化，并使用kTaskDispatchedPoolIdentifier_XXX标识符标记
 
 *********************************************************/

@interface OperationTask : FoundationTask

@end


/*********************************************************
 
    @const
        kOperationTaskDispatchedPoolIdentifier_XXX
 
    @abstract
        OperationTask的任务调度器的任务池标识符
 
 *********************************************************/

extern NSString * const kOperationTaskDispatchedPoolIdentifier_Daemon;

extern NSString * const kOperationTaskDispatchedPoolIdentifier_Free;

extern NSString * const kOperationTaskDispatchedPoolIdentifier_Background;
