//
//  NSObject+WHC_Model.m
//  WHC_Model<https://github.com/netyouli/WHC_DataModel>
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

// VERSION:(1.1.0)

#import "NSObject+WHC_Model.h"
#import <objc/runtime.h>
#import <objc/message.h>
#define kWHCKey    (@"")

static NSMutableDictionary * modelInfo;

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
    _Model = 1 << 11,
    _Data = 1 << 12
};

@interface WHC_ModelInfo : NSObject
@property (nonatomic, copy)Class  class;
@property (nonatomic, assign) WHC_TYPE type;
@end
@implementation WHC_ModelInfo

- (void)setClass:(Class)class {
    _class = class;
    if (class == [NSString class]) {_type = _String;}
    else if (class == [NSDictionary class]) {_type = _Dictionary;}
    else if (class == [NSArray class]) {_type = _Array;}
    else if (class == [NSNumber class]) {_type = _Number;}
    else if (class == [NSData class]) {_type = _Data;}
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
+ (NSArray *)whc_ModelWithArrayData:(NSData *)data {
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return [self whc_ModelWithArray:array];
}

+ (NSArray *)whc_ModelWithArray:(NSArray*)array {
    return [self whc_ModelWithArray:array classPrefix:kWHCKey];
}

+ (NSArray*)whc_ModelWithArray:(NSArray*)array classPrefix:(NSString *)prefix {
    NSMutableArray * _array = [NSMutableArray new];
    for (id object in array) {
        if ([object isKindOfClass:[NSArray class]]) {
            [_array addObject:[self whc_ModelWithArray:object classPrefix:prefix]];
        }else {
            [_array addObject:[self handleDataModelEngine:object class:self classPrefix:prefix]];
        }
    }
    return _array;
}

+ (id)whc_ModelWithDictionary:(NSDictionary*)dictionary classPrefix:(NSString *)prefix {
    id object = [self handleDataModelEngine:dictionary class:self classPrefix:prefix];
    return object;
}

+ (id)whc_ModelWithDictionary:(NSDictionary*)dictionary {
    return [self whc_ModelWithDictionary:dictionary classPrefix:kWHCKey];
}

+ (id)whc_ModelWithJson:(NSString *)json {
    return [self whc_ModelWithJson:json classPrefix:kWHCKey];
}

+ (id)whc_ModelWithJson:(NSString *)json classPrefix:(NSString *)prefix {
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [self whc_ModelWithJsonData:jsonData classPrefix:prefix];
}

+ (id)whc_ModelWithJsonData:(NSData *)data {
    return [self whc_ModelWithJsonData:data classPrefix:kWHCKey];
}

+ (id)whc_ModelWithJsonData:(NSData *)jsonData classPrefix:(NSString *)prefix {
    if (prefix == nil) prefix = kWHCKey;
    NSObject * object = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    if ([object isKindOfClass:[NSArray class]]) {
        return [self whc_ModelWithArray:(NSArray *)object classPrefix:prefix];
    }
    return [self whc_ModelWithDictionary:(NSDictionary *)object classPrefix:prefix];
}

+ (id)whc_ModelWithJsonData:(NSData *)jsonData keyPath:(NSString *)keyPath {
    if (keyPath != nil && keyPath.length > 0) {
        __block id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        NSArray<NSString *> * keyPathArray = [keyPath componentsSeparatedByString:@"."];
        [keyPathArray enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [key rangeOfString:@"["];
            if (range.location != NSNotFound) {
                NSString * realKey = [key substringToIndex:range.location];
                jsonObject = jsonObject[realKey];
                if (jsonObject != nil) {
                    NSString * indexString = [key substringFromIndex:range.location];
                    NSString * handleIndexString = [indexString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
                    NSInteger indexLength = handleIndexString.length;
                    for (NSUInteger i = 0; i < indexLength; i++) {
                        NSInteger index = [[handleIndexString substringWithRange:NSMakeRange(i, 1)] integerValue];
                        jsonObject = jsonObject[index];
                    }
                }
            }else {
                jsonObject = jsonObject[key];
            }
        }];
        if (jsonObject) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                return [self whc_ModelWithDictionary:jsonObject];
            }else if ([jsonObject isKindOfClass:[NSArray class]]) {
                return [self whc_ModelWithArray:jsonObject];
            }else {
                return jsonObject;
            }
        }
        return nil;
    }else {
        return [self whc_ModelWithJsonData:jsonData];
    }
}

+ (id)whc_ModelWithJson:(NSString *)json keyPath:(NSString *)keyPath {
    if (keyPath != nil && keyPath.length > 0) {
        NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        return [self whc_ModelWithJsonData:jsonData keyPath:keyPath];
    }else {
        return [self whc_ModelWithJson:json];
    }
}

#pragma mark - 模型对象转json Api -

