Pod::Spec.new do |s|

  s.name         = "WHC_Model"
  s.version      = "1.7.1"
  s.summary      = "iOS平台高效转换引擎json->model,model->json,model->Dictionary,支持模型类继承其他模型类,支持指定路径转换,不区分json的key和模型属性名称大小写,自动处理json中null"

  s.homepage     = "https://github.com/netyouli/WHC_Model"

  s.license      = "MIT"

  s.author             = { "吴海超(WHC)" => "712641411@qq.com" }

  s.source       = { :git => "https://github.com/netyouli/WHC_Model.git", :tag => "1.7.1"}

  s.source_files  = "WHC_ModelKit/*.{h,m}"

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '7.0'
  # s.public_header_files = "Classes/**/*.h"


  s.requires_arc = true


end
