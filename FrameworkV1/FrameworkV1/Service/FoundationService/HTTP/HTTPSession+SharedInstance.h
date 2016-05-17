//
//  HTTPSession+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPSession.h"

/*********************************************************
 
    @category
        HTTPSession (SharedInstance)
 
    @abstract
        HTTPSession的单例扩展
 
 *********************************************************/

@interface HTTPSession (SharedInstance)

/*!
 * @brief 默认配置的单例
 * @discussion 使用系统默认的URLCache，CookiStorage，CredentialStorage
 */
+ (HTTPSession *)sharedDefaultConfigurationInstance;

/*!
 * @brief 瞬时配置的单例
 */
+ (HTTPSession *)sharedEphemeralSessionConfigurationInstance;

@end
