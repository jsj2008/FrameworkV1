//
//  UBTextFieldDataPickerInputToolBar.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFDataPickerInputAccessory.h"

/*********************************************************
 
    @class
        UBTextFieldDataPickerInputToolBar
 
    @abstract
        TextField数据选择输入器工具栏
 
    @discussion
        可由子类实现工具栏的视图和布局
 
 *********************************************************/

@interface UBTextFieldDataPickerInputToolBar : UIView <UFDataPickerInputAccessory>

@end
