//
//  Test.h
//  ModelBenchmark
//
//  Created by WHC on 16/11/30.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WHC_Model.h"

@interface Status :NSObject <NSCoding,NSCopying>
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , assign) NSInteger              code;

@end

@interface Test :NSObject
@property (nonatomic , strong) Status              * status;
@property (nonatomic , strong) NSArray<NSString *>              * data;
@property (nonatomic , copy) NSString              * token;

@end

