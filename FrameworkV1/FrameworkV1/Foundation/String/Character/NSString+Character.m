//
//  NSString+Character.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSString+Character.h"

@implementation NSString (Character)

- (NSString *)stringByDeletingBothPrefixAndSuffixMarks:(NSString *)mark
{
    NSMutableString *string = [NSMutableString stringWithString:self];
    
    NSUInteger markLength = [mark length];
    
    if (markLength && ([string length] >= 2 * markLength) && [string hasPrefix:mark] && [string hasSuffix:mark])
    {
        [string deleteCharactersInRange:NSMakeRange(0, markLength)];
        
        if ([string length] >= markLength)
        {
            [string deleteCharactersInRange:NSMakeRange([string length] - markLength, markLength)];
        }
    }
    
    return string;
}

@end
