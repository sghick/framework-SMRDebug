//
//  SMRLogScreen.m
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 ibaodashi. All rights reserved.
//

#import "SMRLogScreen.h"
#import "SMRLogItem.h"
#import "SMRLogSettings.h"
#import "SMRLogSideMenuView.h"

#define FontSizeOfButtons (10)
#define SpaceOfButtons (20)
#define TopOfButtons (8)

@interface SMRLogScreen () <
UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *foldBtn;
@property (nonatomic, strong) UIButton *toolsBtn;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIButton *hideBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *filterTextView;

@property (nonatomic, strong) NSMutableArray<NSString *> *menuItemClasses;
@property (nonatomic, strong) NSMutableArray<NSString *> *groupLabels;
@property (nonatomic, strong) NSMutableArray<SMRLogItem *> *groupLogs;

@property (nonatomic, strong) NSArray *lastGroupLabels;
@property (nonatomic, strong) NSArray *filterdGroupLables;

@property (nonatomic, assign) CGAffineTransform lastTransform;
@property (nonatomic, assign) CGPoint viewOrigin;
@property (nonatomic, assign) CGPoint minViewOrigin;
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGSize minViewSize;
@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, assign) NSInteger numberOfLine;

@property (nonatomic, assign) BOOL didShow;

@end

@implementation SMRLogScreen

+ (instancetype)sharedScreen {
    static SMRLogScreen *_sharedLogScreen = nil;
    static dispatch_once_t onceTokenLogScreen;
    dispatch_once(&onceTokenLogScreen, ^{
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        _sharedLogScreen = [[SMRLogScreen alloc] init];
        _sharedLogScreen.viewOrigin = CGPointMake(10, 180);
        _sharedLogScreen.minViewOrigin = CGPointMake(screenWidth - 10 - 55, 180);
        _sharedLogScreen.viewSize = CGSizeMake(screenWidth - 20, 320);
        _sharedLogScreen.minViewSize = CGSizeMake(55, 55);
        _sharedLogScreen.numberOfLine = 0;
        _sharedLogScreen.maxNumberOfLine = 10000;
        _sharedLogScreen.enableOnlyWhenShow = YES;
        _sharedLogScreen.buttonSize = CGSizeMake(36, 24);
        _sharedLogScreen.backColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1.0];
        
        [_sharedLogScreen loadDefaultMenuItems];
        [_sharedLogScreen prepareForUIWithSettings];
    });
    return _sharedLogScreen;
}

- (void)addMenuItemClass:(NSString *)menuItemClass {
    if (!menuItemClass.length) {
        return;
    }
    if (![NSClassFromString(menuItemClass) conformsToProtocol:@protocol(SMRLogScreenMenuDelegate)]) {
        return;
    }
    if ([self.menuItemClasses containsObject:menuItemClass]) {
        return;
    }
    [self.menuItemClasses addObject:menuItemClass];
}

#pragma mark - Getters

/// index from 0 to n
- (CGFloat)xFromLeftWithIndex:(NSInteger)index {
    return SpaceOfButtons + index*(self.buttonSize.width + SpaceOfButtons);
}
/// index from 0 to n
- (CGFloat)xFromRightWithIndex:(NSInteger)index {
    return self.view.bounds.size.width - (index + 1)*(self.buttonSize.width + SpaceOfButtons);
}

- (UIButton *)foldBtn {
    if (_foldBtn == nil) {
        UIButton *button = [self createButtonWithTitle:@"展开" target:self action:@selector(foldBtnAction:)];
        [button setTitle:@"收起" forState:UIControlStateSelected];
        _foldBtn = button;
    }
    return _foldBtn;
}

- (UIButton *)clearBtn {
    if (_clearBtn == nil) {
        UIButton *button = [self createButtonWithTitle:@"清除" target:self action:@selector(clearBtnAction:)];
        _clearBtn = button;
    }
    return _clearBtn;
}

- (UIButton *)toolsBtn {
    if (_toolsBtn == nil) {
        UIButton *button = [self createButtonWithTitle:@"工具" target:self action:@selector(toolsBtnAction:)];
        _toolsBtn = button;
    }
    return _toolsBtn;
}

