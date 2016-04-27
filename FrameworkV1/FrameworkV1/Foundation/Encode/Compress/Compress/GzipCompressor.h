//
//  GzipCompressor.h
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "DataCompressor.h"

/******************************************************
 
    @enum
        GzipCompressLevel
 
    @abstract
        Gzip压缩等级
 
 ******************************************************/

typedef NS_ENUM(NSInteger, GzipCompressLevel)
{
    GzipCompressLevel_BestSpeed    = 1,
    GzipCompressLevel_BestCompress = 9,
    GzipCompressLevel_Default      = -1
};


/******************************************************
 
    @class
        GzipCompressor
 
    @abstract
        gzip格式数据压缩器
 
 ******************************************************/

@interface GzipCompressor : DataCompressor

/*!
 * @brief 压缩等级
 */
@property (nonatomic) GzipCompressLevel compressLevel;

@end
