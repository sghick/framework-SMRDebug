//
//  SMRLogSys.m
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 ibaodashi. All rights reserved.
//

#import "SMRLogSys.h"
#import "SMRLogItem.h"
#import "SMRLogScreen.h"

static NSString *const kSMRLogSysDebug = @"kSMRLogSysDebug";
static bool _staticLogSysDebug = NO;

@implementation SMRLogSys

+ (void)load {
    _staticLogSysDebug = [[NSUserDefaults standardUserDefaults] boolForKey:kSMRLogSysDebug];
}

+ (NSString *)logTypeSMRLogDocPath {
    NSString *fileDoc = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SMRLog"];
    return fileDoc;
}

+ (NSString *)logTypeNSLogDocPath {
    NSString *fileDoc = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"NSLog"];
    return fileDoc;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSS"];
    return dateformat;
}

#pragma mark - Public
+ (BOOL)debug {
    return _staticLogSysDebug;
}

+ (void)setDebug:(BOOL)debug {
    _staticLogSysDebug = debug;
    [[NSUserDefaults standardUserDefaults] setBool:debug forKey:kSMRLogSysDebug];
}

+ (void)toggleDebug {
    [self setDebug:![self debug]];
}

+ (void)outputSMRLogToFile:(NSString *)log fcName:(NSString *)fcName label:(NSString *)label {
    if (![self debug]) {
        return;
    }
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *docPath = [self logTypeSMRLogDocPath];
    if (![defaultManager fileExistsAtPath:docPath]) {
        [defaultManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmm"];
    NSString *fileName = [NSString stringWithFormat:@"%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString *logFilePath = [docPath stringByAppendingPathComponent:fileName];
    if (![defaultManager fileExistsAtPath:logFilePath]) {
        [defaultManager createFileAtPath:logFilePath contents:nil attributes:nil];
    }
    
    // 创建logitem
    NSTimeInterval dt = [[NSDate date] timeIntervalSince1970];
    SMRLogItem *logitem = [[SMRLogItem alloc] init];
    logitem.create_time = dt;
    logitem.rar_time = (_beginTime > 0) ? (dt - _beginTime) : 0;
    logitem.fcname = fcName;
    logitem.label = label;
    logitem.content = log;
    
    // 保存至文件
    NSString *content = [logitem.JSONString stringByAppendingString:@",\n"];
    NSData *buffer = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    if (!outFile) {
        NSLog(@"获取文件句柄失败");
        return;
    }
    [outFile seekToEndOfFile];
    [outFile writeData:buffer];
    [outFile closeFile];
    
    // 输出到日志视图
    [SMRLogScreen addLogItem:logitem];
}

+ (void)outputNSlogToFile {
    if (![self debug]) {
        return;
    }
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *docPath = [self logTypeNSLogDocPath];
    if (![defaultManager fileExistsAtPath:docPath]) {
        [defaultManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmm"];
    NSString *fileName = [NSString stringWithFormat:@"%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString *logFilePath = [docPath stringByAppendingPathComponent:fileName];
    
    // 先删除已经存在的文件
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

#pragma mark - Others

static NSTimeInterval _beginTime = 0;
+ (void)setBeginTime {
    _beginTime = [[NSDate date] timeIntervalSince1970];
    [self outputSMRLogToFile:@"时间轴起点" fcName:@"" label:@"Begin"];
}

+ (void)printFilePath {
    NSLog(@"SMRLogPath:%@", [self logTypeSMRLogDocPath]);
    NSLog(@"NSLogPath:%@", [self logTypeNSLogDocPath]);
}

+ (BOOL)clear {
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSArray<NSString *> *fileDocs = @[[self logTypeSMRLogDocPath], [self logTypeNSLogDocPath]];
    for (NSString *fd in fileDocs) {
        if ([manager fileExistsAtPath:fd]) {
            return [manager removeItemAtPath:fd error:nil];
        }
    }
    return YES;
}

@end
