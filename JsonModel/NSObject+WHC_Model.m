//
//  NSObject+WHC_Model.m
//  JsonModel<https://github.com/netyouli/WHC_DataModel>
//
//  Created by WHC on 16/7/13.
//  Copyright © 2016年 whc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// VERSION:(2.0)

#import "NSObject+WHC_Model.h"
#import <objc/runtime.h>
#import <objc/message.h>
#define kWHCKey    (@"")

typedef NS_OPTIONS(NSUInteger, WHC_TYPE) {
    _Array = 1 << 0,
    _Dictionary = 1 << 1,
    _String = 1 << 2,
    _Integer = 1 << 3,
    _UInteger = 1 << 4,
    _Float = 1 << 5,
    _Double = 1 << 6,
    _Boolean = 1 << 7,
    _Char = 1 << 8,
    _Number = 1 << 9,
    _Null = 1 << 10,
    _Model = 1 << 11
};

@interface WHC_ModelInfo : NSObject
@property (nonatomic, copy)Class  class;
@property (nonatomic, assign) WHC_TYPE type;
@end
@implementation WHC_ModelInfo

- (void)setClass:(Class)class {
    _class = class;
    if (class == [NSDictionary class]) {_type = _Dictionary;}
    else if (class == [NSArray class]) {_type = _Array;}
    else if (class == [NSString class]) {_type = _String;}
    else if (class == [NSNumber class]) {_type = _Number;}
    else { _type = _Model;}
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = _Null;
    }
    return self;
}

@end

@implementation NSObject (WHC_Model)
#pragma mark - json转模型对象 Api -
+ (NSArray *)modelWithArrayData:(NSData *)data {
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return [self modelWithArray:array];
}

+ (NSArray *)modelWithArray:(NSArray*)array {
    return [self modelWithArray:array classPrefix:kWHCKey];
}

+ (NSArray*)modelWithArray:(NSArray*)array classPrefix:(NSString *)prefix {
    NSMutableArray * _array = [NSMutableArray new];
    for (id object in array) {
        if ([object isKindOfClass:[NSArray class]]) {
            [_array addObject:[self modelWithArray:object classPrefix:prefix]];
        }else {
            [_array addObject:[self handleDataModelEngine:object calss:self classPrefix:prefix]];
        }
    }
    return _array;
}

+ (id)modelWithDictionary:(NSDictionary*)dictionary classPrefix:(NSString *)prefix {
    id object = [self handleDataModelEngine:dictionary calss:self classPrefix:prefix];
    return object;
}

+ (id)modelWithDictionary:(NSDictionary*)dictionary {
    return [self modelWithDictionary:dictionary classPrefix:kWHCKey];
}

+ (id)modelWithJson:(NSString *)json {
    return [self modelWithJson:json classPrefix:kWHCKey];
}

+ (id)modelWithJson:(NSString *)json classPrefix:(NSString *)prefix {
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [self modelWithJsonData:jsonData classPrefix:prefix];
}

+ (id)modelWithJsonData:(NSData *)data {
    return [self modelWithJsonData:data classPrefix:kWHCKey];
}

+ (id)modelWithJsonData:(NSData *)jsonData classPrefix:(NSString *)prefix {
    NSObject * object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if ([object isKindOfClass:[NSArray class]]) {
        return [self modelWithArray:(NSArray *)object classPrefix:prefix];
    }
    return [self modelWithDictionary:(NSDictionary *)object classPrefix:prefix];
}

#pragma mark - 模型对象转json Api -

