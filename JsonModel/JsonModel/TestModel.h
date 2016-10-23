//
//  TestModel.h
//  JsonModel
//
//  Created by WHC on 16/7/12.
//  Copyright © 2016年 whc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    a = 1,
    b = 2,
    c = 3,
} ENUM_TYPE;

@interface OtherObject : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign)ENUM_TYPE enumType;
@end

@interface JS_Authors :NSObject
@property (nonatomic , copy) NSString              * firstName;
@property (nonatomic , copy) NSString              * genre;
@property (nonatomic , copy) NSString              * lastName;

@end

@interface JS_Programmers :NSObject
@property (nonatomic , copy) NSString              * firstName;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , copy) NSString              * lastName;
@property (nonatomic , assign) NSInteger            age;
@property (nonatomic , assign) CGFloat              weight;
@property (nonatomic , assign) BOOL                 isIos;

@end

@interface JS_Musicians :NSObject
@property (nonatomic , copy) NSString              * firstName;
@property (nonatomic , copy) NSString              * instrument;
@property (nonatomic , copy) NSString              * lastName;

@end

@interface TestModel :OtherObject
@property (nonatomic , strong) NSArray              * authors;
@property (nonatomic , strong) NSArray              * programmers;
@property (nonatomic , strong) NSArray              * musicians;

@end

