//
//  LightLoadingPermanentQueue+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "LightLoadingPermanentQueue.h"

@interface LightLoadingPermanentQueue (SharedInstance)

/*!
 * @brief 单例
 */
+ (LightLoadingPermanentQueue *)sharedInstance;

@end
