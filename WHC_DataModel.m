//
//  WHC_DataModel.m
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

#import "WHC_DataModel.h"
#import <objc/runtime.h>
#define kWHCKey    (@"")

@implementation WHC_DataModel

#pragma mark - json转模型对象 Api -
+ (NSArray *)dataModelWithArrayData:(NSData *)data className:(Class)className{
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return [WHC_DataModel dataModelWithArray:array className:className];
}

+ (NSArray*)dataModelWithArray:(NSArray*)array className:(Class)className{
    NSMutableArray * _array = [NSMutableArray new];
    for (NSDictionary * dict in array) {
        [_array addObject:[WHC_DataModel dataModelWithDictionary:dict className:className]];
    }
    return _array;
}

+ (id)dataModelWithDictionary:(NSDictionary*)dictionary className:(Class)className{
    WHC_DataModel  * whcDataModel = [WHC_DataModel new];
    id object = [whcDataModel handleDataModelEngine:dictionary arrKey:kWHCKey calssName:className];
    return object;
}

+ (id)dataModelWithDictionaryData:(NSData *)data className:(Class)className{
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return [WHC_DataModel dataModelWithDictionary:dict className:className];
}

+ (id)dataModelWithJson:(NSString *)json className:(Class)className {
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [self dataModelWithJsonData:jsonData className:className];
}

+ (id)dataModelWithJsonData:(NSData *)jsonData className:(Class)className {
    NSObject * object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if ([object isKindOfClass:[NSArray class]]) {
        return [self dataModelWithArray:(NSArray *)object className:className];
    }
    return [self dataModelWithDictionary:(NSDictionary *)object className:className];
}

