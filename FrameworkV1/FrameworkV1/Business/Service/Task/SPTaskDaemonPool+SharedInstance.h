//
//  SPTaskDaemonPool+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskDaemonPool.h"

/*********************************************************
 
    @category
        SPTaskDaemonPool (SharedInstance)
 
    @abstract
        SPTaskDaemonPool的单例扩展
 
 *********************************************************/

@interface SPTaskDaemonPool (SharedInstance)

/*!
 * @brief 单例
 */
+ (SPTaskDaemonPool *)sharedInstance;

@end
