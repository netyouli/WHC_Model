//
//  TestModel.h
//  JsonModel
//
//  Created by WHC on 16/7/12.
//  Copyright © 2016年 whc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JS_Authors :NSObject
@property (nonatomic , copy) NSString              * firstName;
@property (nonatomic , copy) NSString              * genre;
@property (nonatomic , copy) NSString              * lastName;

@end

@interface JS_Programmers :NSObject
@property (nonatomic , copy) NSString              * firstName;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , copy) NSString              * lastName;

@end

@interface JS_Musicians :NSObject
@property (nonatomic , copy) NSString              * firstName;
@property (nonatomic , copy) NSString              * instrument;
@property (nonatomic , copy) NSString              * lastName;

@end

@interface TestModel :NSObject
@property (nonatomic , strong) NSArray              * authors;
@property (nonatomic , strong) NSArray              * programmers;
@property (nonatomic , strong) NSArray              * musicians;

@end

