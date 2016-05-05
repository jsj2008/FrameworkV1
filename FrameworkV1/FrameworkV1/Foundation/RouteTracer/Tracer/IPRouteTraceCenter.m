//
//  IPRouteTraceCenter.m
//  PRIS_iPhone
//
//  Created by WW on 13-8-14.
//
//

#import "IPRouteTraceCenter.h"
#import "IPRouteTracer.h"
#import "SPTaskFreePool.h"

/*!
 * @brief 追踪上下文的键
 */
static NSString * const IPRouteTracingContextKey_Tracer = @"tracer";

/*!
 * @brief 追踪上下文的键
 */
static NSString * const IPRouteTracingContextKey_Observer = @"observer";

/*!
 * @brief 追踪上下文的键
 */
static NSString * const IPRouteTracingContextKey_Host = @"host";

/*!
 * @brief 追踪上下文的键
 */
static NSString * const IPRouteTracingFreePoolIdentifer = @"free";


@interface IPRouteTraceCenter ()
{
    // 同步队列
    dispatch_queue_t _syncQueue;
    
    // 停止标志
    BOOL _stop;
}

@property (nonatomic) NSMutableDictionary *tracers;

@end


@implementation IPRouteTraceCenter

- (id)init
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create(NULL, NULL);
    }
    
    return self;
}

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

+ (IPRouteTraceCenter *)sharedInstance
{
    static IPRouteTraceCenter *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[IPRouteTraceCenter alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    _stop = NO;
}

- (void)stop
{
    _stop = YES;
    
    for (IPRouteTracer *tracer in [self.tracers allValues])
    {
        [tracer cancel];
    }
}

- (BOOL)traceHost:(NSString *)host withObserver:(id<IPRouteTraceObserveDelegate>)observer
{
    if (_stop || !host)
    {
        return NO;
    }
    
    __weak typeof(observer) weakObserver = observer;
    
    dispatch_sync(_syncQueue, ^{
        
        if (![self.tracers objectForKey:host])
        {
            IPRouteTracer *tracer = [[IPRouteTracer alloc] initWithDestinationHost:host];
            
            [self.tracers setObject:tracer forKey:host];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [tracer run];
                
                if (weakObserver && [weakObserver respondsToSelector:@selector(IPRouteTrace_Host:didTraceWithRoutes:)])
                {
                    [weakObserver IPRouteTrace_Host:host didTraceWithRoutes:tracer.routeItems];
                }
            });
        }
    });
    
    return YES;
}

@end
