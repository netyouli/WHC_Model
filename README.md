# WHC_Model
简介
==============
- **高效**: 深度递归高效解析算法
- **继承**: 支持model类继承其他model类
- **安全**: 自动处理json中的null
- **优势**: 高容错能力(model类属性名称和json里key名称不区分大小写)
- **强大**: 支持自定义model类前缀(避免相同类名导致编译冲突错误)
- **特性**: 支持反射指定json路径key来解析指定的节点json对象
- **嵌套**: 支持json或者model类的无限嵌套,json->model ,model->json的转换
- **强悍**: 只需要两个文件(500来行代码)

用法
==============
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

// User -> Dictionary
NSLog(@"json = %@",[user dictionary]);


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
指定json的key路径例子具体请参考提供demo
==============
```Objective-C
/// 解析json通过指定json里路径key来解析指定的节点json对象
NSArray        * programmers = [JS_Programmers modelWithJson:testJson keyPath:@"programmers"];
NSLog(@"programmers = %@",programmers);
JS_Programmers * programmer = [JS_Programmers modelWithJson:testJson keyPath:@"programmers[0]"];
NSLog(@"programmer = %@",programmer);
NSString       * firstName = [TestModel modelWithJson:testJson keyPath:@"programmers[0].firstName"];
NSLog(@"firstName = %@",firstName);
```

###咨询qq:712641411
###作者：吴海超
###配合WHC_DataModelFactory mac工具使用将彻底解放你双手：github地址：https://github.com/netyouli/WHC_DataModelFactory
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

/** 说明:把json解析为模型对象
*@param jsonData :jsonData json数据对象
*@param keyPath: json key的路径
*@return 模型对象
*/

+ (id)modelWithJsonData:(NSData *)jsonData keyPath:(NSString *)keyPath;

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
