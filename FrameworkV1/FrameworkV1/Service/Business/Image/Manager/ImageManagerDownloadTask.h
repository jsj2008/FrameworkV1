//
//  ImageManagerDownloadTask.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ServiceTask.h"

@protocol ImageManagerDownloadTaskDelegate;


/*********************************************************
 
    @class
        ImageManagerDownloadTask
 
    @abstract
        图片管理器下载任务
 
 *********************************************************/

@interface ImageManagerDownloadTask : ServiceTask

/*!
 * @brief 图片URL
 */
@property (nonatomic, copy) NSURL *imageURL;

@end


/*********************************************************
 
    @protocol
        ImageDownloadTaskDelegate
 
    @abstract
        图片管理器下载任务代理消息
 
 *********************************************************/

@protocol ImageManagerDownloadTaskDelegate <NSObject>

/*!
 * @brief 图片下载完成
 * @param task 任务
 * @param error 错误信息
 * @param data 图片数据
 */
- (void)imageManagerDownloadTask:(ImageManagerDownloadTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data;

/*!
 * @brief 图片下载进度
 * @param task 任务
 * @param downloadedSize 已下载量
 * @param expectedSize 预期下载量
 */
- (void)imageManagerDownloadTask:(ImageManagerDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
