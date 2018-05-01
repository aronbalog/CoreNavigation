Pod::Spec.new do |spec|
	spec.name = 'CoreNavigation'
	spec.ios.deployment_target = '8.0'
	spec.version = '1.0.0-beta-3'
	spec.license = 'MIT'
	spec.summary = 'A Swift navigation framework'
	spec.author = 'Aron Balog'
	spec.homepage = 'https://github.com/aronbalog/CoreNavigation'
	spec.source = { :git => 'https://github.com/aronbalog/CoreNavigation.git', :tag => spec.version }
	spec.requires_arc = true
	spec.xcconfig = { 'SWIFT_VERSION' => '4.0' }
	spec.source_files = 'CoreNavigation/**/*.{swift}'
end