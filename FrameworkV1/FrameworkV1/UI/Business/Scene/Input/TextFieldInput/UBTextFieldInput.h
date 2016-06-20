//
//  UBTextFieldInput.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UBTextFieldInput
 
    @abstract
        TextField数据输入器
 
    @discussion
        UBTextFieldInput是抽象类
 
 *********************************************************/

@interface UBTextFieldInput : NSObject

/*!
 * @brief 初始化
 * @param textField 文本输入框
 * @result 初始化对象
 */
- (instancetype)initWithTextField:(UITextField *)textField;

/*!
 * @brief 文本输入框
 */
@property (nonatomic, readonly) UITextField *textField;

@end
