//
//  DataDecompressor.m
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "DataDecompressor.h"

@implementation DataDecompressor

- (id)init
{
    if (self = [super init])
    {
        _inputData = [[NSMutableData alloc] init];
        
        _outputData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (BOOL)start
{
    return YES;
}

- (void)stop
{
    
}

- (void)addData:(NSData *)data
{
    [_inputData appendData:data];
}

- (BOOL)run
{
    [_outputData appendData:_inputData];
    
    [_inputData setLength:0];
    
    return YES;
}

- (BOOL)isOver
{
    return _over;
}

- (NSData *)outputData
{
    return _outputData;
}

- (void)cleanOutput
{
    [_outputData setLength:0];
}

@end
