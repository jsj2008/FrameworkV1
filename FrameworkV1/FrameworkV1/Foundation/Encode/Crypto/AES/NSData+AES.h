//
//  NSData+AES.h
//  FrameworkV1
//
//  Created by ww on 16/4/21.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/*********************************************************
 
    @category
        NSData (AES)
 
    @abstract
        NSData的AES编解码扩展
 
 *********************************************************/

@interface NSData (AES)

/*!
 * @brief AES128编解码
 * @discussion 采用kCCOptionPKCS7Padding方式编解码
 * @param operation 编解码操作
 * @param key 编解码密钥，要求长度为16位
 * @param iv 初始向量，要求长度为16位
 * @result 编解码后的数据
 */
- (NSData *)dataByAddingAES128CryptingByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv;

/*!
 * @brief AES256编解码
 * @discussion 采用kCCOptionPKCS7Padding方式编解码
 * @param operation 编解码操作
 * @param key 编解码密钥，要求长度为32位
 * @param iv 初始向量，要求长度为16位
 * @result 编解码后的数据
 */
- (NSData *)dataByAddingAES256CryptingByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv;

@end
