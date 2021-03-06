//
//  DispatchableTask.m
//  Demo
//
//  Created by Baymax on 13-10-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "DispatchableTask.h"

@interface DispatchableTask ()
{
    SPTaskDispatcher *_taskDispatcher;
}

@end


@implementation DispatchableTask

@synthesize taskDispatcher = _taskDispatcher;

- (instancetype)init
{
    if (self = [super init])
    {
        _taskDispatcher = [[SPTaskDispatcher alloc] init];
    }
    
    return self;
}

- (NSUInteger)totalLoadSize
{
    return (self.loadSize + [_taskDispatcher syncTaskLoads]);
}

- (void)cancel
{
    [super cancel];
    
    [_taskDispatcher cancel];
    
    _taskDispatcher = nil;
}

@end
