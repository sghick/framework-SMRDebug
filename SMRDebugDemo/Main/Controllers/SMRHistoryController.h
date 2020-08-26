//
//  SMRHistoryController.h
//  appdebuger
//
//  Created by Tinswin on 2019/8/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <SMRBaseCore/SMRBaseCore.h>
#import "SMREnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRHistoryController : SMRNavFatherController

@property (assign, nonatomic) SMRHistoryType type;
@property (copy  , nonatomic) void(^selectBlock)(NSString *history);

@end

NS_ASSUME_NONNULL_END
