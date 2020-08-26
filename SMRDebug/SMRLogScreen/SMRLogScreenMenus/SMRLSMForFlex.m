//
//  SMRLSMForFlex.m
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/6/4.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRLSMForFlex.h"
#import "FLEX.h"

@implementation SMRLSMForFlex

+ (NSString *)itemName {
    FLEXManager *flex = [FLEXManager sharedManager];
    NSString *name = [NSString stringWithFormat:@"Flex(%@)", !flex.isHidden?@"ON":@"OFF"];
    return name;
}

+ (void)onSelected {
    [[FLEXManager sharedManager] toggleExplorer];
}

@end
