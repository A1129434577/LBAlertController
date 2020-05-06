Pod::Spec.new do |spec|
  spec.name         = "LBAlertController"
  spec.version      = "1.0.2"
  spec.summary      = "扩展系统UIAlertController功能"
  spec.description  = "扩展系统UIAlertController功能，使其在title和message与actionButton之间的位置能自定义一个view，并且actionButton样式完全由使用者掌控。"
  spec.homepage     = "https://github.com/A1129434577/LBAlertController"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/LBAlertController.git', :tag => spec.version.to_s }
  spec.dependency     "LBPresentTransitions"
  spec.source_files = "LBAlertController/**/*.{h,m}"
  spec.requires_arc = true
end
#--use-libraries
