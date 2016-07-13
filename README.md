# WHC_Model
### WHC_Model 功能说明:
##### 1.支持json到模型对象
##### 2.支持模型对象到json的转换
##### 3.同时支持json和模型对象的无限嵌套
#### 4.高效的解析转换算法
#### 5.支持容错处理模型属性名称和json的key不区分大小写
#### 6.支持自定义模型类前缀

###咨询qq:712641411
###作者：吴海超


###这个配合WHC_DataModelFactory mac工具使用将让你体验超神的感觉：github地址：https://github.com/netyouli/WHC_DataModelFactory
####JSON --> Model、Core Data Model
####JSONString --> Model、Core Data Model
####Model、Core Data Model --> JSON
####JSON Array --> Model Array、Core Data Model Array
####JSONString --> Model Array、Core Data Model Array
####Model Array、Core Data Model Array --> JSON Array

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
User * user = [User modelWithDictionary:dict];
NSLog(@"user = %@",user);

// User -> json
NSLog(@"json = %@",[user json]);

```


###Model contains model

```Objective-C
@interface Status : NSObject
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Status *status;
@end

/***********************************************/

NSDictionary *dict = @{
@"text" : @"Agree!Nice weather!",
@"user" : @{
@"name" : @"Jack",
@"icon" : @"lufy.png"
},
@"retweetedStatus" : @{
@"text" : @"Nice weather!",
@"user" : @{
@"name" : @"Rose",
@"icon" : @"nami.png"
}
}
};

// JSON -> Status
Status *status = [Status modelWithDictionary:dict];
NSLog(@"status = %@",status);
// status -> json
NSLog(@"json = %@",[status json]);

```
###WHC_Model Api文档

```Objective-C

###pragma mark - json转模型对象 Api -

/** 说明: 把json数组解析为模型对象数组
 *@param array:json数组
 *@return 模型对象数组
 */
+ (NSArray*)modelWithArray:(NSArray*)array;

/** 说明: 把json数组解析为模型对象数组
 *@param array:json数组
 *@return 模型对象数组
 */

+ (NSArray*)modelWithArray:(NSArray*)array classPrefix:(NSString *)prefix;

/** 说明:把json字典解析为模型对象
 *@param dictionary:json字典
 *@param prefix: 自定义模型类前缀名称
 *@return 模型对象
 */
+ (id)modelWithDictionary:(NSDictionary*)dictionary;

/** 说明:把json字典解析为模型对象
 *@param dictionary:json字典
 *@param prefix: 自定义模型类前缀名称
 *@return 模型对象
 */

+ (id)modelWithDictionary:(NSDictionary*)dictionary classPrefix:(NSString *)prefix;

/** 说明:把json解析为模型对象
 *@param json :json 字符串
 *@return 模型对象
 */
+ (id)modelWithJson:(NSString *)json;

/** 说明:把json解析为模型对象
 *@param json :json 字符串
 *@param prefix: 自定义模型类前缀名称
 *@return 模型对象
 */

+ (id)modelWithJson:(NSString *)json classPrefix:(NSString *)prefix;

/** 说明:把json解析为模型对象
 *@param jsonData :jsonData json数据对象
 *@return 模型对象
 */
+ (id)modelWithJsonData:(NSData *)jsonData;

/** 说明:把json解析为模型对象
 *@param jsonData :jsonData json数据对象
 *@param prefix: 自定义模型类前缀名称
 *@return 模型对象
 */
+ (id)modelWithJsonData:(NSData *)jsonData classPrefix:(NSString *)prefix;

###pragma mark - 模型对象转json Api -

/** 说明:把模型对象转换为字典
 *@return 字典对象
 */

- (NSDictionary *)dictionary;

/** 说明:把模型对象转换为json字符串
 *@return json字符串
 */

- (NSString *)json;
```
