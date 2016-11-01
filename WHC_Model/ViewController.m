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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 从文件ModelObject读取json对象
    NSString * jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ModelObject" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    /// 解析jsonData
    //ModelObject * model = [ModelObject modelWithJsonData:jsonData];
    
    // json -> modelObject
    ModelObject * model = [ModelObject modelWithJson:jsonString];
    NSLog(@"model = %@\n\n\n",model);

    // modelObject -> json
    NSString * modelString = [model json];
    NSLog(@"modelString = %@\n\n\n",modelString);
    
    // modelObject - > NSDictionary
    NSDictionary * modelDict = [model dictionary];
    NSLog(@"modelDict = %@\n\n\n",modelDict);
    
    // 指定路径只解析Head对象
    Head * head = [Head modelWithJson:jsonString keyPath:@"Head"];
    NSLog(@"head = %@\n\n\n",head);
    
    // 指定路径只解析ResponseBody对象
    ResponseBody * body = [ResponseBody modelWithJson:jsonString keyPath:@"ResponseBody"];
    NSLog(@"ResponseBody = %@\n\n\n",body);
    
    // 指定路径只解析PolicyRuleList集合中第一个对象
    PolicyRuleList * rule = [PolicyRuleList modelWithJson:jsonString keyPath:@"ResponseBody.PolicyRuleList[0]"];
    NSLog(@"rule = %@\n\n\n",rule);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
