//
//  UncaughtExceptionHandler.m
//  Crash异常捕获
//
//  Created by zhifu360 on 2019/9/25.
//  Copyright © 2019 ZZJ. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "CrashLogConst.h"

@implementation UncaughtExceptionHandler

+ (void)saveCreash:(NSString *)exceptionInfo
{
    NSString *_libPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OCCrash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]) {
        //创建新文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f",a];
    
    NSString *savePath = [_libPath stringByAppendingFormat:@"/error%@.log",timeString];
    
    BOOL success = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"YES success: %d",success);
}

void HandleException(NSException *exception)
{
    //异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    //出现异常的原因
    NSString *reason = [exception reason];
    //异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason: %@\nException name: %@\nException stack: %@",reason,name,stackArray];
    
    NSLog(@"%@",exceptionInfo);
    
    [UncaughtExceptionHandler saveCreash:exceptionInfo];
}

void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
}

@end
