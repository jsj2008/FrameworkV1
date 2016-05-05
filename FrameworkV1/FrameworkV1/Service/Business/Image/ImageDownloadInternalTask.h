//
//  ImageDownloadInternalTask.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "OperationTask.h"

@protocol ImageDownloadTaskDelegate;


/*********************************************************
 
    @class
        ImageDownloadInternalTask
 
    @abstract
        图片下载任务
 
 *********************************************************/

@interface ImageDownloadInternalTask : OperationTask

/*!
 * @brief 图片URL
 */
@property (nonatomic, copy) NSURL *imageURL;

@end


/*********************************************************
 
    @protocol
        ImageDownloadTaskDelegate
 
    @abstract
        图片下载任务代理消息
 
 *********************************************************/

@protocol ImageDownloadTaskDelegate <NSObject>

/*!
 * @brief 图片下载完成
 * @param task 任务
 * @param successfully 下载是否成功
 * @param data 图片数据
 */
- (void)imageDownloadInternalTask:(ImageDownloadInternalTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data;

/*!
 * @brief 图片下载进度
 * @param task 任务
 * @param progress 下载进度
 */
- (void)imageDownloadInternalTask:(ImageDownloadInternalTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
