//
//  SMRLogSettings.h
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/22.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRLogSettings : NSObject

@property (assign, nonatomic) BOOL menu_fold;           ///< 菜单-折叠状态
@property (assign, nonatomic) BOOL menu_log_c;          ///< 菜单-日志-显示时间
@property (assign, nonatomic) BOOL menu_log_r;          ///< 菜单-日志-显示时间轴
@property (assign, nonatomic) BOOL menu_log_l;          ///< 菜单-日志-显示标签
@property (assign, nonatomic) BOOL menu_log_f;          ///< 菜单-日志-显示方法
@property (assign, nonatomic) BOOL menu_log_C;          ///< 菜单-日志-显示内容

@property (assign, nonatomic) CGPoint ui_orgin;         ///< UI-视图初始位置
@property (assign, nonatomic) CGPoint ui_min_orgin;     ///< UI-视图初始位置-mini

+ (instancetype)sharedInstance;

- (void)reset_menu_log;
- (NSString *)format_for_menu_log;
- (NSString *)format_for_menu_log_with_r;

+ (void)syncToDisk;

@end

NS_ASSUME_NONNULL_END
