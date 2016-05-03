//
//  ImageDownloadTask.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageDownloadTask.h"
#import "HTTPDownloadConnection.h"
#import "HTTPSession+SharedInstance.h"

@interface ImageDownloadTask () <HTTPDownloadConnectionDelegate>

@property (nonatomic) HTTPDownloadConnection *connection;

@property (nonatomic) NSData *data;

- (void)finishWithError:(NSError *)error imageData:(NSData *)data;;

@end


@implementation ImageDownloadTask

- (void)run
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3 * 60];
    
    self.connection = [[HTTPDownloadConnection alloc] initWithRequest:request session:[HTTPSession sharedDefaultConfigurationInstance]];
    
    self.connection.delegate = self;
    
    [self.connection start];
}

- (void)cancel
{
    [super cancel];
    
    [self.connection cancel];
    
    self.connection = nil;
}

- (void)finishWithError:(NSError *)error imageData:(NSData *)data
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloadTask:didFinishWithError:imageData:)])
        {
            [self.delegate imageDownloadTask:self didFinishWithError:error imageData:data];
        }
    }];
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishDownloadingToURL:(NSURL *)location
{
    if (location)
    {
        self.data = [NSData dataWithContentsOfURL:location];
    }
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response
{
    [self finishWithError:error imageData:self.data];
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self notify:^{
        
        if ([self.delegate respondsToSelector:@selector(imageDownloadTask:didDownloadImageWithProgress:)])
        {
            [self.delegate imageDownloadTask:self didDownloadImageWithProgress:(totalBytesExpectedToWrite > 0) ? MIN((totalBytesWritten / totalBytesExpectedToWrite), 1) : 0];
        }
    }];
}

@end
