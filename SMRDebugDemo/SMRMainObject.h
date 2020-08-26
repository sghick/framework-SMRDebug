//
//  SMRMainObject.h
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/21.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRMainObjectProtocol <NSObject>

@property (strong, nonatomic, readonly) UIWindow *window;

+ (instancetype)sharedObject;

@end

@interface SMRMainObject : NSObject<SMRMainObjectProtocol>

+ (void)makeKeyAndVisibleWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
