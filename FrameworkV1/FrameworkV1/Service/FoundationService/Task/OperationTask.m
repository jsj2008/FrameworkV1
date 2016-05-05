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
        self.taskDispatcher.pools = [[NSDictionary alloc] initWithObjectsAndKeys:[SPTaskDaemonPool sharedInstance], kOperationTaskDispatchedPoolIdentifier_Daemon, [SPTaskFreePool sharedInstance], kOperationTaskDispatchedPoolIdentifier_Free, [SPTaskBackgroundPool sharedInstance], kOperationTaskDispatchedPoolIdentifier_Background, nil];
    }
    
    return self;
}

@end


NSString * const kOperationTaskDispatchedPoolIdentifier_Daemon = @"daemon";

NSString * const kOperationTaskDispatchedPoolIdentifier_Free = @"free";

NSString * const kOperationTaskDispatchedPoolIdentifier_Background = @"background";
