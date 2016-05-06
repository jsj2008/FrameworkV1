//
//  UITextView+PlaceHolder.h
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFTextViewPlaceHolder.h"

/*********************************************************
 
    @category
        UITextView (PlaceHolder)
 
    @abstract
        UITextView的placeHolder扩展
 
 *********************************************************/

@interface UITextView (PlaceHolder)

/*!
 * @brief placeHolder
 * @discussion 设置placeHolder时将立即处理UITextView，务必在设置placeHolder前完成对UITextView和placeHolder的设置
 */
@property (nonatomic) UFTextViewPlaceHolder *placeHolder;

/*!
 * @brief 内容文本
 * @discussion 当textView显示placeHolder时为nil，否则为textView内容
 */
@property (nonatomic, readonly, copy) NSString *contentText;

@end