- (NSString *)whc_Json {
    id jsonSet = nil;
    if ([self isKindOfClass:[NSDictionary class]]) {
        jsonSet = [self parserDictionaryEngine:(NSDictionary *)self];
    }else if ([self isKindOfClass:[NSArray class]]) {
        jsonSet = [self parserArrayEngine:(NSArray *)self];
    }else {
        jsonSet = [self whc_Dictionary];
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonSet options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)whc_Dictionary {
    NSMutableDictionary * jsonDictionary = [NSMutableDictionary dictionary];
    if (self.superclass != nil &&
        self.superclass != [NSObject class]) {
        NSObject * superObject = self.superclass.new;
        unsigned int propertyCount = 0;
        objc_property_t * properties = class_copyPropertyList(self.superclass, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            const char * name = property_getName(property);
            NSString * propertyName = [NSString stringWithUTF8String:name];
            [superObject setValue:[self valueForKey:propertyName] forKey:propertyName];
        }
        [jsonDictionary setDictionary:[superObject whc_Dictionary]];
    }
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
                [jsonDictionary setObject:[value whc_Dictionary] forKey:propertyName];
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
            [subJsonDictionary setObject:[subValue whc_Dictionary] forKey:key];
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
            [subJsonArray addObject:[subValue whc_Dictionary]];
        }
    }
    return subJsonArray;
}

#pragma mark - json转模型对象解析引擎(private) -

static const char  WHC_ModelInfokey = '\0';

+ (WHC_ModelInfo *)getModelInfo:(NSString *)property {
    NSDictionary * propertyInfo = objc_getAssociatedObject(self, &WHC_ModelInfokey);
    WHC_ModelInfo * modelInfo = nil;
    if (propertyInfo != nil) {
        modelInfo = propertyInfo[property];
    }
    return modelInfo;
}

+ (void)setModelInfo:(WHC_ModelInfo *)modelInfo property:(NSString *)property {
    NSMutableDictionary * propertyInfo = objc_getAssociatedObject(self, &WHC_ModelInfokey);
    if (propertyInfo == nil) {
        propertyInfo = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &WHC_ModelInfokey, propertyInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [propertyInfo setObject:modelInfo forKey:property];
}

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
        if (class == [NSData class]) return _Data;
    }
    return _Null;
}

+ (NSString *)existproperty:(NSString *)property withObject:(NSObject *)object {
    objc_property_t property_t = class_getProperty(object.class, [property UTF8String]);
    if (property_t != NULL) {
        const char * name = property_getName(property_t);
        NSString * nameString = [NSString stringWithUTF8String:name];
        return nameString;
    }else {
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
        if (object.superclass && object.superclass != [NSObject class]) {
            NSString * name =  [self existproperty:property withObject:object.superclass.new];
            if (name != nil && name.length > 0) {
                return name;
            }
        }
        return property;
    }
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
    WHC_ModelInfo * modelInfo = nil;
    objc_property_t property_t = class_getProperty(object.class, [property UTF8String]);
    if (property_t != NULL) {
        const char * attributes = property_getAttributes(property_t);
        NSString * attr = [NSString stringWithUTF8String:attributes];
        NSArray * arrayString = [attr componentsSeparatedByString:@"\""];
        modelInfo = [WHC_ModelInfo new];
        if (arrayString.count == 1) {
            modelInfo.type = [self parserTypeWithAttr:arrayString[0]];
        }else {
            modelInfo.class = NSClassFromString(arrayString[1]);
        }
        return modelInfo;
    }else {
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
                modelInfo = [WHC_ModelInfo new];
                if (arrayString.count == 1) {
                    modelInfo.type = [self parserTypeWithAttr:arrayString[0]];
                }else {
                    modelInfo.class = NSClassFromString(arrayString[1]);
                }
                return modelInfo;
            }
        }
        free(properties);
        if (object.superclass && object.superclass != [NSObject class]) {
            modelInfo = [self classExistProperty:property withObject:object.superclass.new];
            if (modelInfo != nil) {
                return modelInfo;
            }
        }
    }
    return modelInfo;
}

