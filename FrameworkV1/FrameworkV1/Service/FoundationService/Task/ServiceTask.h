//
//  ServiceTask.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "DispatchableTask.h"

/*********************************************************
 
    @class
        ServiceTask
 
    @abstract
        操作任务，具体任务的公共父类
 
    @discussion
        1，ServiceTask初始化时将对内部taskDispatcher使用默认的任务池（包括daemon，free，background类型的全局单例）初始化，并使用kServiceTaskDispatchedPoolIdentifier_XXX标识符标记
 
 *********************************************************/

@interface ServiceTask : DispatchableTask

/*!
 * @brief 用户字典，仅用于传递，内部不进行任何处理
 */
@property (nonatomic) NSDictionary *userInfo;

@end


/*********************************************************
 
    @const
        kServiceTaskDispatchedPoolIdentifier_XXX
 
    @abstract
        ServiceTask的任务调度器的任务池标识符
 
 *********************************************************/

// 守护任务池
extern NSString * const kServiceTaskDispatchedPoolIdentifier_Daemon;

// 默认任务池
extern NSString * const kServiceTaskDispatchedPoolIdentifier_Free;

// 后台任务池
extern NSString * const kServiceTaskDispatchedPoolIdentifier_Background;
