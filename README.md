# WHC_DataModel
自动把字典或者数据反射为模型数据类对象

###JSON --> Model、Core Data Model
###JSONString --> Model、Core Data Model
###Model、Core Data Model --> JSON
###JSON Array --> Model Array、Core Data Model Array
###JSONString --> Model Array、Core Data Model Array
###Model Array、Core Data Model Array --> JSON Array
```Objective-C
typedef enum {
    SexMale,
    SexFemale
} Sex;

@interface User : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (strong, nonatomic) NSNumber * age;
@property (strong, nonatomic) NSNumber * height;
@property (strong, nonatomic) NSNumber *money;
@property (strong, nonatomic) Sex  *sex;
@end

/***********************************************/


NSDictionary *dict = @{
    @"name" : @"Jack",
    @"icon" : @"lufy.png",
    @"age" : @20,
    @"height" : @"1.55",
    @"money" : @100.9,
    @"sex" : @(SexFemale)
};
// JSON -> User
User * user = [WHC_DataModel dataModelWithDictionary:dict className:[User class]];

NSLog(@"name=%@, icon=%@, age=%@, height=%@, money=%@, sex=%@",
      user.name, user.icon, user.age, user.height, user.money, user.sex);
// name=Jack, icon=lufy.png, age=20, height=1.550000, money=100.9, sex=1


'''
