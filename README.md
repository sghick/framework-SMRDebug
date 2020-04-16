# framework-SMRDebug


因为此库为调试用的,如果不想在release版本中使用,
可以在podfile中可以写成以下形式进行区分:

```
DebugBranchReleaseMode,DebugBranchDebugMode = 'releasemode','debugmode'
DebugBranch = DebugBranchDebugMode

target "TestDemo"  do
    platform:ios, '9.0'
    use_frameworks!
    
    #### SMRDebug
    pod 'SMRDebug', :git => 'git@github.com:sghick/framework-SMRDebug.git', :branch => DebugBranch
    
end
```

