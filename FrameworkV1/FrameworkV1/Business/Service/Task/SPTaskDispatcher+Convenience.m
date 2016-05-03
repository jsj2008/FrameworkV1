//
//  SPTaskDispatcher+Convenience.m
//  FrameworkV1
//
//  Created by ww on 16/5/3.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskDispatcher+Convenience.h"
#import "SPTaskDaemonPool+SharedInstance.h"
#import "SPTaskFreePool+SharedInstance.h"
#import "SPTaskBackgroundPool+SharedInstance.h"

@implementation SPTaskDispatcher (Convenience)

+ (SPTaskDispatcher *)taskDispatcherWithSharedPools
{
    SPTaskDispatcher *dispatcher = [[SPTaskDispatcher alloc] init];
    
    dispatcher.daemonPool = [SPTaskDaemonPool sharedInstance];
    
    dispatcher.freePool = [SPTaskFreePool sharedInstance];
    
    dispatcher.backgroundPool = [SPTaskBackgroundPool sharedInstance];
    
    return dispatcher;
}

@end
