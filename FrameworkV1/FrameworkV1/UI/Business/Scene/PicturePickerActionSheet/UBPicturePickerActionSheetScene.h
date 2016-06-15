//
//  UBPicturePickerActionSheetScene.h
//  FrameworkV1
//
//  Created by ww on 16/6/8.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UFScene.h"

@class UBPicturePickerAction;

@protocol UBPicturePickerActionSheetSceneDelegate;


/*********************************************************
 
    @class
        UBPicturePickerActionSheetScene
 
    @abstract
        图片选择表场景，展示一个actionSheet让用户选择不同的图片选择方式
 
 *********************************************************/

@interface UBPicturePickerActionSheetScene : UFScene

/*!
 * @brief 消息代理
 */
@property (nonatomic, weak) id<UBPicturePickerActionSheetSceneDelegate> delegate;

/*!
 * @brief 操作表
 */
@property (nonatomic) NSArray<UBPicturePickerAction *> *actions;

@end


/*********************************************************
 
    @protocol
        UBPicturePickerActionSheetSceneDelegate
 
    @abstract
        图片选择表场景消息代理协议
 
 *********************************************************/

@protocol UBPicturePickerActionSheetSceneDelegate <NSObject>

/*!
 * @brief 场景结束
 * @param scene 场景
 * @param image 被选中的图片
 * @param error 错误
 */
- (void)picturePickerActionSheetScene:(UBPicturePickerActionSheetScene *)scene didFinishWithSelectedImage:(UIImage *)image error:(NSError *)error;

@end


/*********************************************************
 
    @class
        UBPicturePickerAction
 
    @abstract
        图片选择操作
 
 *********************************************************/

@interface UBPicturePickerAction : NSObject

/*!
 * @brief ID
 */
@property (nonatomic, copy) NSString *actionId;

/*!
 * @brief 在actionSheet中显示的标题
 */
@property (nonatomic, copy) NSString *title;

/*!
 * @brief 是否允许编辑图片
 */
@property (nonatomic) BOOL imageEditable;

/*!
 * @brief 对象生成
 * @param actionId ID
 * @param title 在actionSheet中显示的标题
 * @param editable 是否允许编辑图片
 */
+ (UBPicturePickerAction *)actionWithId:(NSString *)actionId title:(NSString *)title imageEditable:(BOOL)imageEditable;

@end


/*********************************************************
 
    @const
        kPicturePickerActionId
 
    @abstract
        操作ID
 
 *********************************************************/

/*!
 * @brief 从本地图库选择图片
 */
extern NSString * const kPicturePickerActionId_PhotoLibrary;

/*!
 * @brief 拍照选择图片
 */
extern NSString * const kPicturePickerActionId_Camera;

/*!
 * @brief 从相册选择图片
 */
extern NSString * const kPicturePickerActionId_SavedPhotosAlbum;