+ (id)handleDataModelEngine:(id)object class:(Class)class classPrefix:(NSString *)prefix {
    if (!(prefix != nil && prefix.length > 0)) {
        SEL prefixFunc = NSSelectorFromString(@"prefix");
        if ([class respondsToSelector:prefixFunc]) {
            IMP prefix_func = [class methodForSelector:prefixFunc];
            NSString * (*func)(id, SEL) = (void *)prefix_func;
            prefix = func(class, prefixFunc);
        }
    }
    if(object) {
        if([object isKindOfClass:[NSDictionary class]]){
            NSObject *  modelObject = [class new];
            NSDictionary  * dictionary = object;
            NSArray  *    keyArray = nil;
            unsigned int  propertyCount = 0;
            objc_property_t *properties = NULL;
            if (modelObject.superclass &&
                modelObject.superclass != [NSObject class]) {
                keyArray = dictionary.allKeys;
                propertyCount = (unsigned int)keyArray.count;
            }else {
                properties = class_copyPropertyList(class, &propertyCount);
            }
            for (unsigned int i = 0; i < propertyCount; i++) {
                objc_property_t property_t = NULL;
                NSString * actualProperty = nil;
                if (properties) {
                    property_t = properties[i];
                    actualProperty = [NSString stringWithUTF8String:property_getName(property_t)];
                }else {
                    actualProperty = keyArray[i];
                }
                __block id subObject = dictionary[actualProperty];
                if (subObject == nil) {
                    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key.lowercaseString isEqualToString:actualProperty.lowercaseString]) {
                            *stop = YES;
                            subObject = obj;
                        }
                    }];
                }
                if(subObject) {
                    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",[actualProperty substringToIndex:1].uppercaseString, [actualProperty substringFromIndex:1]]);
                    if (![modelObject respondsToSelector:setter]) {
                        actualProperty = [self existproperty:actualProperty withObject:modelObject];
                        if (actualProperty == nil) continue;
                        setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",[actualProperty substringToIndex:1].uppercaseString, [actualProperty substringFromIndex:1]]);
                    }
                    WHC_ModelInfo * modelInfo;
                    if (properties) {
                        modelInfo = [class getModelInfo:actualProperty];
                        if (modelInfo == nil) {
                            const char * attribute = property_getAttributes(property_t);
                            NSString * attributeName = [NSString stringWithUTF8String:attribute];
                            NSArray * attributeNameComponents = [attributeName componentsSeparatedByString:@"\""];
                            modelInfo = [WHC_ModelInfo new];
                            if (attributeNameComponents.count == 1) {
                                modelInfo.type = [self parserTypeWithAttr:attributeNameComponents[0]];
                            }else {
                                modelInfo.class = NSClassFromString(attributeNameComponents[1]);
                            }
                            [class setModelInfo:modelInfo property:actualProperty];
                        }
                    }else {
                        modelInfo = [self classExistProperty:actualProperty withObject:modelObject];
                        if (modelInfo == nil) continue;
                    }
                    switch (modelInfo.type) {
                        case _Array:
                            if(![subObject isKindOfClass:[NSNull class]]){
                                NSString * className = actualProperty;
                                Class subModelClass = NSClassFromString(className);
                                if (subModelClass == nil || (prefix != nil && prefix.length > 0)) {
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
                                    ((void (*)(id, SEL, NSArray *))(void *) objc_msgSend)((id)modelObject, setter, [self handleDataModelEngine:subObject class:subModelClass classPrefix:prefix]);
                                }else {
                                    ((void (*)(id, SEL, NSArray *))(void *) objc_msgSend)((id)modelObject, setter, subObject);
                                }
                                
                            }else{
                                ((void (*)(id, SEL, NSArray *))(void *) objc_msgSend)((id)modelObject, setter, @[]);
                            }
                            break;
                        case _String:
                            if(![subObject isKindOfClass:[NSNull class]]){
                                ((void (*)(id, SEL, NSString *))(void *) objc_msgSend)((id)modelObject, setter, subObject);
                            }else{
                                ((void (*)(id, SEL, NSString *))(void *) objc_msgSend)((id)modelObject, setter, @"");
                            }
                            break;
                        case _Number:
                            if(![subObject isKindOfClass:[NSNull class]]){
                                ((void (*)(id, SEL, NSNumber *))(void *) objc_msgSend)((id)modelObject, setter, subObject);
                            }else{
                                ((void (*)(id, SEL, NSNumber *))(void *) objc_msgSend)((id)modelObject, setter, @(0));
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
                            ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)modelObject, setter, [subObject floatValue]);
                            break;
                        case _Double:
                            ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)modelObject, setter, [subObject doubleValue]);
                            break;
                        case _Char:
                            ((void (*)(id, SEL, char))(void *) objc_msgSend)((id)modelObject, setter, [subObject charValue]);
                            break;
                        case _Model:
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)modelObject, setter, [self handleDataModelEngine:subObject class:modelInfo.class classPrefix:prefix]);
                            break;
                        case _Data: {
                            if(![subObject isKindOfClass:[NSNull class]]){
                                ((void (*)(id, SEL, NSData *))(void *) objc_msgSend)((id)modelObject, setter, subObject);
                            }
                            break;
                        }
                        default:
                            
                            break;
                    }
                }
            }
            if (properties) {
                free(properties);
            }
            return modelObject;
        }else if ([object isKindOfClass:[NSArray class]]){
            NSArray  * objectArr = object;
            NSInteger  count = objectArr.count;
            NSMutableArray  * modelObjectArr = [NSMutableArray new];
            for (NSInteger i = 0; i < count; i++) {
                id subModelObject = [self handleDataModelEngine:objectArr[i] class:class classPrefix:prefix];
                if(subModelObject){
                    [modelObjectArr addObject:subModelObject];
                }
            }
            return modelObjectArr;
        }
    }
    return nil;
}

@end
