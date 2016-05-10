//
//  SPTaskFreePool+SharedInstance.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskFreePool+SharedInstance.h"

@implementation SPTaskFreePool (SharedInstance)

+ (SPTaskFreePool *)sharedInstance
{
    static SPTaskFreePool *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[SPTaskFreePool alloc] init];
        }
    });
    
    return instance;
}

@end
