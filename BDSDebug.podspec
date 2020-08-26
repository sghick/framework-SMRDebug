Pod::Spec.new do |s|
    s.name         = 'BDSDebug'
    s.version      = '2.1.1'
    s.summary      = 'the debug core of framework'
    s.authors      = { 'tinswin' => ''}
    s.homepage     = 'http://git.aishepin8.com/ios/framework-bdsdebug'
    s.platform     = :ios
    s.ios.deployment_target = '9.0'
    s.requires_arc = true
    s.source       = { :git => 'git@git.aishepin8.com:ios/framework-bdsdebug.git' }
    s.public_header_files = 'BDSDebug/BDSDebuger.h', 'BDSDebug/BDSDebug.h', 'BDSDebug/BDSLogScreen/BDSLogScreen.h', 'BDSDebug/BDSLogSystem/BDSLogSys.h'
    s.source_files = 'BDSDebug/**/*.{h,m}'
    s.resource     = 'BDSDebug/BDSDebugBundle.bundle'

    s.dependency 'FLEX'
    s.dependency 'DoraemonKit/Core'
    s.dependency 'DoraemonKit/WithGPS'
    s.dependency 'DoraemonKit/WithLoad'
    s.dependency 'DoraemonKit/WithLogger'
    s.dependency 'DoraemonKit/WithDatabase'
    s.dependency 'DoraemonKit/WithMLeaksFinder'
    
    end
    
