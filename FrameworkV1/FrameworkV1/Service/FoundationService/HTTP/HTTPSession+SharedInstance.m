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
            
            configuration.URLCache = [NSURLCache sharedURLCache];
            
            configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
            
            configuration.HTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
            
            configuration.HTTPShouldSetCookies = YES;
            
            configuration.URLCredentialStorage = [NSURLCredentialStorage sharedCredentialStorage];
            
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
