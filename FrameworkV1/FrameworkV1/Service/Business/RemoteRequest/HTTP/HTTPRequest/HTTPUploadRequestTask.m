//
//  HTTPUploadRequestTask.m
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPUploadRequestTask.h"
#import "HTTPUploadConnection.h"
#import "HTTPSession+SharedInstance.h"

#pragma mark - HTTPUploadRequestBody

@interface HTTPUploadRequestBody ()

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session;

@end


@implementation HTTPUploadRequestBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request session:session];
}

@end


@implementation HTTPUploadRequestDataBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request fromData:self.data session:session];
}

@end


@implementation HTTPUploadRequestFileBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request fromFile:self.fileURL session:session];
}

@end


@implementation HTTPUploadRequestStreamBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request fromStream:self.stream session:session];
}

@end


#pragma mark - HTTPUploadRequestTask


@interface HTTPUploadRequestTask () <HTTPUploadConnectionDelegate>

@property (nonatomic) HTTPUploadConnection *connection;

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

@end


@implementation HTTPUploadRequestTask

- (void)run
{
    NSURL *URL = self.URL ? self.URL : [NSURL URLWithString:@""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeout];
    
    request.HTTPMethod = @"GET";
    
    request.allHTTPHeaderFields = self.headerFields;
    
    HTTPConnectionInternetPassword *internetPassword = [[HTTPConnectionInternetPassword alloc] init];
    
    internetPassword.user = self.internetPassword.user;
    
    internetPassword.password = self.internetPassword.password;
    
    self.connection = [self.uploadBody uploadConnectionWithRequest:request session:[HTTPSession sharedDefaultConfigurationInstance]];
    
    self.connection.internetPassword = internetPassword;
    
    self.connection.delegate = self;
    
    [self.connection start];
}

- (void)cancel
{
    [super cancel];
    
    self.connection.delegate = nil;
    
    [self.connection cancel];
    
    self.connection = nil;
}

- (void)HTTPUploadConnection:(HTTPUploadConnection *)uploadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data
{
    [self finishWithError:error response:response data:data];
}

- (void)HTTPUploadConnection:(HTTPUploadConnection *)uploadConnection didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPUploadRequestTask:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)])
        {
            [self.delegate HTTPUploadRequestTask:self didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }
    } onThread:self.notifyThread];
}

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPUploadRequestTask:didFinishWithError:response:data:)])
        {
            [self.delegate HTTPUploadRequestTask:self didFinishWithError:error response:response data:data];
        }
    } onThread:self.notifyThread];
}

@end
