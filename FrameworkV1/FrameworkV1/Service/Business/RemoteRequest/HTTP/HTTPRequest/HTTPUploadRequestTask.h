//
//  HTTPUploadRequestTask.h
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestTask.h"
#import "HTTPConnectionInputStream.h"

#pragma mark - HTTPUploadRequestTask

@class HTTPUploadRequestBody;


/*********************************************************
 
    @class
        HTTPUploadRequestTask
 
    @abstract
        HTTP上传请求Task
 
 *********************************************************/

@interface HTTPUploadRequestTask : HTTPRequestTask

/*!
 * @brief 上传数据
 */
@property (nonatomic) HTTPUploadRequestBody *uploadBody;

@end


/*********************************************************
 
    @protocol
        HTTPUploadRequestTaskDelegate
 
    @abstract
        HTTP上传请求Task的代理协议
 
 *********************************************************/

@protocol HTTPUploadRequestTaskDelegate <NSObject>

/*!
 * @brief 请求结束
 * @param task 请求Task
 * @param error 错误信息
 * @param response 响应信息
 * @param data 响应数据
 */
- (void)HTTPUploadRequestTask:(HTTPUploadRequestTask *)task didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

@optional

/*!
 * @brief 上传进度通知
 * @param task 请求Task
 * @param bytesSent 两次通知间的发送量
 * @param totalBytesSent 已发送总量
 * @param totalBytesExpectedToSend 期望发送总量（资源大小）
 */
- (void)HTTPUploadRequestTask:(HTTPUploadRequestTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

@end


#pragma mark - HTTPUploadRequestBody


/*********************************************************
 
    @class
        HTTPUploadRequestBody
 
    @abstract
        HTTP上传请求数据
 
    @discussion
        HTTPUploadRequestBody是一个纯抽象类
 
 *********************************************************/

@interface HTTPUploadRequestBody : NSObject

@end


/*********************************************************
 
    @class
        HTTPUploadRequestDataBody
 
    @abstract
        HTTP上传请求数据块
 
 *********************************************************/

@interface HTTPUploadRequestDataBody : HTTPUploadRequestBody

/*!
 * @brief 数据块
 */
@property (nonatomic) NSData *data;

@end


/*********************************************************
 
    @class
        HTTPUploadRequestFileBody
 
    @abstract
        HTTP上传请求文件
 
 *********************************************************/

@interface HTTPUploadRequestFileBody : HTTPUploadRequestBody

/*!
 * @brief 文件URL
 */
@property (nonatomic, copy) NSURL *fileURL;

@end


/*********************************************************
 
    @class
        HTTPUploadRequestStreamBody
 
    @abstract
        HTTP上传请求数据流
 
 *********************************************************/

@interface HTTPUploadRequestStreamBody : HTTPUploadRequestBody

/*!
 * @brief 数据流
 */
@property (nonatomic) HTTPConnectionInputStream *stream;

@end
