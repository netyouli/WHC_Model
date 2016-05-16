//
//  main.m
//  JsonModel
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 whc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHC_DataModel.h"

@interface TXT : NSObject
@property (nonatomic, copy)NSString * test;
@end

@implementation TXT
@end

@interface WHC : NSObject
@property (nonatomic, copy) NSString * Demo;
@property (nonatomic, strong) TXT * txt;
@end

@implementation WHC
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        /// WHC_DataModel 支持无限类嵌套(字典/数组),高效的数据解析引擎(深度递归)
        /// WHC_DataModel 强大的容错机制(允许json里的key和类型模型属性名称字符大小写可以不一样照样解析)
        
        /// 使用简单演示例子
        NSDictionary * jsonDict = @{@"demo":@"模型类转换测试",@"TXT":@{@"tEst":@"123456"}};
        WHC * whc = [WHC_DataModel dataModelWithDictionary:jsonDict className:[WHC class]];
        /// 其他api接口就不一一演示请看WHC_DataModel.h api文档说明
        /// github文档：https://github.com/netyouli/WHC_DataModel
        /// 如果结合本示例和WHC_DataModel.h api文档说明最后还是不会使用那么我建议你放弃做iOS开发。
    }
    return 0;
}
