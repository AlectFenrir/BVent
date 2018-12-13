# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BVent Alpha' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BVent Alpha
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  
  # Pods for RxSwift+MVVM
  pod 'Alamofire', '~> 4.5'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'

  target 'BVent AlphaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BVent AlphaUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name != 'AMScrollingNavbar' && target.name != 'Mixpanel-swift' && target.name != 'UPCarouselFlowLayout'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    else
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
end
