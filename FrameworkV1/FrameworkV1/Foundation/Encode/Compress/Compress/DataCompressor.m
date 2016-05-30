//
//  DataCompressor.m
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "DataCompressor.h"

@implementation DataCompressor

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
    [_inputData setLength:0];
    
    [_outputData setLength:0];
}

- (void)addData:(NSData *)data
{
    if (data && [data length])
    {
        [_inputData appendData:data];
    }
}

- (BOOL)runWithEnd:(BOOL)end
{
    [_outputData appendData:_inputData];
    
    [_inputData setLength:0];
    
    return YES;
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


NSString * const CompressErrorDomain = @"CompressError";
