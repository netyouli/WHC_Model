//
//  main.m
//  JsonModel
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 whc. All rights reserved.
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
#import "TestModel.h"
#import "NSObject+WHC_Model.h"

@interface JS_TXT : NSObject
@property (nonatomic, copy)NSString * test;
@property (nonatomic, strong) NSNumber * tt;
@end

@implementation JS_TXT
@end

@interface WHC : NSObject
@property (nonatomic, copy) NSString * Demo;
@property (nonatomic, strong) JS_TXT * txt;
@property (nonatomic, strong) NSNumber * dd;
@property (nonatomic, assign) NSInteger age;
@end

@implementation WHC
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        NSString * testJson = @"{ \"programmers\": [    { \"firstName\": \"Brett\", \"lastName\":\"McLaughlin\",\"email\": \"brett@newInstance.com\",\"age\":18,\"isIos\":true,\"weight\":140.0 },    { \"firstName\": \"Jason\", \"lastName\":\"Hunter\",\"email\": \"jason@servlets.com\",\"age\":18,\"isIos\":false,\"weight\":140.0 },    { \"firstName\": \"Elliotte\", \"lastName\":\"Harold\",\"email\": \"elharo@macfaq.com\",\"age\":18,\"isIos\":false,\"weight\":140.0 }   ],  \"authors\": [    { \"firstName\": \"Isaac\",\"lastName\": \"Asimov\", \"genre\": \"science fiction\" },    { \"firstName\": \"Tad\",\"lastName\": \"Williams\", \"genre\": \"fantasy\" },    { \"firstName\": \"Frank\",\"lastName\": \"Peretti\", \"genre\": \"christian fiction\" }   ],  \"musicians\": [{ \"firstName\": \"Eric\", \"lastName\": \"Clapton\", \"instrument\": \"guitar\" },{ \"firstName\": \"Sergei\", \"lastName\": \"Rachmaninoff\", \"instrument\": \"piano\" }   ]  }";
        
        //// json转model
        TestModel * model = [TestModel modelWithJson:testJson classPrefix:@"JS_"];
        
        /// 模型转json
        NSLog(@"%@",[model json]);
        
        
        NSLog(@"========================================");
        /// WHC_Model 支持无限类嵌套(字典/数组),高效的数据解析引擎(深度递归)
        /// WHC_Model 强大的容错机制(允许json里的key和类型模型属性名称字符大小写可以不一样照样解析)
        
        /// 使用简单演示例子
        NSDictionary * jsonDict = @{@"demo":@"模型类转换测试",@"Dd":@(32),@"age":@(25),@"TXT":@{@"tEst":@"123456",@"tt":@(12)}};
        
        
        /// json转模型示例
        WHC * whc = [WHC modelWithDictionary:jsonDict];
        
        /// 自定义添加解析模型类前缀
        WHC * whc1 = [WHC modelWithDictionary:jsonDict classPrefix:@"JS_"];
        
        /// 模型转json示例
        NSString * whcJson = [whc json];
        NSLog(@"whcJson = %@",whcJson);
        
        NSString * whcJson1 = [whc1 json];
        NSLog(@"whcJson = %@",whcJson1);
        
        NSLog(@"========================================");
        /// 其他api接口就不一一演示请看WHC_Model api文档说明
        /// github文档：https://github.com/netyouli/WHC_DataModel
    }
    return 0;
}
