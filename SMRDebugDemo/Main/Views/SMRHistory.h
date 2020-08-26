//
//  SMRHistory.h
//  appdebuger
//
//  Created by Tinswin on 2019/8/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMREnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRHistory : NSObject

@property (copy  , nonatomic) NSString *name;
@property (copy  , nonatomic) NSString *content;
@property (assign, nonatomic) SMRHistoryType type;
@property (assign, nonatomic) NSTimeInterval last_update_time;
@property (assign, nonatomic) NSInteger use_count;

/// 根据type按时间倒序查询
+ (NSArray<SMRHistory *> *)selectOrderByLastUpdateTimeDescWithType:(SMRHistoryType)type;

@end

NS_ASSUME_NONNULL_END
