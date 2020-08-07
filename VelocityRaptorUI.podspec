Pod::Spec.new do |s|
  s.name             = 'VelocityRaptorUI'
  s.version          = '1.0.0'
  s.summary          = 'Velocity Raptor UI components'

  s.description      = <<-DESC
Velocity Raptor UI components and tools
                       DESC

  s.homepage         = 'https://velocityraptor.co'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nicholas Bonatsakis' => 'nbonatsakis@gmail.com' }
  s.source           = { :git => 'git@github.com:nbonatsakis/VelocityRaptorUI.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.0']

  s.source_files = 'VelocityRaptorUI/Classes/**/*'
 
  s.dependency 'MaterialComponents', '~> 112.0.1'
  s.dependency 'Then', '~> 2.7.0'
  s.dependency 'Anchorage', '~> 4.4.0'
  s.dependency 'Reusable', '~> 4.1.1'
  s.dependency 'VelocityRaptorCore', '~> 1.0.2'
end