#pragma mark - 模型对象转json Api -
+ (NSString *)jsonWithDataModel:(NSObject *)model {
    NSDictionary * jsonDictionary = [self jsonDictionaryWithDataModel:model];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)jsonDictionaryWithDataModel:(NSObject *)model {
    NSMutableDictionary * jsonDictionary = [NSMutableDictionary dictionary];
    if (model == nil) return jsonDictionary;
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([model class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString * propertyName = [NSString stringWithUTF8String:name];
        
        const char * propertyAttributes = property_getAttributes(property);
        NSString * attributesString = [NSString stringWithUTF8String:propertyAttributes];
        NSArray * attributesArray = [attributesString componentsSeparatedByString:@"\""];
        if (attributesArray.count == 1) {
            id value = [model valueForKey:propertyName];
            [jsonDictionary setObject:value forKey:propertyName];
        }else {
            Class classType = NSClassFromString(attributesArray[1]);
            if (classType == [NSString class]) {
                NSString * value = [model valueForKey:propertyName];
                if (value == nil) value = @"";
                [jsonDictionary setObject:value forKey:propertyName];
            }else if (classType == [NSNumber class]) {
                NSNumber * value = [model valueForKey:propertyName];
                if (value == nil) value = @(0);
                [jsonDictionary setObject:value forKey:propertyName];
            }else if (classType == [NSDictionary class]) {
                NSDictionary * value = [model valueForKey:propertyName];
                if (value == nil) value = @{};
                NSArray * allKey = value.allKeys;
                if (allKey.count == 0) {
                    [jsonDictionary setObject:value forKey:propertyName];
                }else {
                    [jsonDictionary setObject:[self parserDictionaryEngine:value] forKey:propertyName];
                }
            }else if (classType == [NSArray class]) {
                NSArray * value = [model valueForKey:propertyName];
                if (value == nil) value = @[];
                if (value.count == 0) {
                    [jsonDictionary setObject:value forKey:propertyName];
                }else {
                    [jsonDictionary setObject:[self parserArrayEngine:value] forKey:propertyName];
                }
            }else {
                id value = [model valueForKey:propertyName];
                if (value == nil) {
                    value = [classType new];
                }
                [jsonDictionary setObject:[self jsonDictionaryWithDataModel:value] forKey:propertyName];
            }
        }
    }
    free(properties);
    return jsonDictionary;
}

#pragma mark - 模型对象转json解析引擎(private) -

+ (NSDictionary *)parserDictionaryEngine:(NSDictionary *)value {
    NSMutableDictionary * subJsonDictionary = [NSMutableDictionary dictionary];
    NSArray * allKey = value.allKeys;
    for (NSString * key in allKey) {
        id subValue = value[key];
        if ([subValue isKindOfClass:[NSString class]] ||
            [subValue isKindOfClass:[NSNumber class]]) {
            [subJsonDictionary setObject:subValue forKey:key];
        }else if ([subValue isKindOfClass:[NSDictionary class]]){
            [subJsonDictionary setObject:[self parserDictionaryEngine:subValue] forKey:key];
        }else if ([subValue isKindOfClass:[NSArray class]]) {
            [subJsonDictionary setObject:[self parserArrayEngine:subValue] forKey:key];
        }else {
            [subJsonDictionary setObject:[self jsonDictionaryWithDataModel:subValue] forKey:key];
        }
    }
    return subJsonDictionary;
}

+ (NSArray *)parserArrayEngine:(NSArray *)value {
    NSMutableArray * subJsonArray = [NSMutableArray array];
    for (id subValue in subJsonArray) {
        if ([subValue isKindOfClass:[NSString class]] ||
            [subValue isKindOfClass:[NSNumber class]]) {
            [subJsonArray addObject:subValue];
        }else if ([subValue isKindOfClass:[NSDictionary class]]){
            [subJsonArray addObject:[self parserDictionaryEngine:subValue]];
        }else if ([subValue isKindOfClass:[NSArray class]]) {
            [subJsonArray addObject:[self parserArrayEngine:subValue]];
        }else {
            [subJsonArray addObject:[self jsonDictionaryWithDataModel:subValue]];
        }
    }
    return subJsonArray;
}

#pragma mark - json转模型对象解析引擎(private) -

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

- (NSString *)existproperty:(NSString *)property withObject:(NSObject *)object{
    unsigned int  propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property_t = properties[i];
        const char * name = property_getName(property_t);
        NSString * nameString = [NSString stringWithUTF8String:name];
        if ([nameString.lowercaseString isEqualToString:property.lowercaseString]) {
            free(properties);
            return nameString;
        }
    }
    free(properties);
    return nil;
}