- (NSString *)json {
    NSDictionary * jsonDictionary = [self dictionary];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionary {
    NSMutableDictionary * jsonDictionary = [NSMutableDictionary dictionary];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString * propertyName = [NSString stringWithUTF8String:name];
        
        const char * propertyAttributes = property_getAttributes(property);
        NSString * attributesString = [NSString stringWithUTF8String:propertyAttributes];
        NSArray * attributesArray = [attributesString componentsSeparatedByString:@"\""];
        if (attributesArray.count == 1) {
            id value = [self valueForKey:propertyName];
            [jsonDictionary setObject:value forKey:propertyName];
        }else {
            Class classType = NSClassFromString(attributesArray[1]);
            if (classType == [NSString class]) {
                NSString * value = [self valueForKey:propertyName];
                if (value == nil) value = @"";
                [jsonDictionary setObject:value forKey:propertyName];
            }else if (classType == [NSNumber class]) {
                NSNumber * value = [self valueForKey:propertyName];
                if (value == nil) value = @(0);
                [jsonDictionary setObject:value forKey:propertyName];
            }else if (classType == [NSDictionary class]) {
                NSDictionary * value = [self valueForKey:propertyName];
                if (value == nil) value = @{};
                NSArray * allKey = value.allKeys;
                if (allKey.count == 0) {
                    [jsonDictionary setObject:value forKey:propertyName];
                }else {
                    [jsonDictionary setObject:[self parserDictionaryEngine:value] forKey:propertyName];
                }
            }else if (classType == [NSArray class]) {
                NSArray * value = [self valueForKey:propertyName];
                if (value == nil) value = @[];
                if (value.count == 0) {
                    [jsonDictionary setObject:value forKey:propertyName];
                }else {
                    [jsonDictionary setObject:[self parserArrayEngine:value] forKey:propertyName];
                }
            }else {
                id value = [self valueForKey:propertyName];
                if (value == nil) {
                    value = [classType new];
                }
                [jsonDictionary setObject:[value dictionary] forKey:propertyName];
            }
        }
    }
    free(properties);
    return jsonDictionary;
}

#pragma mark - 模型对象转json解析引擎(private) -

- (NSDictionary *)parserDictionaryEngine:(NSDictionary *)value {
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
            [subJsonDictionary setObject:[subValue dictionary] forKey:key];
        }
    }
    return subJsonDictionary;
}

- (NSArray *)parserArrayEngine:(NSArray *)value {
    NSMutableArray * subJsonArray = [NSMutableArray array];
    for (id subValue in value) {
        if ([subValue isKindOfClass:[NSString class]] ||
            [subValue isKindOfClass:[NSNumber class]]) {
            [subJsonArray addObject:subValue];
        }else if ([subValue isKindOfClass:[NSDictionary class]]){
            [subJsonArray addObject:[self parserDictionaryEngine:subValue]];
        }else if ([subValue isKindOfClass:[NSArray class]]) {
            [subJsonArray addObject:[self parserArrayEngine:subValue]];
        }else {
            [subJsonArray addObject:[subValue dictionary]];
        }
    }
    return subJsonArray;
}

#pragma mark - json转模型对象解析引擎(private) -

+ (WHC_TYPE)getTypeProperty:(const char *)attributes {
    NSString * attr = [NSString stringWithUTF8String:attributes];
    NSArray * arrayString = [attr componentsSeparatedByString:@"\""];
    if (arrayString.count == 1) {
        return [self parserTypeWithAttr:arrayString[0]];
    }else {
        Class class = NSClassFromString(arrayString[1]);
        if (class == [NSDictionary class]) return _Dictionary;
        if (class == [NSArray class]) return _Array;
        if (class == [NSString class]) return _String;
        if (class == [NSNumber class]) return _Number;
    }
    return _Null;
}

+ (NSString *)existproperty:(NSString *)property withObject:(NSObject *)object {
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

+ (WHC_TYPE)parserTypeWithAttr:(NSString *)attr {
    NSArray * sub_attrs = [attr componentsSeparatedByString:@","];
    NSString * first_sub_attr = sub_attrs.firstObject;
    first_sub_attr = [first_sub_attr substringFromIndex:1];
    WHC_TYPE attr_type = _Null;
    const char type = *[first_sub_attr UTF8String];
    switch (type) {
        case 'B':
            attr_type = _Boolean;
            break;
        case 'c':
        case 'C':
            attr_type = _Char;
            break;
        case 'S':
        case 'I':
        case 'L':
        case 'Q':
            attr_type = _UInteger;
        case 'l':
        case 'q':
        case 'i':
        case 's':
            attr_type = _Integer;
            break;
        case 'f':
            attr_type = _Float;
            break;
        case 'd':
        case 'D':
            attr_type = _Double;
            break;
        default:
            break;
    }
    return attr_type;
}

+ (WHC_ModelInfo *)classExistProperty:(NSString *)property withObject:(NSObject *)object {
    WHC_ModelInfo * modelInfo = [WHC_ModelInfo new];
    if (property != nil && property.length > 0) {
        modelInfo.type = _Model;
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
                if (arrayString.count == 1) {
                    modelInfo.type = [self parserTypeWithAttr:arrayString[0]];
                }else {
                    modelInfo.class = NSClassFromString(arrayString[1]);
                }
                return modelInfo;
            }
        }
        free(properties);
    }
    return modelInfo;
}

