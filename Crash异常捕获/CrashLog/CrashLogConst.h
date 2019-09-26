//
//  CrashLogConst.h
//  Crash异常捕获
//
//  Created by zhifu360 on 2019/9/25.
//  Copyright © 2019 ZZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UncaughtExceptionHandlerSignalExceptionName;
extern NSString * const UncaughtExceptionHandlerSignalKey;
extern NSString * const UncaughtExceptionHandlerAddressesKey;

extern const volatile int32_t UncaughtExceptionCount;
extern const int32_t UncaughtExceptionMaximum;

extern const NSInteger UncaughtExceptionHandlerSkipAddressCount;
extern const NSInteger UncaughtExceptionHandlerReportAddressCount;



