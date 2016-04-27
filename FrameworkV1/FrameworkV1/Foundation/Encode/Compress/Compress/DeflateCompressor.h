//
//  DeflateCompressor.h
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "DataCompressor.h"

/******************************************************
 
    @enum
        DeflateCompressLevel
 
    @abstract
        Deflate压缩等级
 
 ******************************************************/

typedef NS_ENUM(NSInteger, DeflateCompressLevel)
{
    DeflateCompressLevel_BestSpeed    = 1,
    DeflateCompressLevel_BestCompress = 9,
    DeflateCompressLevel_Default      = -1
};


/******************************************************
 
    @class
        DeflateCompressor
 
    @abstract
        deflate格式数据压缩器
 
 ******************************************************/

@interface DeflateCompressor : DataCompressor

/*!
 * @brief 压缩等级
 */
@property (nonatomic) DeflateCompressLevel compressLevel;

@end
