//
//  WHC_DataModel.h
//  WHC_DataModel
//
//  Created by 吴海超 on 15/4/29.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/* WHC_DataModel 功能说明:
 * 1.支持json到模型对象
 * 2.支持模型对象到json的转换
 * 3.同时支持json和模型对象的无限嵌套
 * 4.解析效率高
 */

/*
 *  qq:712641411
 *  iOS群: 302157745
 *  gitHub:https://github.com/netyouli/WHC_DataModel
 */

#import <Foundation/Foundation.h>

@interface WHC_DataModel : NSObject

#pragma mark - json转模型对象 Api -

/** 说明: 把json数组对象解析为className对象模型数组
 *@param array:json数组对象
 *@param className:对象模型类
 *@return className对象模型数组
 */
+ (NSArray*)dataModelWithArray:(NSArray*)array className:(Class)className;

/** 说明:把json字典对象解析为className对象
 *@param dictionary:json字典对象
 *@param className:对象模型类
 *@return className对象
 */
+ (id)dataModelWithDictionary:(NSDictionary*)dictionary className:(Class)className;

/** 说明 该方法已废弃请使用: dataModelWithJsonData
 *@param data 数组数据对象
 *@param className:对象模型类
 * 功能说明:把json数组对象解析为className对象模型数组
 *@return className对象模型数组
 */
+ (NSArray *)dataModelWithArrayData:(NSData *)data className:(Class)className NS_DEPRECATED_IOS(2_0, 5_0);

/** 说明 该方法已废弃请使用: dataModelWithJsonData
 *@param data :字典数据对象
 *@param className:对象模型类
 * 功能说明:把json字典对象解析为className对象
 *@return className对象
 */
+ (id)dataModelWithDictionaryData:(NSData *)data className:(Class)className NS_DEPRECATED_IOS(2_0, 5_0);

/** 说明:把json解析为className对象
 *@param json :json 字符串
 *@param className:对象模型类
 *@return className对象
 */
+ (id)dataModelWithJson:(NSString *)json className:(Class)className;

/** 说明:把json解析为className对象
 *@param jsonData :jsonData json数据对象
 *@param className:对象模型类
 *@return className对象
 */
+ (id)dataModelWithJsonData:(NSData *)jsonData className:(Class)className;

#pragma mark - 模型对象转json Api -

/** 说明:把模型对象转换为json字典
 *@param model: 模型对象
 *@return json字典
 */

+ (NSDictionary *)jsonDictionaryWithDataModel:(NSObject *)model;

/** 说明:把模型对象转换为json字符串
 *@param model: 模型对象
 *@return json字符串
 */

+ (NSString *)jsonWithDataModel:(NSObject *)model;
@end
