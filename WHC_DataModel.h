//
//  WHC_DataModel.h
//  WHC_DataModel
//
//  Created by 吴海超 on 15/4/29.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  iOS大神qq群:460122071
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import <Foundation/Foundation.h>

@interface WHC_DataModel : NSObject

/*参数说明
 array:json数组对象
 className:对象模型类
 功能说明:把json数组对象解析为className对象模型数组
 返回className对象模型数组
*/
+ (NSArray*)dataModelWithArray:(NSArray*)array className:(Class)className;

/*参数说明
 dictionary:json字典对象
 className:对象模型类
 功能说明:把json字典对象解析为className对象
 返回className对象
 */
+ (id)dataModelWithDictionary:(NSDictionary*)dictionary className:(Class)className;

@end
