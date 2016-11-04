//
//  ViewController.m
//  WHC_Model
//
//  Created by WHC on 16/11/1.
//  Copyright © 2016年 WHC. All rights reserved.
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

// VERSION:(2.5)

#import "ViewController.h"
#import "NSObject+WHC_Model.h"
#import "ModelObject.h"
#import <objc/runtime.h>

#import <mach/mach_time.h>

@interface ViewController ()

@end

@implementation ViewController
//lostTime = 0.016034
//Time taken to doSomething 0.0576966 s

double MachTimeToSecs(uint64_t time) {
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer / (double)timebase.denom /1e9;
}

///**
// * 简单的字典 -> 模型（key替换，比如ID和id。多级映射，比如 oldName 和 name.oldName）
// */
//void keyValues2object4()
//{
//    // 1.定义一个字典
//    NSDictionary *dict = @{
//                           @"id" : @"20",
//                           @"desciption" : @"好孩子",
//                           @"name" : @{
//                                   @"newName" : @"lufy",
//                                   @"oldName" : @"kitty",
//                                   @"info" : @[
//                                           @"test-data",
//                                           @{@"nameChangedTime" : @"2013-08-07"}
//                                           ]
//                                   },
//                           @"other" : @{
//                                   @"bag" : @{
//                                           @"name" : @"小书包",
//                                           @"price" : @100.7
//                                           }
//                                   }
//                           };
//    
//    // 2.将字典转为MJStudent模型
//    MJStudent *stu = [MJStudent mj_objectWithKeyValues:dict];
//    
//    // 3.打印MJStudent模型的属性
//    NSLog(@"ID=%@, desc=%@, otherName=%@, oldName=%@, nowName=%@, nameChangedTime=%@", stu.ID, stu.desc, stu.otherName, stu.oldName, stu.nowName, stu.nameChangedTime);
//    NSLog(@"bagName=%@, bagPrice=%f", stu.bag.name, stu.bag.price);
//    
//    //    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
//    //    for (int i = 0; i< 10000; i++) {
//    //        [MJStudent mj_objectWithKeyValues:dict];
//    //    }
//    //    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
//    //    MJExtensionLog(@"%f", end - begin);
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    /// 从文件ModelObject读取json对象
    NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ModelObject" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    /// 解析jsonData
    //ModelObject * model = [ModelObject modelWithJsonData:jsonData];
    
    // json -> modelObject
    
    uint64_t beginTime = mach_absolute_time();
    
    // 在这里放置你要检测效率的代码
    ModelObject * model = [ModelObject whc_ModelWithJson:jsonString];
    uint64_t endTime = mach_absolute_time();
    
    NSLog(@"Time taken to doSomething %g s",MachTimeToSecs(endTime - beginTime));
    NSLog(@"model = %@\n\n\n",model);

    // modelObject -> json
    NSString * modelString = [model whc_Json];
    NSLog(@"modelString = %@\n\n\n",modelString);
    
    // modelObject - > NSDictionary
    uint64_t beginTime1 = mach_absolute_time();
    NSDictionary * modelDict = [model whc_Dictionary];
    uint64_t endTime1 = mach_absolute_time();
    NSLog(@"1Time taken to doSomething %g s",MachTimeToSecs(endTime1 - beginTime1));
    NSLog(@"modelDict = %@\n\n\n",modelDict);
    
    // 指定路径只解析Head对象
    Head * ead = [Head whc_ModelWithJson:jsonString keyPath:@"Head"];
    NSLog(@"head = %@\n\n\n",ead);
    
    // 指定路径只解析ResponseBody对象
    ResponseBody * body = [ResponseBody whc_ModelWithJson:jsonString keyPath:@"ResponseBody"];
    NSLog(@"ResponseBody = %@\n\n\n",body);
    
    // 指定路径只解析PolicyRuleList集合中第一个对象
    PolicyRuleList * rule = [PolicyRuleList whc_ModelWithJson:jsonString keyPath:@"ResponseBody.PolicyRuleList[0]"];
    NSLog(@"rule = %@\n\n\n",rule);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
