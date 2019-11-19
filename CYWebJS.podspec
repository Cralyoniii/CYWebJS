
Pod::Spec.new do |s|
  s.name             = 'CYWebJS'
  s.version          = '0.0.1'
  s.summary          = 'first'

  s.description      = <<-DESC
  gogogo
                       DESC

  s.homepage         = 'https://github.com/Cralyoniii/CYWebJS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cralyon' => '1038239369@qq.com' }
  s.source           = { :git => 'https://github.com/Cralyoniii/CYWebJS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.frameworks = 'UIKit'
  
  s.source_files = 'CYWebJS/*.{h,m}'
  
end