- (UIButton *)settingBtn {
    if (_settingBtn == nil) {
        UIButton *button = [self createButtonWithTitle:@"设置" target:self action:@selector(settingBtnAction:)];
        _settingBtn = button;
    }
    return _settingBtn;
}

- (UIButton *)filterBtn {
    if (_filterBtn == nil) {
        UIButton *button = [self createButtonWithTitle:@"过滤" target:self action:@selector(filterBtnAction:)];
        _filterBtn = button;
    }
    return _filterBtn;
}

- (UIButton *)hideBtn {
    if (_hideBtn == nil) {
        UIButton *button = [self createButtonWithTitle:@"X" target:self action:@selector(hideBtnAction:)];
        _hideBtn = button;
    }
    return _hideBtn;
}

- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc] init];
        _view.frame = CGRectMake(self.minViewOrigin.x, self.minViewOrigin.y, self.minViewSize.width, self.minViewSize.height);
        _view.backgroundColor = self.backColor;
        _view.layer.borderColor = self.backColor.CGColor;
        _view.clipsToBounds = YES;
        _view.layer.cornerRadius = 5;
        _view.layer.borderWidth = 5;
        
        [_view addSubview:self.clearBtn];
        [_view addSubview:self.hideBtn];
        [_view addSubview:self.foldBtn];
        [_view addSubview:self.toolsBtn];
        [_view addSubview:self.filterBtn];
        [_view addSubview:self.settingBtn];
        [_view addSubview:self.textView];
        [_view addSubview:self.filterTextView];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGes.delegate = self;
        [_view addGestureRecognizer:panGes];
    }
    return _view;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, self.viewSize.width - 10, self.viewSize.height - 40 - 5)];
        _textView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
        _textView.layer.cornerRadius = 5;
        _textView.alpha = 0;
        _textView.editable = NO;
    }
    return _textView;
}

- (UITextView *)filterTextView {
    if (_filterTextView == nil) {
        _filterTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, self.viewSize.width - 10, self.viewSize.height - 40 - 5)];
        _filterTextView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
        _filterTextView.layer.cornerRadius = 5;
        _filterTextView.editable = NO;
        _filterTextView.hidden = YES;
        _filterTextView.alpha = 0;
    }
    return _filterTextView;
}

- (NSMutableArray *)menuItemClasses {
    if (!_menuItemClasses) {
        _menuItemClasses = [NSMutableArray array];
    }
    return _menuItemClasses;
}

- (NSMutableArray *)groupLabels {
    if (!_groupLabels) {
        _groupLabels = [NSMutableArray array];
    }
    return _groupLabels;
}

- (NSMutableArray *)groupLogs {
    if (!_groupLogs) {
        _groupLogs = [NSMutableArray array];
    }
    return _groupLogs;
}

#pragma mark - Actions

- (void)clearBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self clear];
}

- (void)foldBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    
    // 按照大视图位置进行修正
    CGRect fixframe = {self.viewOrigin, self.viewSize};
    fixframe = [self fixFrameToCenter:fixframe];
    self.viewOrigin = fixframe.origin;
    
    // 保存设置
    [SMRLogSettings sharedInstance].ui_orgin = fixframe.origin;
    [SMRLogSettings sharedInstance].menu_fold = !sender.selected;
    [SMRLogSettings syncToDisk];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self refreshUIFramesWithFold:!sender.selected];
    }];
}

- (void)filterBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSArray *titles = [@[@"全部"] arrayByAddingObjectsFromArray:self.groupLabels.reverseObjectEnumerator.allObjects];
    self.lastGroupLabels = titles;
    
    __weak typeof(self) weakSelf = self;
    SMRLogSideMenuView *sideMenu =
    [self createSideMenuViewBySender:sender titles:titles touched:^(SMRLogSideMenuView *menu, UIView *item, NSInteger index) {
        [weakSelf p_filterSideMenuView:menu didTouchedItem:item atIndex:index];
    }];
    [sideMenu layoutIfNeeded];
    [sideMenu showInView:self.view];
}

