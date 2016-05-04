//
//  ImageManager.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/10/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageManager.h"
#import "NSObject+Notify.h"
#import "NotificationObservingSet.h"
#import "SPTaskDispatcher+Convenience.h"
#import "ImageDownloadTask.h"
#import "ImageStorage.h"

@interface ImageManager () <ImageDownloadTaskDelegate>

/*!
 * @brief 观察者
 */
@property (nonatomic) NSMutableDictionary *downloadImageObservers;

/*!
 * @brief 任务派发器
 */
@property (nonatomic) SPTaskDispatcher *taskDispatcher;

/*!
 * @brief 同步队列
 */
@property (nonatomic) dispatch_queue_t syncQueue;

@end


@implementation ImageManager

- (void)dealloc
{
    dispatch_sync(self.syncQueue, ^{});
}

+ (ImageManager *)sharedInstance
{
    static ImageManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[ImageManager alloc] init];
        }
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.downloadImageObservers = [[NSMutableDictionary alloc] init];
        
        self.syncQueue = dispatch_queue_create(nil, nil);
        
        self.taskDispatcher = [SPTaskDispatcher taskDispatcherWithSharedPools];
    }
    
    return self;
}

- (void)start
{
    
}

- (void)stop
{
    [self.taskDispatcher cancel];
}

- (void)downLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDownloadObserving>)observer
{
    dispatch_sync(self.syncQueue, ^{
        
        if ([URL isFileURL])
        {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            
            [self notify:^{
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:URL withError:nil imageData:data];
                }
                
            } onThread:[NSThread currentThread]];
        }
        else
        {
            NSData *data = [[ImageStorage sharedInstance] imageDataByURL:URL];
            
            if (data)
            {
                [self notify:^{
                    
                    if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                    {
                        [observer imageManager:self didFinishDownloadImageByURL:URL withError:nil imageData:data];
                    }
                    
                } onThread:[NSThread currentThread]];
            }
            else
            {
                NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
                
                if (!set)
                {
                    ImageDownloadTask *task = [[ImageDownloadTask alloc] init];
                    
                    task.imageURL = URL;
                                        
                    task.delegate = self;
                    
                    [self.taskDispatcher asyncAddTask:task inPool:kTaskDispatcherPoolIdentifier_Daemon];
                    
                    set = [[NotificationObservingSet alloc] init];
                    
                    set.object = task;
                    
                    [self.downloadImageObservers setObject:set forKey:URL];
                }
                
                NotificationObserver *notificationObserver = [[NotificationObserver alloc] init];
                
                notificationObserver.observer = observer;
                
                notificationObserver.notifyThread = [NSThread currentThread];
                
                [set.observers addObject:notificationObserver];
            }
        }
    });
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDownloadObserving>)observer
{
    if (URL && observer)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
            
            if (set)
            {
                NSMutableArray *toRemoveObjects = [[NSMutableArray alloc] init];
                
                for (NotificationObserver *notificationObserver in set.observers)
                {
                    if ([notificationObserver.observer isEqual:observer])
                    {
                        [toRemoveObjects addObject:notificationObserver];
                    }
                }
                
                [set.observers removeObjectsInArray:toRemoveObjects];
            }
            
            if (![set.observers count])
            {
                [self.taskDispatcher cancelTask:set.object];
                
                [self.downloadImageObservers removeObjectForKey:URL];
            }
        });
    }
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL
{
    if (URL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
            
            [self.taskDispatcher cancelTask:set.object];
            
            [self.downloadImageObservers removeObjectForKey:URL];
        });
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    if (task.imageURL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            [[ImageStorage sharedInstance] saveImageByURL:task.imageURL withData:data];
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notify:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:task.imageURL withError:error imageData:data];
                }
                
            } onThread:nil];
            
            [self.taskDispatcher removeTask:task];
            
            [self.downloadImageObservers removeObjectForKey:task.imageURL];
        });
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithProgress:(float)progress
{
    if (task.imageURL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notify:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didDownloadImageByURL:withProgress:)])
                {
                    [observer imageManager:self didDownloadImageByURL:task.imageURL withProgress:progress];
                }
            } onThread:nil];
        });
    }
}

@end
