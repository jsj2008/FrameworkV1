//
//  UFSceneDirector.h
//  MarryYou
//
//  Created by ww on 15/11/12.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFSceneDirector
 
    @abstract
        场景导演，管理特定的页面和逻辑组成的UI业务场景，调度controller间的跳转
 
    @discussion
        场景内部使用UINavigationController管理controller的跳转
 
 *********************************************************/

@interface UFSceneDirector : NSObject

/*!
 * @brief 初始化场景导演
 * @param navigationController 页面导航
 * @result 场景导演
 */
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

/*!
 * @brief 内部页面导航
 */
@property (nonatomic, readonly) UINavigationController *navigationController;

/*!
 * @brief 内部页面导航的起始锚点controller
 * @discussion 场景内部将本controller设置为导航栈顶，所有页面都从本controller出发
 */
@property (nonatomic, weak) UIViewController *startAnchoredViewController;

/*!
 * @brief 启动场景
 */
- (void)start;

@end
