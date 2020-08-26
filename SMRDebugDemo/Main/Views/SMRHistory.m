//
//  SMRHistory.m
//  appdebuger
//
//  Created by Tinswin on 2019/8/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRHistory.h"
#import "NSObject+SMRDB.h"

@implementation SMRHistory

+ (NSArray<SMRHistory *> *)selectOrderByLastUpdateTimeDescWithType:(SMRHistoryType)type {
    NSString *where = @"WHERE type=(?) ORDER BY last_update_time DESC";
    //    NSString *where = @"WHERE type=(?) ORDER BY use_count DESC";
    return [SMRHistory selectWhere:where paramsArray:@[@(type)]];
}

@end
