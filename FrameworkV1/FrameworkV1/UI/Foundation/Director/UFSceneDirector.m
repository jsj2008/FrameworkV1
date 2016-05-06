//
//  UFSceneDirector.m
//  MarryYou
//
//  Created by ww on 15/11/12.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import "UFSceneDirector.h"

@interface UFSceneDirector ()
{
    __weak UINavigationController *_navigationController;
}

@end


@implementation UFSceneDirector

@synthesize navigationController = _navigationController;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if (self = [super init])
    {
        _navigationController = navigationController;
    }
    
    return self;
}

- (void)start
{
    
}

@end
