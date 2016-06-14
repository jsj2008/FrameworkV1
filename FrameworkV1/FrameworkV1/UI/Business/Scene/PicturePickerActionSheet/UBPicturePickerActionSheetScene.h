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


@interface UBPicturePickerActionSheetScene : UFScene

@property (nonatomic, weak) id<UBPicturePickerActionSheetSceneDelegate> delegate;

@property (nonatomic) NSArray<UBPicturePickerAction *> *actions;

@end


@protocol UBPicturePickerActionSheetSceneDelegate <NSObject>

- (void)picturePickerActionSheetScene:(UBPicturePickerActionSheetScene *)scene didFinishWithSelectedImage:(UIImage *)image error:(NSError *)error;

@end


@interface UBPicturePickerAction : NSObject

@property (nonatomic, copy) NSString *actionId;

@property (nonatomic, copy) NSString *title;

+ (UBPicturePickerAction *)actionWithId:(NSString *)actionId title:(NSString *)title;

@end


extern NSString * const kPicturePickerActionId_PhotoLibrary;
