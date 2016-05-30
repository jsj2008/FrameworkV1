//
//  GzipDecompressor.m
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "GzipDecompressor.h"
#import <zlib.h>

@interface GzipDecompressor ()
{
    // zlib流
    z_stream _stream;
    
    // gzip头
    char _dummy_head[2];
}

@property (nonatomic) BOOL dummyHeadUsed;

@end


@implementation GzipDecompressor

- (BOOL)start
{
    _stream.zalloc = Z_NULL;
    
    _stream.zfree = Z_NULL;
    
    _stream.opaque = Z_NULL;
    
    _stream.avail_in = 0;
    
    _stream.next_in = Z_NULL;
    
    _dummy_head[0] = 0x8 + 0x7 * 0x10;
    
    _dummy_head[1] = (((0x8 + 0x7 * 0x10) * 0x100 + 30) / 31 * 31) & 0xFF;
    
    int code = inflateInit2(&_stream, MAX_WBITS + 16);
    
    if (code != Z_OK)
    {
        self.error = [NSError errorWithDomain:DecompressErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
    }
    
    return (code == Z_OK);
}

- (void)stop
{
    inflateEnd(&_stream);
}

- (BOOL)run
{
    BOOL success = YES;
    
    unsigned char *input = (unsigned char *)[_inputData bytes];
    
    unsigned char output[1024];
    
    _stream.avail_in = (uInt)[_inputData length];
    
    _stream.next_in = input;
    
    int code;
    
    int have;
    
    do {
        
        _stream.avail_out = 1024;
        
        _stream.next_out = output;
        
        code = inflate(&_stream, Z_NO_FLUSH);
        
        have = 1024 - _stream.avail_out;
        
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
            
            _over = YES;
            
            break;
        }
        else if (code == Z_NEED_DICT || code == Z_STREAM_ERROR || code == Z_MEM_ERROR)
        {
            success = NO;
            
            _over = YES;
            
            self.error = [NSError errorWithDomain:DecompressErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
        }
        else if (code == Z_DATA_ERROR)
        {
            if (self.dummyHeadUsed)
            {
                success = NO;
                
                _over = YES;
                
                self.error = [NSError errorWithDomain:DecompressErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
            }
            else
            {
                _stream.avail_in = sizeof(_dummy_head);
                
                _stream.next_in = (Bytef *)_dummy_head;
            }
        }
        
    } while (_stream.avail_out == 0 && success);
    
    [_inputData setLength:0];
    
    return success;
}

@end
