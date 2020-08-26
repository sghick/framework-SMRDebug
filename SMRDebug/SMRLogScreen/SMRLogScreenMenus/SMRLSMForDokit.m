//
//  SMRLSMForDokit.m
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/6/4.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRLSMForDokit.h"
#import <DoraemonKit/DoraemonKit.h>

@implementation SMRLSMForDokit

+ (NSString *)itemName {
    DoraemonManager *manager = [DoraemonManager shareInstance];
    NSString *name = [NSString stringWithFormat:@"Dokit(%@)", manager.isShowDoraemon?@"ON":@"OFF"];
    return name;
}

static BOOL _didSelected = NO;
+ (void)onSelected {
    DoraemonManager *manager = [DoraemonManager shareInstance];
    if (!_didSelected) {
        _didSelected = YES;
        [manager install];
    } else {
        manager.isShowDoraemon ? [manager hiddenDoraemon] : [manager showDoraemon];
    }
}

@end
