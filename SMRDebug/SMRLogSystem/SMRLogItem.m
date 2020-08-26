//
//  SMRLogItem.m
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/27.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRLogItem.h"

@implementation SMRLogItem

- (NSDictionary *)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"create_time"] = [self dateToString:self.create_time];
    dict[@"rar_time"] = [self rarToString:self.rar_time];
    dict[@"label"] = self.label;
    dict[@"fcname"] = self.fcname;
    dict[@"content"] = self.content;
    return [dict copy];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSS"];
    return dateformat;
}

- (NSString *)dateToString:(NSTimeInterval)time {
    return [[self.class dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

- (NSString *)rarToString:(NSTimeInterval)rar {
    return [NSString stringWithFormat:@"%.4f", rar];
}

- (NSString *)description {
    NSString *format = @"c [l]:f C\n";
    if (self.rar_time > 0) {
        format = @"c (r) [l]:f C\n";
    }
    return [self descriptionWithFormat:format];
}

- (NSString *)descriptionWithFormat:(NSString *)format {
    NSString *fc = format;
    // 转义一下
    fc = [fc stringByReplacingOccurrencesOfString:@"c" withString:@"\\c"];
    fc = [fc stringByReplacingOccurrencesOfString:@"r" withString:@"\\r"];
    fc = [fc stringByReplacingOccurrencesOfString:@"l" withString:@"\\l"];
    fc = [fc stringByReplacingOccurrencesOfString:@"f" withString:@"\\f"];
    fc = [fc stringByReplacingOccurrencesOfString:@"C" withString:@"\\C"];
    // 替换
    fc = [fc stringByReplacingOccurrencesOfString:@"\\c"
                                       withString:[self dateToString:self.create_time]];
    fc = [fc stringByReplacingOccurrencesOfString:@"\\r"
                                       withString:[self rarToString:self.rar_time]];
    fc = [fc stringByReplacingOccurrencesOfString:@"\\l"
                                       withString:self.label?:@""];
    fc = [fc stringByReplacingOccurrencesOfString:@"\\f"
                                       withString:self.fcname?:@""];
    fc = [fc stringByReplacingOccurrencesOfString:@"\\C" withString:self.content?:@""];
    return fc;
}

- (NSString *)JSONString {
    NSDictionary *dict = [self dictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

@end
