//
//  StorageUnit.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "StorageUnit.h"
#import "LightLoadingPermanentQueue+SharedInstance.h"
#import "NSObject+Notify.h"
#import "ImageStorage.h"

@implementation StorageUnit

+ (StorageUnit *)sharedInstance
{
    static StorageUnit *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[StorageUnit alloc] init];
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
    
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        [[ImageStorage sharedInstance] start];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(storageUnit:isStartingWithProgress:)])
            {
                [self.delegate storageUnit:self isStartingWithProgress:1.0];
            }
        } onThread:self.notifyThread];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(storageUnit:didStartSuccessfully:)])
            {
                [self.delegate storageUnit:self didStartSuccessfully:YES];
            }
        } onThread:self.notifyThread];
    }];
}

- (void)stop
{
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        [[ImageStorage sharedInstance] stop];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(storageUnit:isStopingWithProgress:)])
            {
                [self.delegate storageUnit:self isStopingWithProgress:1.0];
            }
        } onThread:self.notifyThread];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(storageUnit:didStopSuccessfully:)])
            {
                [self.delegate storageUnit:self didStopSuccessfully:YES];
            }
        } onThread:self.notifyThread];
    }];
}

@end
