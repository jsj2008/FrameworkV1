//
//  NSObject+Notify.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSObject+Notify.h"

@implementation NSObject (Notify)

- (void)notify:(void (^)(void))notification onThread:(NSThread *)thread
{
    if (thread && [thread isExecuting])
    {
        [self performSelector:@selector(operateNotifyOperation:) onThread:thread withObject:notification waitUntilDone:NO];
    }
    else
    {
        if (notification)
        {
            notification();
        }
    }
}

- (void)operateNotifyOperation:(void (^)(void))operation
{
    if (operation)
    {
        operation();
    }
}

@end
