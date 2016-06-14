//
//  UBPicturePickerActionSheetScene.m
//  FrameworkV1
//
//  Created by ww on 16/6/8.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPicturePickerActionSheetScene.h"

@interface UBPicturePickerActionSheetScene ()

@property (nonatomic) UIAlertController *alertController;

- (void)didSelectAction:(UBPicturePickerAction *)action;

@end


@implementation UBPicturePickerActionSheetScene

- (void)start
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UBPicturePickerAction *action in self.actions)
    {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull alertAction) {
            
            [weakSelf didSelectAction:action];
        }];
        
        [alertController addAction:alertAction];
    }
    
    self.alertController = alertController;
    
    [self.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)didSelectAction:(UBPicturePickerAction *)action
{
    
}

@end


@implementation UBPicturePickerAction

+ (UBPicturePickerAction *)actionWithId:(NSString *)actionId title:(NSString *)title
{
    UBPicturePickerAction *action = [[UBPicturePickerAction alloc] init];
    
    action.actionId = actionId ? actionId : @"";
    
    action.title = title ? title : @"";
    
    return action;
}

@end


NSString * const kPicturePickerActionId_PhotoLibrary = @"photoLibrary";
