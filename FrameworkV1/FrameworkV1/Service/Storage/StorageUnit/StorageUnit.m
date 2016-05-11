//
//  StorageUnit.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "StorageUnit.h"
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
    [[ImageStorage sharedInstance] start];
}

- (void)stop
{
    [[ImageStorage sharedInstance] stop];
}

@end
