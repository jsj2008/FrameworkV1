//
//  ImageDownloadInternalTask.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageDownloadInternalTask.h"
#import "HTTPDownloadConnection.h"
#import "HTTPSession+SharedInstance.h"

@interface ImageDownloadInternalTask () <HTTPDownloadConnectionDelegate>

@property (nonatomic) HTTPDownloadConnection *connection;

@property (nonatomic) NSData *data;

- (void)finishWithError:(NSError *)error imageData:(NSData *)data;;

@end


@implementation ImageDownloadInternalTask

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
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloadInternalTask:didFinishWithError:imageData:)])
        {
            [self.delegate imageDownloadInternalTask:self didFinishWithError:error imageData:data];
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
        
        if ([self.delegate respondsToSelector:@selector(imageDownloadInternalTask:didDownloadImageWithDownloadedSize:expectedSize:)])
        {
            [self.delegate imageDownloadInternalTask:self didDownloadImageWithDownloadedSize:totalBytesWritten expectedSize:totalBytesExpectedToWrite];
        }
    }];
}

@end
