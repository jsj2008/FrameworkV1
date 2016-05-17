//
//  UFDataPickInputAccessory.h
//  FrameworkV1
//
//  Created by ww on 16/5/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @protocol
        UFDataPickInputAccessoryDelegate
 
    @abstract
        数据选择输入器附件的代理协议
 
 *********************************************************/

@protocol UFDataPickInputAccessoryDelegate <NSObject>

/*!
 * @brief 已确认
 * @param accessory 附件对象
 */
- (void)dataPickInputAccessoryDidConfirm:(id)accessory;

/*!
 * @brief 已取消
 * @param accessory 附件对象
 */
- (void)dataPickInputAccessoryDidCancel:(id)accessory;

@end


/*********************************************************
 
    @protocol
        UFDataPickInputAccessory
 
    @abstract
        数据选择输入器附件协议
 
 *********************************************************/

@protocol UFDataPickInputAccessory <NSObject>

/*!
 * @brief 附件代理对象
 */
@property (nonatomic, weak) id<UFDataPickInputAccessoryDelegate> dataPickInputAccessoryDelegate;

@end
