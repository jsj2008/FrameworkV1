//
//  SPTaskFreePool+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SPTaskFreePool.h"

/*********************************************************
 
    @category
        SPTaskFreePool (SharedInstance)
 
    @abstract
        SPTaskFreePool的单例扩展
 
 *********************************************************/

@interface SPTaskFreePool (SharedInstance)

/*!
 * @brief 单例
 */
+ (SPTaskFreePool *)sharedInstance;

@end
