//
//  DeflateCompressor.m
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "DeflateCompressor.h"
#import <zlib.h>

@interface DeflateCompressor ()
{
    // zlib流
    z_stream _stream;
}

@end


@implementation DeflateCompressor

- (id)init
{
    if (self = [super init])
    {
        self.compressLevel = DeflateCompressLevel_Default;
    }
    
    return self;
}

- (BOOL)start
{
    _stream.zalloc = Z_NULL;
    
    _stream.zfree = Z_NULL;
    
    _stream.opaque = Z_NULL;
    
    int code = deflateInit(&_stream, self.compressLevel);
    
    if (code != Z_OK)
    {
        self.error = [NSError errorWithDomain:@"zlib" code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
    }
    
    return (code == Z_OK);
}

- (void)stop
{
    [_inputData setLength:0];
    
    [_outputData setLength:0];
    
    deflateEnd(&_stream);
}

- (BOOL)runWithEnd:(BOOL)end
{
    BOOL success = YES;
    
    _stream.avail_in = (uInt)[_inputData length];
    
    _stream.next_in = (unsigned char *)[_inputData bytes];
    
    NSUInteger outputSize = deflateBound(&_stream, [_inputData length]);
    
    int flush = end ? Z_FINISH : Z_NO_FLUSH;
    
    int code;
    
    do {
        
        unsigned char output[outputSize];
        
        _stream.avail_out = (uInt)outputSize;
        
        _stream.next_out = output;
        
        code = deflate(&_stream, flush);
        
        NSInteger have = outputSize - _stream.avail_out;
        
        if (code == Z_OK || code == Z_BUF_ERROR)
        {
            if (have > 0)
            {
                [_outputData appendBytes:output length:have];
            }
        }
        else if (code == Z_STREAM_END)
        {
            if (have > 0)
            {
                [_outputData appendBytes:output length:have];
            }
            
            break;
        }
        else if (code == Z_STREAM_ERROR)
        {
            self.error = [NSError errorWithDomain:@"zlib" code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
            
            success = NO;
        }
        
    } while (_stream.avail_out == 0 && success);
    
    [_inputData setLength:0];
    
    return success;
}

@end
