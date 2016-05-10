//
//  HTTPSession+SharedInstance.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPSession+SharedInstance.h"

@implementation HTTPSession (SharedInstance)

+ (HTTPSession *)sharedDefaultConfigurationInstance
{
    static HTTPSession *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            instance = [[HTTPSession alloc] initWithURLSessionConfiguration:configuration];
        }
    });
    
    return instance;
}

+ (HTTPSession *)sharedEphemeralSessionConfigurationInstance
{
    static HTTPSession *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            
            instance = [[HTTPSession alloc] initWithURLSessionConfiguration:configuration];
        }
    });
    
    return instance;
}

@end
