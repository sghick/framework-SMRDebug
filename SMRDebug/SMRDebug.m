//
//  SMRDebug.m
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDebug.h"
#import "FLEX.h"
#import "SMRLogSys.h"
#import "SMRLogScreen.h"

@implementation SMRDebug

NSString * const _kDebugStatusForScreen = @"kDgStForSMRScreen";

+ (void)startDebugIfNeeded {
    SMRDebugMode status = [self deubgMode];
    switch (status) {
        case SMRDebugModeNone: {
            [SMRLogScreen sharedScreen].enableOnlyWhenShow = NO;
            [SMRLogScreen hide];
            [SMRLogSys setDebug:NO];
            [[FLEXManager sharedManager] setNetworkDebuggingEnabled:NO];
        }
            break;
        case SMRDebugModeAll: {
            [SMRLogScreen sharedScreen].enableOnlyWhenShow = NO;
            [SMRLogScreen show];
            [SMRLogSys setDebug:YES];
            [[FLEXManager sharedManager] setNetworkDebuggingEnabled:YES];
        }
            break;
        case SMRDebugModeBackgoround: {
            [SMRLogScreen hide];
        }
            break;
        default:
            break;
    }
}

+ (BOOL)setDebugModelWithURL:(NSURL *)url allowScheme:(NSString *)allowScheme uk:(NSString *)uk {
    if (!url) {
        return NO;
    }
    if (allowScheme && ![allowScheme isEqualToString:url.scheme]) {
        return NO;
    }
    
    if ([@"debug" isEqualToString:url.host]) {
        NSDictionary *params = [self p_debug_parseredParamsWithURL:url];
        NSString *status = params[@"status"];
        NSString *puk = params[@"uk"];
        NSString *ck = params[@"ck"];
        // 验证身份,如果代码中使用uk,则打开的链接中必须有uk且对应上才能打开.
        if (!uk || (uk && [uk isEqualToString:puk])) {
            if ([ck isEqualToString:[self createCheckCodeWithKey:uk date:[NSDate date]]]) {
                [[NSUserDefaults standardUserDefaults] setInteger:status.integerValue forKey:_kDebugStatusForScreen];
                [self startDebugIfNeeded];
                return YES;
            }
        }
    }
    return NO;
}

+ (void)setDebug:(SMRDebugMode)debug {
    [[NSUserDefaults standardUserDefaults] setInteger:debug forKey:_kDebugStatusForScreen];
    [self startDebugIfNeeded];
}

+ (SMRDebugMode)deubgMode {
    SMRDebugMode status = [[NSUserDefaults standardUserDefaults] integerForKey:_kDebugStatusForScreen];
    return status;
}

+ (NSDictionary *)p_debug_parseredParamsWithURL:(NSURL *)url {
    NSString *urlQuery = url.query;
    NSMutableDictionary *queryStringDictionary = [NSMutableDictionary dictionary];
    NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        if (pairComponents.count >= 2) {
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [[pairComponents objectAtIndex:1] stringByRemovingPercentEncoding];
            [queryStringDictionary setObject:value forKey:key];
        }
    }
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:queryStringDictionary];
    return params;
}

+ (NSString *)old_createCheckCodeWithKey:(NSString *)key date:(NSDate *)date {
    NSDate *nowDate = date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *compt = [calendar components:unitFlags fromDate:nowDate];
    double up = ((compt.year+[self k:key i:compt.year])%100)*10000000+
    (compt.month+[self k:key i:compt.month])%12*100000+
    (compt.day+[self k:key i:compt.day])%31*1000+
    (compt.hour+[self k:key i:compt.hour])%24*10+
    (compt.minute+[self k:key i:compt.minute])%60/10;
    NSInteger dp = compt.minute%10+10;
    double ud = 0;
    double va = 0;
    NSInteger un = 100000;
    for (int i = 0; i < 6; i++) {
        up /= dp;
        ud = ((NSInteger)floor(up))%10;
        va += ud*un;
        un /= 10;
    }
    return [NSString stringWithFormat:@"%06.0f", va];
}

+ (NSString *)createCheckCodeWithKey:(NSString *)key date:(NSDate *)date {
    NSDate *nowDate = date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *compt = [calendar components:unitFlags fromDate:nowDate];
    double up = ((compt.year+[self k:key j:compt.year])%100)*10000000+
                (compt.month+[self k:key j:compt.month])%12*100000+
                (compt.day+[self k:key j:compt.day])%31*1000+
                (compt.hour+[self k:key j:compt.hour])%24*10+
                (compt.minute+[self k:key j:compt.minute])%60/10;
    NSInteger dp = compt.minute%10+10;
    double ud = 0;
    double va = 0;
    NSInteger un = 100000;
    for (int i = 0; i < 6; i++) {
        up /= dp;
        ud = ((NSInteger)floor(up))%10;
        va += ud*un;
        un /= 10;
    }
    return [NSString stringWithFormat:@"%06.0f", va];
}

+ (NSInteger)k:(NSString *)k i:(NSInteger)i {
    NSInteger a = 0;
    const char *charNum = [k cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i = 0; i < k.length; i++) {
        a += i*charNum[i];
        a *= i;
        a -= charNum[i]%i;
    }
    return a;
}

+ (NSInteger)k:(NSString *)k j:(NSInteger)j {
    NSInteger a = 0;
    const char *charNum = [k cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i = 0; i < k.length; i++) {
        a += j*charNum[i];
        a *= j;
        a -= charNum[i]%j;
    }
    return a;
}

@end
