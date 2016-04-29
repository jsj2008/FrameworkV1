//
//  SPTaskBackgroundPool+SharedInstance.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskBackgroundPool+SharedInstance.h"

@implementation SPTaskBackgroundPool (SharedInstance)

+ (SPTaskBackgroundPool *)sharedInstance
{
    static SPTaskBackgroundPool *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[SPTaskBackgroundPool alloc] init];
        }
    });
    
    return instance;
}

@end
