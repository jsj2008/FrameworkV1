//
//  UBTextFieldKeyboardInput.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBTextFieldInput.h"

/*********************************************************
 
    @class
        UBTextFieldKeyboardInput
 
    @abstract
        TextField键盘输入器，弹出键盘输入
 
 *********************************************************/

@interface UBTextFieldKeyboardInput : UBTextFieldInput

/*!
 * @brief 已输入文本
 * @discussion 在此处理文本输入后的逻辑
 */
- (void)didInputText:(NSString *)text;

@end
