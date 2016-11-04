use_frameworks!

target 'Swift-SOAP-with-Alamofire' do
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
pod 'SWXMLHash'
pod 'AEXML'
pod 'StringExtensionHTML'
pod 'CocoaAsyncSocket'
pod 'Fuzi', '~> 0.4.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
