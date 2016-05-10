//
//  ServiceTask.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "ServiceTask.h"
#import "SPTaskDaemonPool+SharedInstance.h"
#import "SPTaskFreePool+SharedInstance.h"
#import "SPTaskBackgroundPool+SharedInstance.h"

@implementation ServiceTask

- (instancetype)init
{
    if (self = [super init])
    {
        self.taskDispatcher.pools = [[NSDictionary alloc] initWithObjectsAndKeys:[SPTaskDaemonPool sharedInstance], kServiceTaskDispatchedPoolIdentifier_Daemon, [SPTaskFreePool sharedInstance], kServiceTaskDispatchedPoolIdentifier_Free, [SPTaskBackgroundPool sharedInstance], kServiceTaskDispatchedPoolIdentifier_Background, nil];
    }
    
    return self;
}

@end


NSString * const kServiceTaskDispatchedPoolIdentifier_Daemon = @"daemon";

NSString * const kServiceTaskDispatchedPoolIdentifier_Free = @"free";

NSString * const kServiceTaskDispatchedPoolIdentifier_Background = @"background";
