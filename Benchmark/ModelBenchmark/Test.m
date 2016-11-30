//
//  Test.m
//  ModelBenchmark
//
//  Created by WHC on 16/11/30.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "Test.h"

@implementation Test

@end
@implementation Status
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        [self whc_Decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self whc_Encode:encoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self whc_Copy];
}

@end

