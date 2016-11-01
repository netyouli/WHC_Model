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
- **咨询**: 712641411
- **作者**: 吴海超


用法
==============

#json -> modelObject
```Objective-C
/// jsonString 是一个比较复杂3000行的json文件，具体参考demo
    ModelObject * model = [ModelObject modelWithJson:jsonString];
    NSLog(@"model = %@\n\n\n",model);

```

#modelObject -> json
```Objective-C
    NSString * modelString = [model json];
    NSLog(@"modelString = %@\n\n\n",modelString);
```

#modelObject - > NSDictionary
```Objective-C
    NSDictionary * modelDict = [model dictionary];
    NSLog(@"modelDict = %@\n\n\n",modelDict);
```

#指定路径只解析Head对象
```Objective-C
    Head * head = [Head modelWithJson:jsonString keyPath:@"Head"];
    NSLog(@"head = %@\n\n\n",head);
```

#指定路径只解析ResponseBody对象
```Objective-C
    ResponseBody * body = [ResponseBody modelWithJson:jsonString keyPath:@"ResponseBody"];
    NSLog(@"ResponseBody = %@\n\n\n",body);
```

#指定路径只解析PolicyRuleList集合中第一个对象
```Objective-C
    PolicyRuleList * rule = [PolicyRuleList modelWithJson:jsonString keyPath:@"ResponseBody.PolicyRuleList[0]"];
    NSLog(@"rule = %@\n\n\n",rule);
```

推荐
==============
- WHC_DataModelFactory mac工具github地址：https://github.com/netyouli/WHC_DataModelFactory

Api文档
==============
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
## <a id="期待"></a>期待

- 如果您在使用过程中有任何问题，欢迎issue me! 很乐意为您解答任何相关问题!
- 与其给我点star，不如向我狠狠地抛来一个BUG！
- 如果您想要更多的接口来自定义或者建议/意见，欢迎issue me！我会根据大家的需求提供更多的接口！

## Licenses
All source code is licensed under the MIT License.