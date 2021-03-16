# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

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
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  
  target 'CPBLFanTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CPBLFanUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Rank-Widget' do
   use_frameworks!
   #Pods for today widget
   #Pods about Swift Language
   pod 'SwifterSwift' 
   #Pods about internet request/response/parse
   pod 'Alamofire', '~> 5.2'
   pod 'Kanna', '~> 5.2.2'
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
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Messaging'
end

post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
            end
         end
     end
  end
