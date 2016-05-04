//
//  SPTaskBackgroundPool+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskBackgroundPool.h"

/*********************************************************
 
    @category
        SPTaskBackgroundPool (SharedInstance)
 
    @abstract
        SPTaskBackgroundPool的单例扩展
 
 *********************************************************/

@interface SPTaskBackgroundPool (SharedInstance)

/*!
 * @brief 单例
 */
+ (SPTaskBackgroundPool *)sharedInstance;

@end
