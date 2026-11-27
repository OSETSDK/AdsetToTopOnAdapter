Pod::Spec.new do |s|
  s.name         = "AdsetToTopOnAdapter"
  s.version      = "8.0.0.0"
  s.summary = "Adset TopOn mediation adapter"
  s.description  = <<-DESC
                    OSETSDK 是一个专业的广告聚合SDK，提供高效的广告展示和收益优化功能。
                    DESC
  s.homepage = "https://github.com/OSETSDK/AdsetToTopOnAdapter"
  s.license      = { :type => "Apache-2.0", :file => "LICENSE" }
  s.author       = "Adset"
  
  # 设置最低支持版本
  s.ios.deployment_target = '13.0'
  s.static_framework = true
  # 源文件配置
  s.source       = {
    :git => 'https://github.com/OSETSDK/AdsetToTopOnAdapter.git',
    :tag => s.version.to_s
  }
  # 主框架文件
  # 检查 OSETToBidAdapter.podspec 关键字段
  s.source_files = 'AdsetToTopOnAdapter/**/*.{h,m}'
  # 系统框架依赖
  s.frameworks = "Foundation", "UIKit", "AdSupport", "CoreTelephony", "StoreKit", "SystemConfiguration"
  
  # 资源文件
    
  # Swift版本设置
  s.swift_version = '5.0'
  
  # ================= 第三方依赖库 =================
 
  s.dependency 'Adset', '>= 8.0.0.0'
  s.dependency 'TPNiOS', '>= 6.6.11'
end