- (void)settingBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    SMRLogSettings *set = [SMRLogSettings sharedInstance];
    NSString *title_reset = @"恢复默认";
    NSString *title_c = [NSString stringWithFormat:@"时间(%@)", set.menu_log_c?@"ON":@"OFF"];
    NSString *title_r = [NSString stringWithFormat:@"时间轴(%@)", set.menu_log_r?@"ON":@"OFF"];
    NSString *title_l = [NSString stringWithFormat:@"标签(%@)", set.menu_log_l?@"ON":@"OFF"];
    NSString *title_f = [NSString stringWithFormat:@"方法(%@)", set.menu_log_f?@"ON":@"OFF"];
    NSString *title_C = [NSString stringWithFormat:@"内容(%@)", set.menu_log_C?@"ON":@"OFF"];
    
    NSArray *titles = @[title_reset, title_c, title_r, title_l, title_f, title_C];
    __weak typeof(self) weakSelf = self;
    SMRLogSideMenuView *sideMenu = [self createSideMenuViewBySender:sender titles:titles touched:^(SMRLogSideMenuView *menu, UIView *item, NSInteger index) {
        [weakSelf p_settingSideMenuView:menu didTouchedItem:item atIndex:index];
    }];
    [sideMenu layoutIfNeeded];
    [sideMenu showInView:self.view];
}

- (void)toolsBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSMutableArray<NSString *> *titles = [NSMutableArray array];
    [self.menuItemClasses enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class<SMRLogScreenMenuDelegate> cClass = NSClassFromString(obj);
        [titles addObject:[cClass itemName]];
    }];
    __weak typeof(self) weakSelf = self;
    SMRLogSideMenuView *sideMenu = [self createSideMenuViewBySender:sender titles:titles touched:^(SMRLogSideMenuView *menu, UIView *item, NSInteger index) {
        [weakSelf p_toolsSideMenuView:menu didTouchedItem:item atIndex:index];
    }];
    [sideMenu layoutIfNeeded];
    [sideMenu showInView:self.view];
}

- (void)hideBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [SMRLogScreen hide];
}

#pragma mark - SideMenuView

- (SMRLogSideMenuView *)createSideMenuViewBySender:(UIButton *)sender titles:(NSArray<NSString *> *)titles touched:(SMRWebSideMenuTouchedBlock)touched {
    SMRLogSideMenuView *sideMenu = [[SMRLogSideMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sideMenu.maxHeightOfContent = 300;
    sideMenu.trangleStyle = SMRLogSideMenuTrangleStyleLeft;
    sideMenu.trangleOffset = CGPointMake(0, 6);
    sideMenu.itemHeightBlock = ^CGFloat(SMRLogSideMenuView *menu, UIView *item, NSInteger index) {
        return 30;
    };
    sideMenu.menuTouchedBlock = touched;
    NSArray *menuItems = [SMRLogSideMenuView menuItemsWithTitles:titles];
    [sideMenu loadMenuWithItems:menuItems menuWidth:90 origin:CGPointMake(sender.frame.origin.x + sender.frame.size.width + 5, TopOfButtons)];
    return sideMenu;
}

- (void)p_toolsSideMenuView:(SMRLogSideMenuView *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [menu hide];
        NSString *classString = self.menuItemClasses[index];
        Class<SMRLogScreenMenuDelegate> cClass = NSClassFromString(classString);
        [cClass onSelected];
    });
}

- (void)p_settingSideMenuView:(SMRLogSideMenuView *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [menu hide];
        SMRLogSettings *set = [SMRLogSettings sharedInstance];
        switch (index) {
                // 隐藏/显示时间
            case 1: {
                set.menu_log_c = !set.menu_log_c;
            }
                break;
                // 隐藏/显示时间轴
            case 2: {
                set.menu_log_r = !set.menu_log_r;
            }
                break;
                // 隐藏/显示标签
            case 3: {
                set.menu_log_l = !set.menu_log_l;
            }
                break;
                // 隐藏/显示方法
            case 4: {
                set.menu_log_f = !set.menu_log_f;
            }
                break;
                // 隐藏/显示内容
            case 5: {
                set.menu_log_C = !set.menu_log_C;
            }
                break;
                // 恢复默认
            default: {
                [set reset_menu_log];
            }
                break;
        }
        [SMRLogSettings syncToDisk];
        // 刷新日志
        [self p_refreshLogsByFilter];
    });
}

