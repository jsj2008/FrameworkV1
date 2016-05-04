//
//  SPTaskDaemonPool+SharedInstance.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskDaemonPool+SharedInstance.h"

@implementation SPTaskDaemonPool (SharedInstance)

+ (SPTaskDaemonPool *)sharedInstance
{
    static SPTaskDaemonPool *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[SPTaskDaemonPool alloc] init];
        }
    });
    
    return instance;
}

@end
