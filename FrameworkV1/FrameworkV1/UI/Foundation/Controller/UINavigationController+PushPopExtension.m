//
//  UINavigationController+PushPopExtension.m
//  FrameworkV1
//
//  Created by ww on 16/5/6.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UINavigationController+PushPopExtension.h"

@implementation UINavigationController (PushPopExtension)

- (void)pushViewController:(UIViewController *)viewController onNewTopViewController:(UIViewController *)newTopViewController animated:(BOOL)animated
{
    if (viewController)
    {
        if (!newTopViewController)
        {
            [self setViewControllers:[NSArray arrayWithObject:viewController]];
        }
        else if (self.topViewController == newTopViewController)
        {
            [self pushViewController:viewController animated:animated];
        }
        else
        {
            NSUInteger index = [self.viewControllers indexOfObject:newTopViewController];
            
            if (index != NSNotFound)
            {
                NSMutableArray *newViewControllers = [[NSMutableArray alloc] initWithArray:[self.viewControllers subarrayWithRange:NSMakeRange(0, index + 1)]];
                
                [newViewControllers addObject:viewController];
                
                [self setViewControllers:newViewControllers animated:animated];
            }
            else
            {
                [self pushViewController:viewController animated:animated];
            }
        }
    }
}

@end
