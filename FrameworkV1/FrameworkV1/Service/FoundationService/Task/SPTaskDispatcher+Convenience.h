//
//  SPTaskDispatcher+Convenience.h
//  FrameworkV1
//
//  Created by ww on 16/5/3.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskDispatcher.h"

/*********************************************************
 
    @category
        SPTaskDispatcher (Convenience)
 
    @abstract
        SPTaskDispatcher快捷方式扩展
 
 *********************************************************/

@interface SPTaskDispatcher (Convenience)

/*!
 * @brief 使用默认池配置的调度器
 */
+ (SPTaskDispatcher *)taskDispatcherWithSharedPools;

@end





/*********************************************************
 
    @const
        kTaskDispatcherPoolIdentifier_XXX
 
    @abstract
        不同任务池的标识符
 
 *********************************************************/

// 守护任务池标识符
extern NSString * const kTaskDispatcherPoolIdentifier_Daemon;

// 自由任务池标识符
extern NSString * const kTaskDispatcherPoolIdentifier_Free;

// 后台任务池标识符
extern NSString * const kTaskDispatcherPoolIdentifier_Background;
