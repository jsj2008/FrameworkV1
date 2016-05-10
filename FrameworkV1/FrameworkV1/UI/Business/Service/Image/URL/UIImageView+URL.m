//
//  UIImageView+URL.m
//  FrameworkV1
//
//  Created by ww on 16/5/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UIImageView+URL.h"
#import <objc/runtime.h>
#import "ImageDownloadTask.h"

static const char kUIImageViewPropertyKey_URLLoadingConfiguration[] = "URLLoadingConfiguration";

static const char kUIImageViewPropertyKey_URLLoadingTask[] = "URLLoadingTask";


@interface UIImageView (URL_Internal) <ImageDownloadTaskDelegate>

@property (nonatomic) ImageDownloadTask *URLLoadingTask;

@end


@implementation UIImageView (URL)

- (void)setURLLoadingConfiguration:(UBImageViewURLLoadingConfiguration *)URLLoadingConfiguration
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingConfiguration, URLLoadingConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UBImageViewURLLoadingConfiguration *)URLLoadingConfiguration
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingConfiguration);
}

- (void)startURLLoading
{
    self.URLLoadingTask.delegate = nil;
    
    [self.URLLoadingTask cancel];
    
    self.URLLoadingTask = [[ImageDownloadTask alloc] initWithURL:self.URLLoadingConfiguration.URL];
    
    self.URLLoadingTask.delegate = self;
    
    [self.URLLoadingTask performSelector:@selector(main) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
    if (self.URLLoadingConfiguration.isPlaceHolderImageEnabled)
    {
        self.image = self.URLLoadingConfiguration.placeHolderImage;
    }
}

- (void)cancelURLLoading
{
    self.URLLoadingTask.delegate = nil;
    
    [self.URLLoadingTask cancel];
}

@end


@implementation UIImageView (URL_Internal)

- (void)setURLLoadingTask:(ImageDownloadTask *)URLLoadingTask
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingTask, URLLoadingTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ImageDownloadTask *)URLLoadingTask
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingTask);
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    if (error)
    {
        if (self.URLLoadingConfiguration.isFailureImageEnabled)
        {
            self.image = self.URLLoadingConfiguration.failureImage;
        }
    }
    else
    {
        self.image = [data length] > 0 ? [UIImage imageWithData:data] : nil;
    }
    
    if (self.URLLoadingConfiguration.completion)
    {
        self.URLLoadingConfiguration.completion(task.URL, error);
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    if (self.URLLoadingConfiguration.progressing)
    {
        self.URLLoadingConfiguration.progressing(task.URL, downloadedSize, expectedSize);
    }
}

@end


@implementation UBImageViewURLLoadingConfiguration

@end


@implementation UIImageView (URLConvenience)

- (void)setImageWithURL:(NSURL *)URL
{
    UBImageViewURLLoadingConfiguration *configuration = [[UBImageViewURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    self.URLLoadingConfiguration = configuration;
    
    [self startURLLoading];
}

- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage completion:(UBImageViewURLLoadingCompletion)completion
{
    UBImageViewURLLoadingConfiguration *configuration = [[UBImageViewURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enablePlaceHolderImage = YES;
    
    configuration.placeHolderImage = placeHolderImage;
    
    configuration.completion = completion;
    
    self.URLLoadingConfiguration = configuration;
    
    [self startURLLoading];
}

@end
