//
//  SMRLogItem.h
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/27.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRLogItem : NSObject

@property (assign, nonatomic) NSTimeInterval create_time;   ///< 创建时间(c)
@property (assign, nonatomic) NSTimeInterval rar_time;      ///< 与上条时间差(r)
@property (copy  , nonatomic) NSString *label;              ///< 标签(l)
@property (copy  , nonatomic) NSString *fcname;             ///< 方法名(f)
@property (copy  , nonatomic) NSString *content;            ///< 内容(C)

/** format:c(r)[l]:f C */
- (NSString *)description;
- (NSString *)descriptionWithFormat:(NSString *)format;

- (NSString *)JSONString;

@end

NS_ASSUME_NONNULL_END