- (void)p_refreshLogsByFilter {
    if (!self.textView.hidden) {
        self.textView.text = [self filterLogs:self.groupLogs groupLabels:nil];
    }
    if (!self.filterTextView.hidden) {
        self.filterTextView.text = [self filterLogs:self.groupLogs groupLabels:self.filterdGroupLables];
    }
}

- (void)p_filterSideMenuView:(SMRLogSideMenuView *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [menu hide];
        if (index == 0) {
            self.filterBtn.selected = NO;
            self.textView.hidden = NO;
            self.filterTextView.hidden = YES;
            self.filterTextView.text = nil;
            [self p_refreshLogsByFilter];
        } else {
            self.filterBtn.selected = YES;
            self.textView.hidden = YES;
            self.filterTextView.hidden = NO;
            self.textView.text = nil;
            self.filterdGroupLables = [self.lastGroupLabels objectsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
            [self p_refreshLogsByFilter];
        }
    });
}

#pragma mark - Move

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIView *swipeView = recognizer.view;
    CGPoint translation = [recognizer translationInView:swipeView.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastTransform = swipeView.transform;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        swipeView.transform = CGAffineTransformTranslate(self.lastTransform, translation.x, translation.y);
//        if ([self judgeWillFoldWithFrame:swipeView.frame]) {
//            NSLog(@"松开自动收起");
//        } else {
//            NSLog(@"取消松开自动收起");
//        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        BOOL autoFold = [self judgeWillFoldWithFrame:swipeView.frame];
        if (autoFold) {
            // 自动变成小视图
            self.foldBtn.selected = NO;
            CGRect fixframe = swipeView.frame;
            fixframe = [self fixFrameToChangeSide:fixframe toSize:self.minViewSize];
            self.viewOrigin = fixframe.origin;
            self.minViewOrigin = fixframe.origin;
            // 保存设置
            [SMRLogSettings sharedInstance].menu_fold = YES;
            [SMRLogSettings sharedInstance].ui_orgin = fixframe.origin;
            [SMRLogSettings sharedInstance].ui_min_orgin = fixframe.origin;
            [SMRLogSettings syncToDisk];
            [UIView animateWithDuration:0.30 animations:^{
                swipeView.frame = fixframe;
            } completion:^(BOOL finished) {
                [self refreshUIFramesWithFold:!self.foldBtn.selected];
            }];
        } else {
            CGRect fixframe = swipeView.frame;
            if (fixframe.size.width > self.minViewSize.width) {
                // 大视图时
                fixframe = [self fixFrameToCenter:fixframe];
                self.viewOrigin = fixframe.origin;
                // 保存设置
                [SMRLogSettings sharedInstance].ui_orgin = fixframe.origin;
                [SMRLogSettings syncToDisk];
            } else {
                // 小视图时
                fixframe = [self fixFrameToSide:fixframe];
                self.viewOrigin = fixframe.origin;
                self.minViewOrigin = fixframe.origin;
                // 保存设置
                [SMRLogSettings sharedInstance].ui_orgin = fixframe.origin;
                [SMRLogSettings sharedInstance].ui_min_orgin = fixframe.origin;
                [SMRLogSettings syncToDisk];
            }
            [UIView animateWithDuration:0.30 animations:^{
                swipeView.frame = fixframe;
            }];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Utils Screen

- (void)loadDefaultMenuItems {
    [self addMenuItemClass:@"SMRLSMForLogOn"];
    [self addMenuItemClass:@"SMRLSMForFlex"];
    [self addMenuItemClass:@"SMRLSMForDokit"];
}

- (void)prepareForUIWithSettings {
    SMRLogSettings *set = [SMRLogSettings sharedInstance];
    if (!CGPointEqualToPoint(CGPointZero, set.ui_orgin)) {
        self.viewOrigin = set.ui_orgin;
    }
    if (!CGPointEqualToPoint(CGPointZero, set.ui_min_orgin)) {
        self.minViewOrigin = set.ui_min_orgin;
    }
    [self refreshUIFramesWithFold:set.menu_fold];
}

- (void)refreshUIFramesWithFold:(BOOL)fold {
    CGSize buttonSize = self.buttonSize;
    self.hideBtn.frame = CGRectMake(5, TopOfButtons, buttonSize.width, buttonSize.height);
    self.toolsBtn.frame = CGRectMake([self xFromLeftWithIndex:1], TopOfButtons, buttonSize.width, buttonSize.height);
    self.clearBtn.frame = CGRectMake([self xFromLeftWithIndex:2], TopOfButtons, buttonSize.width, buttonSize.height);
    self.settingBtn.frame = CGRectMake([self xFromLeftWithIndex:3], TopOfButtons, buttonSize.width, buttonSize.height);
    self.filterBtn.frame = CGRectMake([self xFromLeftWithIndex:4], TopOfButtons, buttonSize.width, buttonSize.height);
    self.foldBtn.frame = CGRectMake(self.viewSize.width - buttonSize.width - 5, TopOfButtons, buttonSize.width, buttonSize.height);
    
    if (fold) {
        self.view.frame = CGRectMake(self.minViewOrigin.x, self.minViewOrigin.y, self.minViewSize.width, self.minViewSize.height);
        self.textView.alpha = 0;
        self.filterTextView.alpha = 0;
        UIColor *alphaColor = [self.backColor colorWithAlphaComponent:0];
        self.view.backgroundColor = alphaColor;
        self.view.layer.borderColor = alphaColor.CGColor;
        self.foldBtn.frame = CGRectMake(0, 0, self.minViewSize.width, self.minViewSize.height);
        self.foldBtn.center = CGPointMake(self.minViewSize.width/2.0, self.minViewSize.height/2.0);
        self.foldBtn.layer.cornerRadius = 16;
        self.foldBtn.selected = !fold;
        self.hideBtn.hidden = YES;
    } else {
        self.view.frame = CGRectMake(self.viewOrigin.x, self.viewOrigin.y, self.viewSize.width, self.viewSize.height);
        self.textView.alpha = 1;
        self.filterTextView.alpha = 1;
        self.view.backgroundColor = self.backColor;
        self.view.layer.borderColor = self.backColor.CGColor;
        self.foldBtn.layer.cornerRadius = 5;
        self.foldBtn.selected = !fold;
        self.hideBtn.hidden = NO;
    }
}

- (BOOL)judgeWillFoldWithFrame:(CGRect)frame {
    CGPoint fixOrigin = frame.origin;
    CGSize originSize = frame.size;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat minLeft = originSize.width/3.0;
    if (originSize.width > self.minViewSize.width) {
        // 左右超出返回YES
        if (fixOrigin.x < -minLeft) {
            return YES;
        } else if (fixOrigin.x + originSize.width > screenWidth + minLeft) {
            return YES;
        }
        // 上下超出返回YES(以状态栏底为界限)
        if (fixOrigin.y < -minLeft + 20) {
            return YES;
        } else if (fixOrigin.y + originSize.height > screenHeight + minLeft) {
            return YES;
        }
    }
    return NO;
}

- (CGRect)fixFrameToCenter:(CGRect)frame {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = (screenWidth - frame.size.width)/2.0;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, margin, 0, -margin);
    return [self fixFrameToAdsorbent:frame insets:insets];
}

- (CGRect)fixFrameToSide:(CGRect)frame {
    CGFloat margin = frame.size.width/2.0;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, -margin, 0, margin);
    return [self fixFrameToAdsorbent:frame insets:insets];
}

