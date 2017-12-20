Pod::Spec.new do |spec|
	spec.name = 'CoreNavigation'
	spec.ios.deployment_target = '8.0'
	spec.version = '0.1.3'
	spec.license = 'MIT'
	spec.summary = 'A Swift navigation framework'
	spec.author = 'Aron Balog'
	spec.homepage = 'https://github.com/aronbalog/CoreNavigation'
	spec.source = { :git => 'https://github.com/aronbalog/CoreNavigation.git', :tag => '0.1.3' }
	spec.requires_arc = true
	spec.xcconfig = { 'SWIFT_VERSION' => '4.0' }

	spec.default_subspec = 'Core'

	spec.subspec 'Core' do |core|
		core.source_files = 'CoreNavigation/Core/**/*.{swift}'
  	end
	spec.subspec 'Routing' do |routing|
		routing.source_files = 'CoreNavigation/Plugins/Routing/**/*.{swift}'
		routing.pod_target_xcconfig = {
		  'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'ROUTING',
		}
		routing.dependency 'CoreNavigation/Core'
		routing.dependency 'CoreRoute', '~> 0.1.1'
  	end
end