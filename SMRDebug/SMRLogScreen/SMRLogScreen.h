//
//  SMRLogScreen.h
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMRLogScreenMenuDelegate <NSObject>

@required
+ (NSString *)itemName;
+ (void)onSelected;

@end

@class SMRLogItem;
@interface SMRLogScreen : NSObject

/// log保存的最多条数(与linebreak无关),默认10000条,超出后每次会全部清除
@property (nonatomic, assign) NSUInteger maxNumberOfLine;
@property (nonatomic, strong) UIView *view;
/// 默认:YES,当view展示出来时,才会输入line的内容
@property (nonatomic, assign) BOOL enableOnlyWhenShow;

+ (instancetype)sharedScreen;
/** class 应当遵循 SMRLogScreenMenuDelegate 协议 */
- (void)addMenuItemClass:(NSString *)menuItemClass;

+ (void)show;
+ (void)hide;

+ (void)addLogItem:(SMRLogItem *)logItem;
+ (void)clear;

@end
