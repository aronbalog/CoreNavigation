platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

target 'CoreNavigation' do
    pod 'CoreRoute', '~> 0.1.1'
end

target 'CoreNavigationExample' do
    pod 'CoreNavigation', '~> 0.1.2'
    pod 'CoreNavigation/Routing', '~> 0.1.2'
end

target 'CoreNavigationTests' do
    inherit! :search_paths
    pod 'CoreRoute', '~> 0.1.1'
    pod 'CoreNavigation/Routing', '~> 0.1.2'
    
    pod 'Quick'
    pod 'Nimble'
end