+ (id)handleDataModelEngine:(id)object calss:(Class)class classPrefix:(NSString *)prefix {
    if(object) {
        id  modelObject = [class new];
        if([object isKindOfClass:[NSDictionary class]]){
            NSDictionary  * dict = object;
            NSInteger       count = dict.count;
            NSArray       * keyArr = [dict allKeys];
            for (NSInteger i = 0; i < count; i++) {
                id subObject = dict[keyArr[i]];
                if(subObject){
                    NSString * actualProperty = [self existproperty:keyArr[i] withObject:modelObject];
                    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",[actualProperty substringToIndex:1].uppercaseString, [actualProperty substringFromIndex:1]]);
                    if (actualProperty != nil) {
                        WHC_ModelInfo * modelInfo = [self classExistProperty:keyArr[i] withObject:modelObject];
                        switch (modelInfo.type) {
                            case _Array:
                                if([subObject isKindOfClass:[NSNull class]]){
                                    [modelObject setValue:@[] forKey:actualProperty];
                                }else{
                                    NSString * className =  keyArr[i];
                                    Class subModelClass = NSClassFromString(className);
                                    if (subModelClass == nil) {
                                        NSString * first = [className substringToIndex:1];
                                        NSString * other = [className substringFromIndex:1];
                                        if (prefix.length > 0) {
                                            subModelClass = NSClassFromString([NSString stringWithFormat:@"%@%@%@",prefix,[first uppercaseString],other]);
                                            if (subModelClass == nil) {
                                                subModelClass = NSClassFromString([NSString stringWithFormat:@"%@%@",prefix,className]);
                                            }
                                        }else {
                                            subModelClass = NSClassFromString([NSString stringWithFormat:@"%@%@",[first uppercaseString],other]);
                                            if (subModelClass == nil) {
                                                subModelClass = NSClassFromString([NSString stringWithFormat:@"%@",className]);
                                            }
                                        }
                                    }
                                    if (subModelClass) {
                                        id subModelObject = [self handleDataModelEngine:subObject calss:subModelClass classPrefix:prefix];
                                        NSString * actualProperty = [self existproperty:keyArr[i] withObject:modelObject];
                                        [modelObject setValue:[subModelObject mutableCopy] forKey:actualProperty];
                                    }
                                }
                                break;
                            case _String:
                                if([subObject isKindOfClass:[NSNull class]]){
                                    [modelObject setValue:@"" forKey:actualProperty];
                                }else{
                                    [modelObject setValue:subObject forKey:actualProperty];
                                }
                                break;
                            case _Number:
                                if([subObject isKindOfClass:[NSNull class]]){
                                    [modelObject setValue:@(0) forKey:actualProperty];
                                }else{
                                    [modelObject setValue:subObject forKey:actualProperty];
                                }
                                break;
                            case _Integer:
                                ((void (*)(id, SEL, NSInteger))(void *) objc_msgSend)((id)modelObject, setter, [subObject integerValue]);
                                break;
                            case _UInteger:
                                ((void (*)(id, SEL, NSUInteger))(void *) objc_msgSend)((id)modelObject, setter, [subObject unsignedIntegerValue]);
                                break;
                            case _Boolean:
                                ((void (*)(id, SEL, BOOL))(void *) objc_msgSend)((id)modelObject, setter, [subObject boolValue]);
                                break;
                            case _Float:
                                ((void (*)(id, SEL, CGFloat))(void *) objc_msgSend)((id)modelObject, setter, [subObject floatValue]);
                                break;
                            case _Double:
                                ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)modelObject, setter, [subObject doubleValue]);
                                break;
                            case _Char:
                                ((void (*)(id, SEL, char))(void *) objc_msgSend)((id)modelObject, setter, [subObject charValue]);
                                break;
                            case _Model: {
                                id subModelObject = [self handleDataModelEngine:subObject calss:modelInfo.class classPrefix:prefix];
                                [modelObject setValue:subModelObject forKey:actualProperty];
                            }
                                break;
                            default:
                                
                                break;
                        }
                    }
                }
            }
            return modelObject;
        }else if ([object isKindOfClass:[NSArray class]]){
            NSArray  * objectArr = object;
            NSInteger  count = objectArr.count;
            NSMutableArray  * modelObjectArr = [NSMutableArray new];
            for (NSInteger i = 0; i < count; i++) {
                id subModelObject = [self handleDataModelEngine:objectArr[i] calss:class classPrefix:prefix];
                if(subModelObject){
                    [modelObjectArr addObject:subModelObject];
                }
            }
            modelObject = nil;
            return modelObjectArr;
        }
    }
    return nil;
}

@end
