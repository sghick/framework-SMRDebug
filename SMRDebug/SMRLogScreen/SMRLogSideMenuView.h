//
//  SMRLogSideMenuView.h
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 白色小三角形的朝向, 需要配合trangleOffset使用
typedef NS_ENUM(NSInteger, SMRLogSideMenuTrangleStyle) {
    SMRLogSideMenuTrangleStyleNone,    // 无
    SMRLogSideMenuTrangleStyleUp,      // 向上
    SMRLogSideMenuTrangleStyleDown,    // 向下
    SMRLogSideMenuTrangleStyleLeft,    // 向左
    SMRLogSideMenuTrangleStyleRight,   // 向右
};

@class SMRLogSideMenuView;
/// 定制调试时的block
typedef CGFloat(^SMRWebSideMenuItemHeightBlock)(SMRLogSideMenuView *menu, UIView *item, NSInteger index);
/// 点击事件的block
typedef void(^SMRWebSideMenuTouchedBlock)(SMRLogSideMenuView *menu, UIView *item, NSInteger index);
/// 菜单即将消失时的block
typedef void(^SMRWebSideMenuWillDismissBlock)(SMRLogSideMenuView *menu);

@interface SMRLogSideMenuView : UIView

@property (nonatomic, copy  ) SMRWebSideMenuItemHeightBlock itemHeightBlock; ///< 默认44
@property (nonatomic, copy  ) SMRWebSideMenuTouchedBlock menuTouchedBlock;
@property (nonatomic, copy  ) SMRWebSideMenuWillDismissBlock menuWillDismissBlock;

@property (nonatomic, assign) SMRLogSideMenuTrangleStyle trangleStyle; ///< 三角形的样式
@property (nonatomic, assign) CGPoint trangleOffset; ///< 三角形的偏移
@property (nonatomic, assign) BOOL trangleOffsetReverse; ///< 反转计算三角形的偏移

@property (nonatomic, strong, readonly) NSArray<UIView *> *menuItems;
@property (nonatomic, assign, readonly) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat minHeightOfContent; ///< view.height
@property (nonatomic, assign) CGFloat maxHeightOfContent; ///< view.height
@property (nonatomic, assign) BOOL scrollEnabled; ///< default:YES

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)loadMenuWithItems:(NSArray<UIView *> *)menuItems
                menuWidth:(CGFloat)menuWidth
                   origin:(CGPoint)origin;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)hide;

+ (NSArray<UIView *> *)menuItemsWithTitles:(NSArray<NSString *> *)titles;

@end
