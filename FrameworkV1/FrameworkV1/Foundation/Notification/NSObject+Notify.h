//
//  NSObject+Notify.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @category
        NSObject (Notify)
 
    @abstract
        NSObject的通知扩展，用于发送block通知
 
 **********************************************************/

@interface NSObject (Notify)

/*!
 * @brief 跨线程block通知
 * @param notification 通知块
 * @param thread 通知线程
 */
- (void)notify:(void (^)(void))notification onThread:(NSThread *)thread;

/*!
 * @brief block操作
 * @param operation 操作块
 */
- (void)operateNotifyOperation:(void (^)(void))operation;

@end
