//
//  NetworkManager.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkReachability.h"
#import "NSObject+Delegate.h"

@protocol NetworkManagerDelegate;


@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (void)addDelegate:(id<NetworkManagerDelegate>)delegate;

- (void)removeDelegate:(id<NetworkManagerDelegate>)delegate;

- (void)start;

- (void)stop;

@end


@protocol NetworkManagerDelegate <NSObject>

- (void)networkManager:(NetworkManager *)manager didChangeFromStatus:(NetworkReachStatus)fromStatus toStatus:(NetworkReachStatus)toStatus;

@end
