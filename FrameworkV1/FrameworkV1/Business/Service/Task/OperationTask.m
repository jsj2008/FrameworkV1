//
//  OperationTask.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "OperationTask.h"
#import "SPTaskDaemonPool+SharedInstance.h"
#import "SPTaskFreePool+SharedInstance.h"
#import "SPTaskBackgroundPool+SharedInstance.h"

@implementation OperationTask

- (instancetype)init
{
    if (self = [super init])
    {
        self.taskDispatcher.daemonPool = [SPTaskDaemonPool SharedInstance];
        
        self.taskDispatcher.freePool = [SPTaskFreePool SharedInstance];
        
        self.taskDispatcher.backgroundPool = [SPTaskBackgroundPool SharedInstance];
    }
    
    return self;
}

@end