- (Class)classExistProperty:(NSString *)property withObject:(NSObject *)object{
    if (property != nil && property.length > 0) {
        unsigned int  propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property_t = properties[i];
            const char * name = property_getName(property_t);
            NSString * nameStr = [NSString stringWithUTF8String:name];
            if ([nameStr.lowercaseString isEqualToString:property.lowercaseString]) {
                const char * attributes = property_getAttributes(property_t);
                NSString * attr = [NSString stringWithUTF8String:attributes];
                NSArray * arrayString = [attr componentsSeparatedByString:@"\""];
                free(properties);
                return NSClassFromString(arrayString[1]);
            }
        }
        free(properties);
    }
    return [NSNull class];
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
                    NSString * actualProperty = [self existproperty:keyArr[i] withObject:modelObject];
                    if (actualProperty != nil) {
                        if([self classExistProperty:keyArr[i] withObject:modelObject] == [NSDictionary class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@{} forKey:actualProperty];
                            }else{
                                id subModelObject = [self handleDataModelEngine:subObject arrKey:keyArr[i] calssName:objc_getClass([keyArr[i] UTF8String])];
                                [modelObject setValue:subModelObject forKey:actualProperty];
                            }
                        }else if ([self classExistProperty:keyArr[i] withObject:modelObject] == [NSArray class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@[] forKey:actualProperty];
                            }else{
                                id subModelObject = [self handleDataModelEngine:subObject arrKey:keyArr[i] calssName:objc_getClass([keyArr[i] UTF8String])];
                                NSString * actualProperty = [self existproperty:keyArr[i] withObject:modelObject];
                                [modelObject setValue:[subModelObject mutableCopy] forKey:actualProperty];
                            }
                        }else if ([self classExistProperty:keyArr[i] withObject:modelObject] == [NSString class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@"" forKey:actualProperty];
                            }else{
                                [modelObject setValue:subObject forKey:actualProperty];
                            }
                        }else if ([self classExistProperty:keyArr[i] withObject:modelObject] == [NSNumber class]){
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@(0) forKey:actualProperty];
                            }else{
                                [modelObject setValue:subObject forKey:actualProperty];
                            }
                        }else{
                            if(subObject && ![subObject isKindOfClass:[NSNull class]]){
                                Class class = [self classExistProperty:keyArr[i] withObject:modelObject];
                                if (class != [NSNull class]) {
                                    id subModelObject = [self handleDataModelEngine:subObject arrKey:keyArr[i] calssName:class];
                                        [modelObject setValue:subModelObject forKey:actualProperty];
                                }
                            }else{
                                [modelObject setValue:@"" forKey:actualProperty];
                            }
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
                if(subModelObject){
                    [modelObjectArr addObject:subModelObject];
                }
            }
            modelObject = nil;
            return modelObjectArr;
        }else if([object isKindOfClass:[NSString class]]){
            if(object){
                return object;
            }else{
                return @"";
            }
        }else if([object isKindOfClass:[NSNumber class]]){
            if(object){
                return object;
            }else{
                return @(0);
            }
        }else{
            unsigned int propertyCount = 0;
            objc_property_t  * propertys = class_copyPropertyList(className, &propertyCount);
            for (int i = 0; i < propertyCount; i++) {
                NSString * propertyName = @(property_getName(propertys[i]));
                NSString * classType = [self getClassNameString:property_getAttributes(propertys[i])];
                if (propertyName != nil) {
                    if(classType){
                        Class propertyClass = objc_getClass([classType UTF8String]);
                        if(propertyClass == [NSDictionary class]){
                            id subObject = [object objectForKey:propertyName];
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@{} forKey:propertyName];
                            }else{
                                id subModelObject = [self handleDataModelEngine:subObject arrKey:propertyName calssName:objc_getClass([propertyName UTF8String])];
                                [modelObject setValue:subModelObject forKey:propertyName];
                            }
                        }else if (propertyClass == [NSArray class]){
                            id subObject = [object objectForKey:propertyName];
                            if([subObject isKindOfClass:[NSNull class]]){
                                [modelObject setValue:@[] forKey:propertyName];
                            }else{
                                id subModelObject = [self handleDataModelEngine:subObject arrKey:propertyName calssName:objc_getClass([arrKey UTF8String])];
                                [modelObject setValue:subModelObject forKey:propertyName];
                            }
                        }else if(propertyClass == [NSString class] ||
                                 propertyClass == [NSNumber class]){
                            id value = [object objectForKey:propertyName];
                            if(value && ![value isKindOfClass:[NSNull class]]){
                                [modelObject setValue:value forKey:propertyName];
                            }else{
                                if([value isKindOfClass:[NSString class]]){
                                    [modelObject setValue:@"" forKey:propertyName];
                                }else{
                                    [modelObject setValue:@(0) forKey:propertyName];
                                }
                            }
                        }else if (propertyClass == objc_getClass([propertyName UTF8String])){
                            Class class = objc_getClass([propertyName UTF8String]);
                            id subObject = [object objectForKey:propertyName];
                            if(subObject && ![subObject isKindOfClass:[NSNull class]]){
                                id subModelObject = [self handleDataModelEngine:subObject arrKey:propertyName calssName:class];
                                [modelObject setValue:subModelObject forKey:propertyName];
                            }else{
                                [modelObject setValue:[objc_getClass([propertyName UTF8String]) new] forKey:propertyName];
                            }
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
