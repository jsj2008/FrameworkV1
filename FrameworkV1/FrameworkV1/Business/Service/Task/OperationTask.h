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
        1，OperationTask初始化时将对内部taskDispatcher使用默认的任务池初始化
 
 *********************************************************/

@interface OperationTask : FoundationTask

@end