- (CGRect)fixFrameToChangeSide:(CGRect)frame toSize:(CGSize)toSize {
    CGFloat margin = toSize.width/2.0;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, -margin, frame.size.height - toSize.height, frame.size.width - margin);
    CGRect originframe = [self fixFrameToAdsorbent:frame insets:insets];
    CGRect fixframe = {originframe.origin, toSize};
    return fixframe;
}

- (CGRect)fixFrameToAdsorbent:(CGRect)frame insets:(UIEdgeInsets)insets {
    CGPoint fixOrigin = frame.origin;
    CGSize originSize = frame.size;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    // 上下左右都挨边
    if (fixOrigin.x <= 0) {
        fixOrigin = CGPointMake(insets.left, fixOrigin.y);
    } else if (fixOrigin.x + originSize.width > screenWidth) {
        fixOrigin = CGPointMake(screenWidth - originSize.width + insets.right, fixOrigin.y);
    }
    if (fixOrigin.y <= 20) {
        fixOrigin = CGPointMake(fixOrigin.x, 20 + insets.top);
    } else if (fixOrigin.y + originSize.height > screenHeight) {
        fixOrigin = CGPointMake(fixOrigin.x, screenHeight - originSize.height + insets.bottom);
    }
    CGRect fixFrame = {fixOrigin, frame.size};
    return fixFrame;
}

