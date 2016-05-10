//
//  IPRouteTraceHandle.m
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "IPRouteTraceHandle.h"
#import "IPRouteTraceCenter.h"
#import "IPRouteTraceObserveDelegate.h"

@interface IPRouteTraceHandle () <IPRouteTraceObserveDelegate>

@end


@implementation IPRouteTraceHandle

- (BOOL)traceHost:(NSString *)host
{
    return [[IPRouteTraceCenter sharedInstance] traceHost:host withObserver:self];
}

- (void)IPRouteTrace_Host:(NSString *)ip didTraceWithRoutes:(NSArray *)routes
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(IPRouteTraceHandle:didTraceWithIPRoutes:)])
    {
        [self.delegate IPRouteTraceHandle:self didTraceWithIPRoutes:routes];
    }
}

@end
