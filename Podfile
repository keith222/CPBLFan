# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'CPBLFan' do

  use_frameworks!
  # Pods for CPBLFan

  #Pods about Swift Language
  pod 'SwifterSwift'
  
  #Pods about internet request/response/parse
  pod 'Alamofire', '~> 5.2'
  pod 'Kanna', '~> 5.2.2'
  
  #Pods for detect net connection
  pod 'ReachabilitySwift'

  #Pods about UI
  pod 'Kingfisher', '~> 5.0'
  pod 'PKHUD'
    
  #Google Firebase
  pod 'GoogleUtilities'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'Firebase/InAppMessaging'
  pod 'Firebase/AnalyticsWithoutAdIdSupport'
  pod 'Firebase/Crashlytics'
end

target 'Rank-Widget' do
   use_frameworks!

   #Pods for today widget
   #Pods about Swift Language
   pod 'SwifterSwift' 
   #Pods about internet request/response/parse
   pod 'GoogleUtilities'
   pod 'Firebase/Database'
end

target 'Schedule-Widget' do
    use_frameworks!

    #Pods for today widget
    #Pods about Swift Language
    pod 'SwifterSwift' 
    
    #Pods about internet request/response/parse
    pod 'Alamofire', '~> 5.2'
    pod 'Kanna', '~> 5.2.2'
    
    #Google Firebase
    pod 'GoogleUtilities'
    pod 'Firebase/Database'
    pod 'Firebase/Messaging'
end

target 'CPBLFanWidgetExtension' do
  use_frameworks!

  #Pods for widget
  #Pods about Swift Language
  pod 'SwifterSwift'
  #Google Firebase
  pod 'GoogleUtilities'
  pod 'Firebase/Database'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end
