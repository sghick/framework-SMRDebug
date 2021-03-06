//
//  SMRDebug.h
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SMRDebugMode) {
    SMRDebugModeNone,           // 关闭所有
    SMRDebugModeAll,            // 开启所有
    SMRDebugModeBackgoround,    // 关闭浮窗
};

@interface SMRDebug : NSObject

/**
 判断是否开启调试模式
 */
+ (void)startDebugIfNeeded;

/**
 使用URL设置调试模式
 
 @param url scheme://host?ck=<时效令牌>&uk=<身份识别码>&ctype=<模式:screen/log/flex>&status=<状态:0/1>
 @param allowScheme 允许打开的scheme
 @return 进入调试模式,返回YES
 */
+ (BOOL)setDebugModelWithURL:(NSURL *)url allowScheme:(NSString *)allowScheme uk:(NSString *)uk;

/**
 直接打开/关闭调试模式(0:关闭所有 1:开启所有 2:关闭浮窗)
 */
+ (void)setDebug:(SMRDebugMode)debug;

/**
 获取当前model
 */
+ (SMRDebugMode)deubgMode;

/**
 生成令牌(旧版)
 */
+ (NSString *)old_createCheckCodeWithKey:(NSString *)key date:(NSDate *)date __deprecated_msg("使用-createCheckCodeWithKey:rowKey:方法代替");
/**
 生成令牌
 */
+ (NSString *)createCheckCodeWithKey:(NSString *)key date:(NSDate *)date;

@end
