Pod::Spec.new do |s|
    s.name         = 'SMRDebug'
    s.version      = '2.1.1'
    s.summary      = 'the Debug core of framework'
    s.authors      = { 'tinswin' => ''}
    s.homepage     = 'https://github.com/sghick/framework-SMRDebug'
    s.platform     = :ios
    s.ios.deployment_target = '9.0'
    s.requires_arc = true
    s.source       = { :git => 'git@github.com:sghick/framework-SMRDebug.git' }
    s.public_header_files = 'SMRDebug/SMRDebuger.h', 'SMRDebug/SMRDebug.h', 'SMRDebug/SMRLogScreen/SMRLogScreen.h', 'SMRDebug/SMRLogSystem/SMRLogSys.h'
    s.source_files = 'SMRDebug/**/*.{h,m}'
    s.resource     = 'SMRDebug/SMRDebugBundle.bundle'

    s.dependency 'FLEX'
    s.dependency 'DoraemonKit/Core'
    s.dependency 'DoraemonKit/WithGPS'
    s.dependency 'DoraemonKit/WithLoad'
    s.dependency 'DoraemonKit/WithLogger'
    s.dependency 'DoraemonKit/WithDatabase'
    s.dependency 'DoraemonKit/WithMLeaksFinder'
    
    end
    
