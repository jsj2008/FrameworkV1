//
//  ServiceUnit.m
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "ServiceUnit.h"
#import "NSObject+Notify.h"

#import <libxml2/libxml/tree.h>

#import "APPConfiguration.h"

#import "APPLog+SharedInstance.h"

#import "NetworkManager.h"

#import "SPTaskConfiguration.h"
#import "SPTaskServiceProvider.h"

#import "DBLog.h"

#import "LightLoadingPermanentQueue+SharedInstance.h"

@implementation ServiceUnit

+ (ServiceUnit *)sharedInstance
{
    static ServiceUnit *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[ServiceUnit alloc] init];
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
        [SPTaskConfiguration sharedInstance].daemonPoolCapacity = [APPConfiguration sharedInstance].daemonPoolCapacity;
        
        [SPTaskConfiguration sharedInstance].freePoolCapacity = [APPConfiguration sharedInstance].freePoolCapacity;
        
        [SPTaskConfiguration sharedInstance].backgroundPoolCapacity = [APPConfiguration sharedInstance].backgroundPoolCapacity;
        
        [SPTaskConfiguration sharedInstance].defaultQueueLoadingLimit = [APPConfiguration sharedInstance].defaultQueueLoadingLimit;
        
        [[SPTaskServiceProvider sharedInstance] start];
        
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:isStartingWithProgress:)])
            {
                [self.delegate serviceUnit:self isStartingWithProgress:1.0];
            }
        } onThread:self.notifyThread];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:didStartSuccessfully:)])
            {
                [self.delegate serviceUnit:self didStartSuccessfully:YES];
            }
        } onThread:self.notifyThread];
    }];
}

- (void)stop
{
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        [[SPTaskServiceProvider sharedInstance] stop];
        
        [[NetworkManager sharedInstance] stop];
    }];
        
    [[LightLoadingPermanentQueue sharedInstance] stop];
}

- (void)lightLoadingPermanentQueueDidStop:(LightLoadingPermanentQueue *)queue
{
    [[APPLog sharedInstance] stop];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:isStopingWithProgress:)])
        {
            [self.delegate serviceUnit:self isStopingWithProgress:1.0];
        }
    } onThread:self.notifyThread];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:didStopSuccessfully:)])
        {
            [self.delegate serviceUnit:self didStopSuccessfully:YES];
        }
    } onThread:self.notifyThread];
    
    self.notifyThread = nil;
}

@end
