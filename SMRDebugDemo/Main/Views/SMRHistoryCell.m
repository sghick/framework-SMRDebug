//
//  SMRHistoryCell.m
//  appdebuger
//
//  Created by Tinswin on 2019/8/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRHistoryCell.h"
#import <SMRBaseCore/SMRBaseCore.h>
#import "PureLayout.h"
#import "SMRHistory.h"

@interface SMRHistoryCell ()

@property (strong, nonatomic) UILabel *nameLb;
@property (strong, nonatomic) UILabel *timeLb;
@property (strong, nonatomic) UILabel *contentLb;
@property (assign, nonatomic) BOOL didLayout;

@end

@implementation SMRHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.nameLb];
        [self addSubview:self.timeLb];
        [self addSubview:self.contentLb];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints {
    if (!self.didLayout) {
        self.didLayout = YES;
        [self.nameLb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        [self.nameLb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.contentLb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
            [self.contentLb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
            [self.contentLb autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLb withOffset:10];
            [self.contentLb autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.timeLb withOffset:-10];
        }];
        
        [self.timeLb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [self.timeLb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    }
    [super updateConstraints];
}

#pragma mark - Setters

- (void)setHistory:(SMRHistory *)history {
    _history = history;
    self.nameLb.text = history.name;
    self.timeLb.text = [SMRUtils convertToStringFromTimerInterval:history.last_update_time format:@"yyyy.MM.dd hh:mm:ss"];
    self.contentLb.text = history.content;
}

#pragma mark - Getters

- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [[UILabel alloc] init];
        _nameLb.numberOfLines = 0;
        _nameLb.textColor = [UIColor darkGrayColor];
        _nameLb.font = [UIFont systemFontOfSize:15];
    }
    return _nameLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc] init];
        _timeLb.textColor = [UIColor darkGrayColor];
        _timeLb.font = [UIFont systemFontOfSize:11];
    }
    return _timeLb;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [[UILabel alloc] init];
        _contentLb.numberOfLines = 0;
        _contentLb.textColor = [UIColor blackColor];
        _contentLb.font = [UIFont systemFontOfSize:13];
    }
    return _contentLb;
}

@end
