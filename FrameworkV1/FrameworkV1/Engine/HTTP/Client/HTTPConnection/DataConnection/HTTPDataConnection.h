//
//  HTTPDataConnection.h
//  Test1
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnection.h"
#import "NSURLSessionTask+Delegate.h"

@class HTTPDownloadConnection;

@protocol HTTPDataConnectionDelegate;


/*********************************************************
 
    @class
        HTTPDataConnection
 
    @abstract
        HTTP数据连接，用于请求远端数据
 
    @discussion
        1，HTTPDataConnection支持get请求的本地缓存
        2，HTTPDataConnection支持将自身转化成下载连接
 
 *********************************************************/

@interface HTTPDataConnection : HTTPConnection

/*!
 * @brief 初始化
 * @param task dataTask
 * @result 初始化后的对象
 */
- (instancetype)initWithURLSessionDataTask:(NSURLSessionDataTask *)task;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPDataConnectionDelegate> delegate;

@end


/*********************************************************
 
    @protocol
        HTTPDataConnectionDelegate
 
    @abstract
        HTTP数据连接的delegate通知
 
 *********************************************************/

@protocol HTTPDataConnectionDelegate <NSObject>

/*!
 * @brief 请求结束
 * @param dataConnection 数据连接
 * @param error 错误信息
 * @param response 响应信息
 * @param data 响应数据
 */
- (void)HTTPDataConnection:(HTTPDataConnection *)dataConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

/*!
 * @brief 接收并配置响应
 * @param dataConnection 数据连接
 * @param response 响应信息
 * @result 响应配置，只支持NSURLSessionResponseCancel，NSURLSessionResponseAllow，NSURLSessionResponseBecomeDownload，默认NSURLSessionResponseAllow
 */
- (NSURLSessionResponseDisposition)HTTPDataConnection:(HTTPDataConnection *)dataConnection dispositionForResponse:(NSURLResponse *)response;

/*!
 * @brief 以转换为下载连接
 * @param dataConnection 数据连接
 * @param downloadConnection 下载连接
 */
- (void)HTTPDataConnection:(HTTPDataConnection *)dataConnection didBecomeDownloadConnection:(HTTPDownloadConnection *)downloadConnection;

@end
