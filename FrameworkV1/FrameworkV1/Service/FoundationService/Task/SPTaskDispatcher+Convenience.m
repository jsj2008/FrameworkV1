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

NSString * const kTaskDispatcherPoolIdentifier_Daemon = @"daemon";

NSString * const kTaskDispatcherPoolIdentifier_Free = @"free";

NSString * const kTaskDispatcherPoolIdentifier_Background= @"background";


@implementation SPTaskDispatcher (Convenience)

+ (SPTaskDispatcher *)taskDispatcherWithSharedPools
{
    SPTaskDispatcher *dispatcher = [[SPTaskDispatcher alloc] init];
    
    dispatcher.pools = [[NSDictionary alloc] initWithObjectsAndKeys:[SPTaskDaemonPool sharedInstance], kTaskDispatcherPoolIdentifier_Daemon, [SPTaskFreePool sharedInstance], kTaskDispatcherPoolIdentifier_Free, [SPTaskBackgroundPool sharedInstance], kTaskDispatcherPoolIdentifier_Background, nil];
    
    return dispatcher;
}

@end
