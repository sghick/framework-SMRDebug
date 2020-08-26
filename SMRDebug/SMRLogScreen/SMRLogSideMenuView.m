//
//  SMRLogSideMenuView.m
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRLogSideMenuView.h"
#import "SMRDebugBundle.h"

@interface SMRLogSideMenuView () <
UITableViewDelegate,
UITableViewDataSource >

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *trangleView;

@end

@implementation SMRLogSideMenuView

@synthesize tableView = _tableView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [UIScreen mainScreen].bounds;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    _scrollEnabled = YES;
    _maxHeightOfContent = self.bounds.size.height;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.trangleView];
    [self.contentView addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 44;
    UIView *view = self.menuItems[indexPath.row];
    if (self.itemHeightBlock) {
        itemHeight = self.itemHeightBlock(self, view, indexPath.row);
    }
    view.frame = CGRectMake(0, 0, self.menuWidth, itemHeight);
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfDefaultCell"];
    if (self.menuItems.count > indexPath.row) {
        UIView *item = self.menuItems[indexPath.row];
        [cell.contentView addSubview:item];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.menuTouchedBlock) {
        UIView *view = self.menuItems[indexPath.row];
        self.menuTouchedBlock(self, view, indexPath.row);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - Utils

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [view addSubview:self.parentView];
    [view addSubview:self];
    
    [self showAnimations];
}

- (void)hide {
    if (self.menuWillDismissBlock) {
        self.menuWillDismissBlock(self);
    }
    [self hideAnimations];
}

- (void)showAnimations {
    self.contentView.alpha = 0.0f;
    self.parentView.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.contentView.alpha = 1.0f;
        weakSelf.parentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideAnimations {
    [self endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.parentView.alpha = 0.0f;
        weakSelf.contentView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.parentView removeFromSuperview];
    }];
}

#pragma mark - Style - Trangle

- (CGSize)trangleSize {
    switch (self.trangleStyle) {
        case SMRLogSideMenuTrangleStyleUp:
        case SMRLogSideMenuTrangleStyleDown: {
            return CGSizeMake(14, 10);
        }
            break;
        case SMRLogSideMenuTrangleStyleLeft:
        case SMRLogSideMenuTrangleStyleRight: {
            return CGSizeMake(10, 14);
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
}

- (CGAffineTransform)trangleTransform {
    switch (self.trangleStyle) {
        case SMRLogSideMenuTrangleStyleUp: {
            return CGAffineTransformMakeRotation(0);
        }
            break;
        case SMRLogSideMenuTrangleStyleDown: {
            return CGAffineTransformMakeRotation(M_PI);
        }
            break;
        case SMRLogSideMenuTrangleStyleLeft: {
            return CGAffineTransformMakeRotation(-M_PI_2);
        }
            break;
        case SMRLogSideMenuTrangleStyleRight: {
            return CGAffineTransformMakeRotation(M_PI_2);
        }
            break;
        default:
            break;
    }
    return CGAffineTransformMakeRotation(0);
}

- (CGPoint)trangleOffsetForReal:(CGSize)tbsize tsize:(CGSize)tsize {
    BOOL reverse = self.trangleOffsetReverse;
    CGPoint offset = self.trangleOffset;
    switch (self.trangleStyle) {
        case SMRLogSideMenuTrangleStyleUp: {
            return CGPointMake((reverse ? (tbsize.width - tsize.width - offset.x) : offset.x),
                               offset.y - tsize.height);
        }
            break;
        case SMRLogSideMenuTrangleStyleDown: {
            return CGPointMake((reverse ? (tbsize.width - tsize.width - offset.x) : offset.x),
                               offset.y + tbsize.height);
        }
            break;
        case SMRLogSideMenuTrangleStyleLeft: {
            return CGPointMake(offset.x - tsize.width,
                               reverse ? (tbsize.height - tsize.height - offset.y) : offset.y);
        }
            break;
        case SMRLogSideMenuTrangleStyleRight: {
            return CGPointMake(offset.x + tbsize.width,
                               reverse ? (tbsize.height - tsize.height - offset.y) : offset.y);
        }
            break;
        default:
            break;
    }
    return CGPointZero;
}

#pragma mark - Setters

- (void)loadMenuWithItems:(NSArray<UIView *> *)menuItems menuWidth:(CGFloat)menuWidth origin:(CGPoint)origin {
    _menuItems = menuItems;
    _menuWidth = menuWidth;

    CGFloat height = 44*menuItems.count;
    if (self.itemHeightBlock) {
        NSInteger index = 0;
        height = 0;
        for (UIView *view in menuItems) {
            height += self.itemHeightBlock(self, view, index);
            index++;
        }
    }
    CGFloat tbh = MAX(self.minHeightOfContent, MIN(height, self.maxHeightOfContent));
    // 计算content
    self.contentView.frame = CGRectMake(origin.x, origin.y, menuWidth, height);
    self.tableView.frame = CGRectMake(0, 0, menuWidth, tbh);
    
    // 计算trangle
    CGSize tsize = [self trangleSize];
    CGAffineTransform ttransform = [self trangleTransform];
    CGPoint toffset = [self trangleOffsetForReal:CGSizeMake(menuWidth, self.tableView.frame.size.height) tsize:tsize];
    self.trangleView.transform = ttransform;
    self.trangleView.frame = CGRectMake(toffset.x, toffset.y, tsize.width, tsize.height);
    
    [self.tableView reloadData];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.tableView.scrollEnabled = scrollEnabled;
}

#pragma mark - Getters

- (UIView *)parentView {
    if (_parentView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        view.userInteractionEnabled = YES;
        _parentView = view;
    }
    return _parentView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *view = [[UIView alloc] init];
        _contentView = view;
    }
    return _contentView;
}

- (UIImageView *)trangleView {
    if (!_trangleView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [SMRDebugBundle imageNamed:@"menu_alert_trangle@3x"];
        _trangleView = view;
    }
    return _trangleView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = _scrollEnabled;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.layer.cornerRadius = 3;
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - Factory

+ (NSArray<UIView *> *)menuItemsWithTitles:(NSArray<NSString *> *)titles {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *obj in titles) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.text = [@"     " stringByAppendingString:obj];
        
        [items addObject:label];
    }
    return items;
}

@end
