# Uncomment the next line to define a global platform for your project
# platform :ios, ’10.0’

target 'Therapy' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'IQKeyboardManagerSwift'
pod 'Alamofire'
pod 'NVActivityIndicatorView'
pod 'SDWebImage'
pod 'UIActivityIndicator-for-SDWebImage'
pod 'MMDrawerController'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'Google/SignIn'
pod 'PasswordTextField'
  # Pods for Therapy

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
end
