

Pod::Spec.new do |s|
  s.name             = 'LocalThirdPartySDK'
  s.version          = '1.0.0'
  s.summary          = 'LocalThirdPartySDK'
  s.description      = <<-DESC
  LocalThirdPartySDK,LocalThirdPartySDK.podspec,LocalThirdPartySDK.podspec
                       DESC
  s.homepage         = 'https://github.com/GPPG/topon_pod_test.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alex' => 'ios' }
  s.source           = { :git => 'https://github.com/GPPG/topon_pod_test.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'

 # s.static_framework = true
  
  s.requires_arc = true

  s.frameworks = 'SystemConfiguration','CoreGraphics','Foundation','UIKit','AVFoundation','AdSupport','AudioToolbox','CoreMedia','StoreKit','WebKit','AppTrackingTransparency','CoreMotion','CoreTelephony','MessageUI','SafariServices','CoreLocation','MediaPlayer','JavaScriptCore','CoreAudio','CoreFoundation','QuartzCore','NetworkExtension','Accelerate','CoreImage','CoreText','ImageIO','MapKit','MobileCoreServices','Security'
  
  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv','bz2.1.0','bz2','resolv.9','iconv','c++abi'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 armv7s arm64' }
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
   
  s.subspec 'anythink' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'anythink/AnyThinkBanner.framework','anythink/AnyThinkInterstitial.framework','anythink/AnyThinkNative.framework','anythink/AnyThinkRewardedVideo.framework','anythink/AnyThinkSDK.framework','anythink/AnyThinkSplash.framework'
    ss.resource = 'anythink/AnyThinkSDK.bundle'
  end
  
 s.subspec 'applovin' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'applovin/AppLovinSDK.framework'
    ss.resource = 'applovin/AppLovinSDKResources.bundle'
  end
  
end