- (UIButton *)createButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FontSizeOfButtons];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[self createImageWithColor:[UIColor grayColor] rect:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [button setBackgroundImage:[self createImageWithColor:[UIColor whiteColor] rect:CGRectMake(0, 0, 1, 1)] forState:UIControlStateSelected];
    return button;
}

- (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Utils Options

- (NSString *)filterLogs:(NSArray<SMRLogItem *> *)logs groupLabels:(NSArray<NSString *> *)groupLabels {
    SMRLogSettings *set = [SMRLogSettings sharedInstance];
    NSString *format = [set format_for_menu_log];
    NSMutableString *rtn = [NSMutableString string];
    if (groupLabels) {
        for (NSString *groupLabel in groupLabels) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.label MATCHES[cd] %@", [NSString stringWithFormat:@"%@", groupLabel]];
            NSArray<SMRLogItem *> *rtns = groupLabels?[logs filteredArrayUsingPredicate:predicate]:logs;
            for (SMRLogItem *item in rtns) {
                if (item.rar_time > 0) {
                    format = [set format_for_menu_log_with_r];
                }
                [rtn appendString:[item descriptionWithFormat:format]];
            }
        }
    } else {
        for (SMRLogItem *item in logs) {
            if (item.rar_time > 0) {
                format = [set format_for_menu_log_with_r];
            }
            [rtn appendString:[item descriptionWithFormat:format]];
        }
    }
    return rtn;
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
            UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
            UIWindow *window = application.keyWindow;
            if (window && [window isKindOfClass:[UIView class]]) {
                [window addSubview:self.view];
            }
        }
        self.didShow = YES;
    });
}
- (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.didShow = NO;
        [self.view removeFromSuperview];
    });
}
- (void)addLogItem:(SMRLogItem *)logItem {
    if (self.enableOnlyWhenShow && !self.view.superview) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.didShow == YES) {
            if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
                UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
                UIWindow *window = application.keyWindow;
                if (window && [window isKindOfClass:[UIView class]]) {
                    if (self.view.superview == window) {
                        [self.view.superview bringSubviewToFront:self.view];
                    } else {
                        [window addSubview:self.view];
                    }
                }
            }
        }
        
        if (self.numberOfLine > self.maxNumberOfLine) {
            [self clear];
        }
        NSString *logstr = logItem.description;
        // 展示过滤内容
        NSString *realGroupLabel = logItem.label?:@"默认分组";
        if (!self.filterTextView.hidden && [self.filterdGroupLables containsObject:realGroupLabel]) {
            [self.filterTextView insertText:logstr];
            [self.filterTextView scrollRangeToVisible:NSMakeRange(self.filterTextView.text.length, 1)];
        } else {
            [self.textView insertText:logstr];
            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
        }
        
        self.numberOfLine++;
        
        // 增加分组索引,用来过滤日志
        [self.groupLogs addObject:logItem];
        if (![self.groupLabels containsObject:realGroupLabel]) {
            [self.groupLabels addObject:realGroupLabel];
        }
    });
}
- (void)clear {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.groupLabels = nil;
        self.groupLogs = nil;
        self.numberOfLine = 0;
        self.textView.text = @"";
        self.filterTextView.text = @"";
    });
}

#pragma mark - Utils Options Static

+ (void)show {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen show];
}
+ (void)hide {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen hide];
}

+ (void)addLogItem:(SMRLogItem *)logItem {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen addLogItem:logItem];
}
+ (void)clear {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen clear];
}

@end
