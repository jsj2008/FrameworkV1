//
//  FoundationServiceUnit.m
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FoundationServiceUnit.h"
#import "NSObject+Notify.h"

#import <libxml2/libxml/tree.h>

#import "APPConfiguration.h"

#import "APPLog+SharedInstance.h"

#import "NetworkManager.h"

#import "DBLog.h"

#import "LightLoadingPermanentQueue+SharedInstance.h"

#import "SPTaskDaemonPool+SharedInstance.h"
#import "SPTaskFreePool+SharedInstance.h"
#import "SPTaskBackgroundPool+SharedInstance.h"

@implementation FoundationServiceUnit

+ (FoundationServiceUnit *)sharedInstance
{
    static FoundationServiceUnit *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[FoundationServiceUnit alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    if (!self.notifyThread)
    {
        self.notifyThread = [NSThread currentThread];
    }
    
    // 初始化Libxml
    xmlInitParser();
    
    // 日志系统
    [APPLog sharedInstance].defaultLevel = APPLogLevel_High;
    
    [APPLog sharedInstance].logFileDirectory = [APPConfiguration sharedInstance].appLogDirectory;
    
    [[APPLog sharedInstance] start];
    
    // 轻载常驻队列
    [LightLoadingPermanentQueue sharedInstance].delegate = self;
    
    [LightLoadingPermanentQueue sharedInstance].notifyThread = self.notifyThread;
    
    [[LightLoadingPermanentQueue sharedInstance] start];
}

- (void)lightLoadingPermanentQueueDidStart:(LightLoadingPermanentQueue *)queue
{
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        [DBLog sharedInstance].customLogOperation = ^(NSString *logString){
            
            [[APPLog sharedInstance] logString:logString onLevel:APPLogLevel_High];
        };
        
        // 网络状态
        [[NetworkManager sharedInstance] start];
        
        // Task配置
        [SPTaskDaemonPool sharedInstance].poolCapacity = [APPConfiguration sharedInstance].daemonPoolCapacity;
        
        [SPTaskDaemonPool sharedInstance].taskQueueLoadsLimit = [APPConfiguration sharedInstance].defaultQueueLoadingLimit;
        
        [SPTaskFreePool sharedInstance].poolCapacity = [APPConfiguration sharedInstance].freePoolCapacity;
        
        [SPTaskFreePool sharedInstance].taskQueueLoadsLimit = [APPConfiguration sharedInstance].defaultQueueLoadingLimit;
        
        [SPTaskBackgroundPool sharedInstance].poolCapacity = [APPConfiguration sharedInstance].backgroundPoolCapacity;
        
        [SPTaskBackgroundPool sharedInstance].taskQueueLoadsLimit = [APPConfiguration sharedInstance].defaultQueueLoadingLimit;
        
        [[SPTaskDaemonPool sharedInstance] startWithPersistentQueueCount:[APPConfiguration sharedInstance].daemonPoolPersistentQueueCapacity];
        
        [[SPTaskFreePool sharedInstance] start];
        
        [[SPTaskBackgroundPool sharedInstance] start];
        
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(foundationServiceUnit:isStartingWithProgress:)])
            {
                [self.delegate foundationServiceUnit:self isStartingWithProgress:1.0];
            }
        } onThread:self.notifyThread];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(foundationServiceUnit:didStartSuccessfully:)])
            {
                [self.delegate foundationServiceUnit:self didStartSuccessfully:YES];
            }
        } onThread:self.notifyThread];
    }];
}

- (void)stop
{
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        [[SPTaskDaemonPool sharedInstance] stop];
        
        [[SPTaskFreePool sharedInstance] stop];
        
        [[SPTaskBackgroundPool sharedInstance] stop];
        
        [[NetworkManager sharedInstance] stop];
    }];
        
    [[LightLoadingPermanentQueue sharedInstance] stop];
}

- (void)lightLoadingPermanentQueueDidStop:(LightLoadingPermanentQueue *)queue
{
    [[APPLog sharedInstance] stop];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(foundationServiceUnit:isStopingWithProgress:)])
        {
            [self.delegate foundationServiceUnit:self isStopingWithProgress:1.0];
        }
    } onThread:self.notifyThread];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(foundationServiceUnit:didStopSuccessfully:)])
        {
            [self.delegate foundationServiceUnit:self didStopSuccessfully:YES];
        }
    } onThread:self.notifyThread];
    
    self.notifyThread = nil;
}

@end
