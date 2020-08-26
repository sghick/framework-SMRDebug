//
//  SMRLogSettings.m
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/22.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRLogSettings.h"

@implementation SMRLogSettings

static NSString * const kUDForSMRLogSettings = @"kUDForSMRLogSettings";

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SMRLogSettings *_logSettings = nil;
    dispatch_once(&onceToken, ^{
        _logSettings = [SMRLogSettings settingsFromDisk];
        if (!_logSettings) {
            _logSettings = [[SMRLogSettings alloc] init];
            _logSettings.menu_fold = YES;
            [_logSettings reset_menu_log];
        }
    });
    return _logSettings;
}

- (void)reset_menu_log {
    self.menu_log_c = YES;
    self.menu_log_r = YES;
    self.menu_log_l = YES;
    self.menu_log_f = YES;
    self.menu_log_C = YES;
}

- (NSString *)format_for_menu_log_with_r {
    return [self format_for_menu_log:YES];
}

- (NSString *)format_for_menu_log {
    return [self format_for_menu_log:NO];
}

- (NSString *)format_for_menu_log:(BOOL)use_r {
    NSString *format = @"";
    if (self.menu_log_c) {
        format = [format stringByAppendingString:@"c"];
    }
    if (use_r && self.menu_log_r) {
        format = [format stringByAppendingFormat:@"%@(r)", format.length?@" ":@""];
    }
    if (self.menu_log_l) {
        format = [format stringByAppendingFormat:@"%@[l]", format.length?@" ":@""];
    }
    if (self.menu_log_f) {
        format = [format stringByAppendingFormat:@"%@f", format.length?@" ":@""];
    }
    if (self.menu_log_C) {
        format = [format stringByAppendingFormat:@"%@C", format.length?@" ":@""];
    }
    if (format.length > 0) {
        format = [format stringByAppendingString:@"\n"];
    }
    return format;
}

+ (SMRLogSettings *)settingsFromDisk {
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:kUDForSMRLogSettings];
    SMRLogSettings *settings = [SMRLogSettings settingWithDictionary:info];
    return settings;
}

+ (void)syncToDisk {
    NSDictionary *info = [[SMRLogSettings sharedInstance] settingDictionary];
    if (info) {
        [[NSUserDefaults standardUserDefaults] setObject:info forKey:kUDForSMRLogSettings];
    }
}

#pragma mark -

- (NSDictionary *)settingDictionary {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    info[@"menu_fold"] = @(self.menu_fold);
    info[@"menu_log_c"] = @(self.menu_log_c);
    info[@"menu_log_r"] = @(self.menu_log_r);
    info[@"menu_log_l"] = @(self.menu_log_l);
    info[@"menu_log_f"] = @(self.menu_log_f);
    info[@"menu_log_C"] = @(self.menu_log_C);
    info[@"ui_orgin"] = NSStringFromCGPoint(self.ui_orgin);
    info[@"ui_min_orgin"] = NSStringFromCGPoint(self.ui_min_orgin);
    
    return [info copy];
}

+ (SMRLogSettings *)settingWithDictionary:(NSDictionary *)info {
    if (!info) {
        return nil;
    }
    SMRLogSettings *settings = [[SMRLogSettings alloc] init];
    
    settings.menu_fold = ((NSNumber *)info[@"menu_fold"]).boolValue;
    settings.menu_log_c = ((NSNumber *)info[@"menu_log_c"]).boolValue;
    settings.menu_log_r = ((NSNumber *)info[@"menu_log_r"]).boolValue;
    settings.menu_log_l = ((NSNumber *)info[@"menu_log_l"]).boolValue;
    settings.menu_log_f = ((NSNumber *)info[@"menu_log_f"]).boolValue;
    settings.menu_log_C = ((NSNumber *)info[@"menu_log_C"]).boolValue;
    settings.ui_orgin = CGPointFromString(info[@"ui_orgin"]);
    settings.ui_min_orgin = CGPointFromString(info[@"ui_min_orgin"]);
    
    return settings;
}

@end
