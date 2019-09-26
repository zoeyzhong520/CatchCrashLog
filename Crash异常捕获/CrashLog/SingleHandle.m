//
//  SingleHandle.m
//  Crash异常捕获
//
//  Created by zhifu360 on 2019/9/25.
//  Copyright © 2019 ZZJ. All rights reserved.
//

#import "SingleHandle.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "CrashLogConst.h"
#import "UncaughtExceptionHandler.h"

@implementation SingleHandle

+ (void)saveCreash:(NSString *)exceptionInfo
{
    NSString *_libPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SigCrash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]) {
        //创建新文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f",a];
    
    NSString *savePath = [_libPath stringByAppendingFormat:@"/error%@",timeString];
    
    BOOL success = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"YES success: %d",success);
}

@end

void SignalExceptionHandler(int signal)
{
    //信号出错时候的回调
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void * callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i < frames; i ++) {
        [mstr appendFormat:@"%s\n",strs[i]];
    }
    [SingleHandle saveCreash:mstr];
}

void InstallSignalHandler(void)
{
    //本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业, 这时它们与控制终端不再关联
    signal(SIGHUP, SignalExceptionHandler);
    //程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl-C)时发出，用于通知前台进程组终止进程
    signal(SIGINT, SignalExceptionHandler);
    //和SIGINT类似, 但由QUIT字符(通常是Ctrl-)来控制. 进程在因收到SIGQUIT退出时会产生core文件, 在这个意义上类似于一个程序错误信号
    signal(SIGQUIT, SignalExceptionHandler);
    
    //调用abort函数生成的信号
    signal(SIGABRT, SignalExceptionHandler);
    //执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号
    signal(SIGILL, SignalExceptionHandler);
    //试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据
    signal(SIGSEGV, SignalExceptionHandler);
    //在发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误
    signal(SIGFPE, SignalExceptionHandler);
    //非法地址, 包括内存地址对齐(alignment)出错。比如访问一个四个字长的整数, 但其地址不是4的倍数。它与SIGSEGV的区别在于后者是由于对合法存储地址的非法访问触发的(如访问不属于自己存储空间或只读存储空间)
    signal(SIGBUS, SignalExceptionHandler);
    //管道破裂。这个信号通常在进程间通信产生，比如采用FIFO(管道)通信的两个进程，读管道没打开或者意外终止就往管道写，写进程会收到SIGPIPE信号。此外用Socket通信的两个进程，写进程在写Socket的时候，读进程已经终止
    signal(SIGPIPE, SignalExceptionHandler);
}
