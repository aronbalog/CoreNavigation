platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

def default_pods
    pod 'CoreRoute', '~> 0.2.2'
end

target 'CoreNavigation' do
    default_pods
end

target 'CoreNavigationExample' do
    default_pods
end

target 'CoreNavigationTests' do
    inherit! :search_paths
    default_pods
    
    pod 'Quick'
    pod 'Nimble'
end
