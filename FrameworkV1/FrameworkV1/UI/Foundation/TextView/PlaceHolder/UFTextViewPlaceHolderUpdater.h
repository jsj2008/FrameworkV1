//
//  UFTextViewPlaceHolderUpdater.h
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFTextViewPlaceHolder.h"

/*********************************************************
 
    @class
        UFTextViewPlaceHolderUpdater
 
    @abstract
        textView的placeHolder控制器
 
 *********************************************************/

@interface UFTextViewPlaceHolderUpdater: NSObject

/*!
 * @brief textView
 */
@property (nonatomic, weak) UITextView *textView;

/*!
 * @brief placeHolder
 */
@property (nonatomic) UFTextViewPlaceHolder *placeHolder;

/*!
 * @brief 内容文本
 * @discussion 当textView显示placeHolder时为nil，否则为textView内容
 */
@property (nonatomic, readonly, copy) NSString *contentText;

@end
