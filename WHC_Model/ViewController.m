//
//  ViewController.m
//  WHC_Model
//
//  Created by WHC on 16/11/1.
//  Copyright © 2016年 WHC. All rights reserved.
//  WHC_Model<https://github.com/netyouli/WHC_Model>
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


- (void)viewDidLoad {
    [super viewDidLoad];
    /// 从文件ModelObject读取json对象
    NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ModelObject" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    /************** 解析jsonData **************/
    ModelObject * model = [ModelObject whc_ModelWithJson:jsonData];
    NSLog(@"解析jsonData model = %@\n\n",model);
    
    /************** json -> modelObject **************/
    model = [ModelObject whc_ModelWithJson:jsonString];
    NSLog(@"json -> modelObject model = %@\n\n\n",model);

    /************** modelObject -> json **************/
    NSString * modelString = [model whc_Json];
    NSLog(@"modelObject -> json modelString = %@\n\n\n",modelString);
    
    /************** modelObject - > NSDictionary **************/
    NSDictionary * modelDict = [model whc_Dictionary];
    NSLog(@"modelObject - > NSDictionary modelDict = %@\n\n\n",modelDict);
    
    /************** 指定路径只解析Head对象 **************/
    Head * head = [Head whc_ModelWithJson:jsonString keyPath:@"Head"];
    head.testNum = [NSNumber numberWithInt:100];
    {
        /************** 归档对象 **************/
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:head];
        
        /************** 解归档对象 **************/
        Head * tempHead = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"tempHead.testNum = %@",tempHead.testNum);
    }
    NSLog(@"指定路径只解析Head对象 head = %@\n\n\n",head);
    
    /************** 指定路径只解析ResponseBody对象 **************/
    ResponseBody * body = [ResponseBody whc_ModelWithJson:jsonString keyPath:@"ResponseBody"];
    NSLog(@"指定路径只解析ResponseBody对象 ResponseBody = %@\n\n\n",body);
    
    /************** 指定路径只解析PolicyRuleList集合中第一个对象 **************/
    PolicyRuleList * rule = [PolicyRuleList whc_ModelWithJson:jsonString keyPath:@"ResponseBody.PolicyRuleList[10]"];
    NSLog(@"指定路径只解析PolicyRuleList集合中第一个对象 rule = %@\n\n\n",rule);
    
    /************** 归档对象 **************/
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    
    /************** 解归档对象 **************/
    ModelObject * tempModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"tempModel = %@",tempModel);
    
    /************** 复制对象 **************/
    ModelObject * copyModel = model.copy;
    NSLog(@"copyModel = %@",copyModel);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
