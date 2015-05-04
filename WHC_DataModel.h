//
//  WHC_DataModel.h
//  WHC_DataModel
//
//  Created by 吴海超 on 15/4/29.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import <Foundation/Foundation.h>

@interface WHC_DataModel : NSObject

+ (NSArray*)dataModelWithArray:(NSArray*)array className:(Class)className;
+ (id)dataModelWithDictionary:(NSDictionary*)dictionary className:(Class)className;

@end
