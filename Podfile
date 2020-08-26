SMRBaseCoreBranch = 'release-1.0.0'

target "SMRDebugDemo" do
    platform:ios, '9.0'
    use_frameworks!
    
    #### BaseCore
    pod 'SMRBaseCore', :git => 'git@github.com:sghick/framework-SMRBaseCore.git', :branch => SMRBaseCoreBranch
    
    pod 'FLEX', :inhibit_warnings => true
    pod 'DoraemonKit/Core'
    pod 'DoraemonKit/WithGPS'
    pod 'DoraemonKit/WithLoad'
    pod 'DoraemonKit/WithLogger'
    pod 'DoraemonKit/WithDatabase'
    pod 'DoraemonKit/WithMLeaksFinder'

end
