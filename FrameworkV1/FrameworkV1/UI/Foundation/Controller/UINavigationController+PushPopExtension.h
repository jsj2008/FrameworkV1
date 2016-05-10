//
//  UINavigationController+PushPopExtension.h
//  FrameworkV1
//
//  Created by ww on 16/5/6.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @category
        UINavigationController (PushPopExtension)
 
    @abstract
        UINavigationController的push和pop扩展
 
 *********************************************************/

@interface UINavigationController (PushPopExtension)

/*!
 * @brief pop到新的controller栈顶，并push controller
 * @discussion 当新的栈顶controller不存在于原栈时，直接push controller
 * @param viewController 待push的controller
 * @param newTopViewController 新的栈顶controller
 * @param animated 是否需要跳转动画
 */
- (void)pushViewController:(UIViewController *)viewController onNewTopViewController:(UIViewController *)newTopViewController animated:(BOOL)animated;

@end
