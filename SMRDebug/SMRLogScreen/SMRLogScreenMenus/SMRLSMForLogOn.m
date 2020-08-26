//
//  SMRLSMForLogOn.m
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/6/4.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRLSMForLogOn.h"
#import "SMRLogSys.h"

@implementation SMRLSMForLogOn

+ (NSString *)itemName {
    NSString *name = [NSString stringWithFormat:@"Log(%@)", SMRLogSys.debug?@"ON":@"OFF"];
    return name;
}

+ (void)onSelected {
    [SMRLogSys toggleDebug];
}

@end
