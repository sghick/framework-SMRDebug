Pod::Spec.new do |s|
    s.name         = 'SMRDebug'
    s.version      = '1.0.0'
    s.summary      = 'the debug core of framework'
    s.authors      = { 'tinswin' => ''}
    s.homepage     = 'https://github.com/sghick/framework-SMRDebug'
    s.platform     = :ios
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    s.source       = { :git => 'git@github.com:sghick/framework-SMRDebug.git' }
    s.public_header_files = 'SMRDebug/SMRDebuger.h', 'SMRDebug/SMRDebug.h'
    s.source_files = 'SMRDebug/**/*.{h,m}'

    s.dependency 'FLEX'
    
    end
    
