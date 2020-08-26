//
//  SMRMainObject.m
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/21.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRMainObject.h"
#import "SMRMainController.h"
#import <SMRBaseCore/SMRBaseCoreConfig.h>
#import "SMRDebug.h"

@implementation SMRMainObject
@synthesize window = _window;

#pragma mark - SMRMainObjectProtocol

+ (instancetype)sharedObject {
    static dispatch_once_t onceToken;
    static SMRMainObject *_mainObject = nil;
    dispatch_once(&onceToken, ^{
        _mainObject = [[SMRMainObject alloc] init];
    });
    return _mainObject;
}

- (void)setWindow:(UIWindow * _Nonnull)window {
    _window = window;
}

/** 根据不同的情况加载不同的逻辑 */
+ (void)makeKeyAndVisibleWindow:(UIWindow *)window {
    SMRMainObject *object = [SMRMainObject sharedObject];
    object.window = window;
    
    SMRMainController *main = [[SMRMainController alloc] init];
    SMRNavigationController *nav = [[SMRNavigationController alloc] initWithRootViewController:main];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    
    SMRBaseCoreConfig *config = [[SMRBaseCoreConfig alloc] init];
    // 数据库名
    config.dbName = @"debug";
    // 初始化
    [config configInitialization];
    
    [SMRDebug startDebugIfNeeded];
}

@end
