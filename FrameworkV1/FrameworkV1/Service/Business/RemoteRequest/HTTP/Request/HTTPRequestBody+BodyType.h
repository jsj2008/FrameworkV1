//
//  HTTPRequestBody+BodyType.h
//  FrameworkV1
//
//  Created by ww on 16/5/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestBody.h"
#import "HTTPMultipartFormEntity.h"

/*********************************************************
 
    @category
        HTTPRequestBody (BodyType)
 
    @abstract
        HTTP请求体的分类扩展，提供各种数据类型的请求体
 
 *********************************************************/

@interface HTTPRequestBody (BodyType)

/*!
 * @brief 参数请求体
 * @param parameters 参数字体（未编码）
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithParameters:(NSDictionary<NSString *, NSString *> *)parameters;

/*!
 * @brief json数据请求体
 * @param jsonNode json节点
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithJsonNode:(id)jsonNode;

/*!
 * @brief 多表单数据请求体
 * @param entity 多表单数据
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithMultipartFormEntity:(HTTPMultipartFormEntity *)entity;

@end
