//
//  UBPicturePickerActionSheetScene.m
//  FrameworkV1
//
//  Created by ww on 16/6/8.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPicturePickerActionSheetScene.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface UBPicturePickerActionSheetScene () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIAlertController *alertController;

@property (nonatomic) UIViewController *pickerController;

- (void)didSelectAction:(UBPicturePickerAction *)action;

- (void)showPhotoLibraryForAction:(UBPicturePickerAction *)action;

- (void)showCameraForAction:(UBPicturePickerAction *)action;

- (void)showSavedPhotosAlbumForAction:(UBPicturePickerAction *)action;

@end


@implementation UBPicturePickerActionSheetScene

- (void)dealloc
{
    // 为防止alertController显示时，scene被撤销而可能导致alertController一直被显示，这里需要进行一次dismiss操作
    if (self.alertController && self.alertController.presentingViewController)
    {
        [self.alertController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    // 为防止pickerController显示时，scene被撤销而可能导致pickerController一直被显示，这里需要进行一次dismiss操作
    if (self.pickerController && self.pickerController.presentingViewController)
    {
        [self.pickerController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

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
    // 在这里需要判断权限
    if ([action.actionId isEqualToString:kPicturePickerActionId_PhotoLibrary])
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        switch (status)
        {
            case PHAuthorizationStatusRestricted:
                
            case PHAuthorizationStatusDenied:
                
                NSLog(@"");
                
                break;
                
            case PHAuthorizationStatusNotDetermined:
            {
                __weak typeof(self) weakSelf = self;
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        [weakSelf showPhotoLibraryForAction:action];
                    }
                    else
                    {
                        NSLog(@"");
                    }
                }];
                
                break;
            }
                
            case PHAuthorizationStatusAuthorized:
                
                [self showPhotoLibraryForAction:action];
                
                break;
                
            default:
                
                break;
        }
    }
    else if ([action.actionId isEqualToString:kPicturePickerActionId_Camera])
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status)
        {
            case AVAuthorizationStatusRestricted:
                
            case AVAuthorizationStatusDenied:
                
                NSLog(@"");
                
                break;
                
            case AVAuthorizationStatusNotDetermined:
            {
                __weak typeof(self) weakSelf = self;
                
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    if (granted)
                    {
                        [weakSelf showCameraForAction:action];
                    }
                }];
            }
                
            case AVAuthorizationStatusAuthorized:
                
                [self showCameraForAction:action];
                
                break;
                
            default:
                break;
        }
    }
    else if ([action.actionId isEqualToString:kPicturePickerActionId_SavedPhotosAlbum])
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        switch (status)
        {
            case PHAuthorizationStatusRestricted:
                
            case PHAuthorizationStatusDenied:
                
                NSLog(@"");
                
                break;
                
            case PHAuthorizationStatusNotDetermined:
            {
                __weak typeof(self) weakSelf = self;
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        [weakSelf showSavedPhotosAlbumForAction:action];
                    }
                    else
                    {
                        NSLog(@"");
                    }
                }];
                
                break;
            }
                
            case PHAuthorizationStatusAuthorized:
                
                [self showSavedPhotosAlbumForAction:action];
                
                break;
                
            default:
                
                break;
        }
    }
}

- (void)showPhotoLibraryForAction:(UBPicturePickerAction *)action
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        pickerController.delegate = self;
        
        pickerController.allowsEditing = action.imageEditable;
        
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.navigationController.topViewController presentViewController:pickerController animated:YES completion:nil];
        
        self.pickerController = pickerController;
    }
    else
    {
        NSLog(@"");
    }
}

- (void)showCameraForAction:(UBPicturePickerAction *)action
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        pickerController.delegate = self;
        
        pickerController.allowsEditing = action.imageEditable;
        
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.navigationController.topViewController presentViewController:pickerController animated:YES completion:nil];
        
        self.pickerController = pickerController;
    }
    else
    {
        NSLog(@"");
    }
}

- (void)showSavedPhotosAlbumForAction:(UBPicturePickerAction *)action
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        pickerController.delegate = self;
        
        pickerController.allowsEditing = action.imageEditable;
        
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self.navigationController.topViewController presentViewController:pickerController animated:YES completion:nil];
        
        self.pickerController = pickerController;
    }
    else
    {
        NSLog(@"");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __weak typeof(self) weakSelf = self;
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        weakSelf.pickerController = nil;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(picturePickerActionSheetScene:didFinishWithSelectedImage:error:)])
        {
            [weakSelf.delegate picturePickerActionSheetScene:weakSelf didFinishWithSelectedImage:[info objectForKey:UIImagePickerControllerEditedImage] error:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        weakSelf.pickerController = nil;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(picturePickerActionSheetScene:didFinishWithSelectedImage:error:)])
        {
            [weakSelf.delegate picturePickerActionSheetScene:weakSelf didFinishWithSelectedImage:nil error:nil];
        }
    }];
}

@end


@implementation UBPicturePickerAction

+ (UBPicturePickerAction *)actionWithId:(NSString *)actionId title:(NSString *)title imageEditable:(BOOL)imageEditable
{
    UBPicturePickerAction *action = [[UBPicturePickerAction alloc] init];
    
    action.actionId = actionId ? actionId : @"";
    
    action.title = title ? title : @"";
    
    action.imageEditable = imageEditable;
    
    return action;
}

@end


NSString * const kPicturePickerActionId_PhotoLibrary = @"photoLibrary";

NSString * const kPicturePickerActionId_Camera = @"camera";

NSString * const kPicturePickerActionId_SavedPhotosAlbum = @"savedPhotosAlbum";
