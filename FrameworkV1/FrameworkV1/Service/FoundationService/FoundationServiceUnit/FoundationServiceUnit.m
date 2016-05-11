//
//  FoundationServiceUnit.m
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FoundationServiceUnit.h"
#import "NSObject+ThreadOperation.h"

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
    // 初始化Libxml
    xmlInitParser();
    
    // 日志系统
    [APPLog sharedInstance].defaultLevel = APPLogLevel_High;
    
    [APPLog sharedInstance].logFileDirectory = [APPConfiguration sharedInstance].appLogDirectory;
    
    [[APPLog sharedInstance] start];
    
    // 轻载常驻队列
    [[LightLoadingPermanentQueue sharedInstance] start];
    
    // 数据库
    [DBLog sharedInstance].customLogOperation = ^(NSString *logString){
        
        [[APPLog sharedInstance] logString:logString onLevel:APPLogLevel_High];
    };
    
    [[DBLog sharedInstance] openLog];
    
    // Task
    [SPTaskDaemonPool sharedInstance].poolCapacity = [APPConfiguration sharedInstance].daemonPoolCapacity;
    
    [SPTaskDaemonPool sharedInstance].taskQueueLoadsLimit = [APPConfiguration sharedInstance].defaultQueueLoadingLimit;
    
    [SPTaskFreePool sharedInstance].poolCapacity = [APPConfiguration sharedInstance].freePoolCapacity;
    
    [SPTaskFreePool sharedInstance].taskQueueLoadsLimit = [APPConfiguration sharedInstance].defaultQueueLoadingLimit;
    
    [SPTaskBackgroundPool sharedInstance].poolCapacity = [APPConfiguration sharedInstance].backgroundPoolCapacity;
    
    [SPTaskBackgroundPool sharedInstance].taskQueueLoadsLimit = [APPConfiguration sharedInstance].defaultQueueLoadingLimit;
    
    [[SPTaskDaemonPool sharedInstance] startWithPersistentQueueCount:[APPConfiguration sharedInstance].daemonPoolPersistentQueueCapacity];
    
    [[SPTaskFreePool sharedInstance] start];
    
    [[SPTaskBackgroundPool sharedInstance] start];
    
    // HTTP cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        // 网络状态
        [[NetworkManager sharedInstance] start];;
    }];
}

- (void)stop
{
    NSThread *thread = [NSThread currentThread];
    
    [[SPTaskDaemonPool sharedInstance] stop];
    
    [[SPTaskFreePool sharedInstance] stop];
    
    [[SPTaskBackgroundPool sharedInstance] stop];
    
    [[DBLog sharedInstance] closeLog];
    
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        [[NetworkManager sharedInstance] stop];
        
        [self operate:^{
            
            [[LightLoadingPermanentQueue sharedInstance] stop];
            
            [[APPLog sharedInstance] stop];
            
        } onThread:thread];
    }];
}

@end
