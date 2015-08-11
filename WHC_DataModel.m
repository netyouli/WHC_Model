//
//  WHC_DataModel.m
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

#import "WHC_DataModel.h"
#import <objc/runtime.h>
@interface WHC_DataModel (){
    
}

@end
@implementation WHC_DataModel

- (instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
/*参数说明
 array:json数组对象
 className:对象模型类
 功能说明:把json数组对象解析为className对象模型数组
 返回className对象模型数组
 */
+ (NSArray*)dataModelWithArray:(NSArray*)array className:(Class)className{
    NSMutableArray * _array = [NSMutableArray new];
    for (NSDictionary * dict in array) {
        [_array addObject:[WHC_DataModel dataModelWithDictionary:dict className:className]];
    }
    return _array;
}

/*参数说明
 dictionary:json字典对象
 className:对象模型类
 功能说明:把json字典对象解析为className对象
 返回className对象
 */
+ (id)dataModelWithDictionary:(NSDictionary*)dictionary className:(Class)className{
    WHC_DataModel  * whcDataModel = [WHC_DataModel new];
    id object = [whcDataModel handleDataModelEngine:dictionary arrKey:@"" calssName:className];
    return object;
}

- (NSString *)getClassNameString:(const char *)attr{
    NSString * strClassName = nil;
    NSString * attrStr = @(attr);
    NSRange  oneRange = [attrStr rangeOfString:@"T@\""];
    if(oneRange.location != NSNotFound){
        NSRange twoRange = [attrStr rangeOfString:@"\"" options:NSBackwardsSearch];
        if(twoRange.location != NSNotFound){
            NSRange  classRange = NSMakeRange(oneRange.location + oneRange.length, twoRange.location - (oneRange.location + oneRange.length));
            strClassName = [attrStr substringWithRange:classRange];
        }
    }
    return strClassName;
}

- (id)handleDataModelEngine:(id)object arrKey:(NSString*)arrKey calssName:(Class)className{
    if(object){
        id  modelObject = [className new];
        if([object isKindOfClass:[NSDictionary class]]){
            NSDictionary  * dict = object;
            NSInteger       count = dict.count;
            NSArray       * keyArr = [dict allKeys];
            for (NSInteger i = 0; i < count; i++) {
                id subObject = dict[keyArr[i]];
                if(subObject){
                    if([subObject isKindOfClass:[NSDictionary class]]){
                        id subModelObject = [self handleDataModelEngine:subObject arrKey:keyArr[i] calssName:objc_getClass([keyArr[i] UTF8String])];
                        [modelObject setValue:subModelObject forKey:keyArr[i]];
                    }else if ([subObject isKindOfClass:[NSArray class]]){
                        id subModelObject = [self handleDataModelEngine:subObject arrKey:keyArr[i] calssName:objc_getClass([keyArr[i] UTF8String])];
                        [modelObject setValue:[subModelObject mutableCopy] forKey:keyArr[i]];
                    }else if ([subObject isKindOfClass:[NSString class]] ||
                              [subObject isKindOfClass:[NSNumber class]]){
                        if(subObject){
                            [modelObject setValue:subObject forKey:keyArr[i]];
                        }else{
                            [modelObject setValue:@"" forKey:keyArr[i]];
                        }
                    }else{
                        
                        if(subObject && ![subObject isKindOfClass:[NSNull class]]){
                            id subModelObject = [self handleDataModelEngine:subObject arrKey:keyArr[i] calssName:objc_getClass([keyArr[i] UTF8String])];
                            [modelObject setValue:subModelObject forKey:keyArr[i]];
                        }else{
                            [modelObject setValue:@"" forKey:keyArr[i]];
                        }
                    }
                }
            }
        }else if ([object isKindOfClass:[NSArray class]]){
            NSArray  * objectArr = object;
            NSInteger  count = objectArr.count;
            NSMutableArray  * modelObjectArr = [NSMutableArray new];
            for (NSInteger i = 0; i < count; i++) {
                id subModelObject = [self handleDataModelEngine:objectArr[i] arrKey:arrKey calssName:objc_getClass([arrKey UTF8String])];
                [modelObjectArr addObject:subModelObject];
            }
            modelObject = nil;
            return modelObjectArr;
        }else{
            unsigned int propertyCount = 0;
            objc_property_t  * propertys = class_copyPropertyList(className, &propertyCount);
            for (int i = 0; i < propertyCount; i++) {
                NSString * propertyName = @(property_getName(propertys[i]));
                NSString * classType = [self getClassNameString:property_getAttributes(propertys[i])];
                if(classType){
                    Class propertyClass = objc_getClass([classType UTF8String]);
                    if(
                       propertyClass == [NSDictionary class]){
                        id subObject = [object objectForKey:propertyName];
                        id subModelObject = [self handleDataModelEngine:subObject arrKey:propertyName calssName:objc_getClass([propertyName UTF8String])];
                        [modelObject setValue:subModelObject forKey:propertyName];
                    }else if (propertyClass == [NSArray class]){
                        id subObject = [object objectForKey:propertyName];
                        id subModelObject = [self handleDataModelEngine:subObject arrKey:propertyName calssName:objc_getClass([arrKey UTF8String])];
                        [modelObject setValue:subModelObject forKey:propertyName];
                    }else if(propertyClass == [NSString class] ||
                             propertyClass == [NSNumber class]){
                        id value = [object objectForKey:propertyName];
                        if(value && ![value isKindOfClass:[NSNull class]]){
                            [modelObject setValue:value forKey:propertyName];
                        }else{
                            [modelObject setValue:@"" forKey:propertyName];
                        }
                    }else if (propertyClass == objc_getClass([propertyName UTF8String])){
                        id subObject = [object objectForKey:propertyName];
                        if(subObject && ![subObject isKindOfClass:[NSNull class]]){
                            id subModelObject = [self handleDataModelEngine:subObject arrKey:propertyName calssName:objc_getClass([propertyName UTF8String])];
                            [modelObject setValue:subModelObject forKey:propertyName];
                        }else{
                            [modelObject setValue:@"" forKey:propertyName];
                        }
                    }
                }
            }
        }
        return modelObject;
    }else{
        NSLog(@"有object = nil");
    }
    return nil;
}
@end
