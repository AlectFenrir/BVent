# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'BVent Alpha' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BVent Alpha
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Cards'
  pod 'MaterialComponents/Buttons'
  pod 'ActionButton'
  pod 'Shimmer'
  pod 'Floating'

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
