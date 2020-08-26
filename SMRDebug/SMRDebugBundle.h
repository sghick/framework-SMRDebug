//
//  SMRDebugBundle.h
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/27.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRDebugBundle : NSBundle

+ (instancetype)sourceBundle;

+ (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
