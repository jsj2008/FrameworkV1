//
//  APPConfiguration.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        APPConfiguration
 
    @abstract
        APP配置
 
 *********************************************************/

@interface APPConfiguration : NSObject

/*!
 * @brief 单例
 * @result APPConfiguration全局对象
 */
+ (APPConfiguration *)sharedInstance;

@end
