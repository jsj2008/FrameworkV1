//
//  APPConfiguration.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "APPConfiguration.h"

@implementation APPConfiguration

+ (APPConfiguration *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    static APPConfiguration *instance = nil;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[APPConfiguration alloc] init];
        
        instance.daemonPoolCapacity = 5;
        
        instance.daemonPoolPersistentQueueCapacity = 2;
        
        instance.freePoolCapacity = 20;
        
        instance.backgroundPoolCapacity = 10;
        
        instance.defaultQueueLoadingLimit = 20;
    });
    
    return instance;
}

@end
