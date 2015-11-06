//
//  BDMUncaughtExceptionHandler.m
//  iJobs
//
//  Created by sunshiwen on 15-3-9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMUncaughtExceptionHandler.h"
#import "BDMMobStatUtility.h"

#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@interface BDMUncaughtExceptionHandler ()
@property BOOL dismissed; //点击弹窗的退出按钮
@end

@implementation BDMUncaughtExceptionHandler

//获得堆栈信息
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128); // 获得堆栈信息
    char **strs = backtrace_symbols(callstack, frames); //堆栈信息转为字符串
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]]; //堆栈信息数组
    }
    free(strs);
    
    return backtrace;
}

+ (void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}

//crash 弹窗回调
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0)
    {
        self.dismissed = YES;
    }
}

- (void)validateAndSaveCriticalApplicationData
{
    
}

- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationData];
    
    /** 取消弹窗功能
    //弹窗
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
     message:[NSString stringWithFormat:NSLocalizedString(
                                                          @"You can try to continue but the application may be unstable.\n\n"
                                                          @"Debug details follow:\n%@\n%@", nil),
              [exception reason],
              [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Quit", nil)
     otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    [alert show];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    //阻塞当前线程直到用户点击了退出，否则执行其他消息循环
    while (!self.dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
        }
    }
    
    //以下是点击退出的处理
    CFRelease(allModes);
    */
    NSArray *array = [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey];
    NSString *message = [NSString stringWithFormat:@"==异常崩溃报告==\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                         exception.name,exception.reason,[array componentsJoinedByString:@"\n"]];
    //发送日志
    [BDMMobStatUtility logCrashWithMessage:message];
    
    //数据还原
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]); //结束进程
    }
    else
    {
        [exception raise]; //处理异常
    }
}


@end

//系统异常处理
void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount); //原子加1
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    //下面两种方法任选
//    NSArray *callStack = [BDMUncaughtExceptionHandler backtrace];
    NSArray *callStack = [exception callStackSymbols];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    NSException *wrapException = [NSException exceptionWithName:[exception name]
                                                         reason:[exception reason]
                                                       userInfo:userInfo];
    
    BDMUncaughtExceptionHandler *handler = [[BDMUncaughtExceptionHandler alloc] init];
    [handler performSelectorOnMainThread:@selector(handleException:)
                              withObject:wrapException
                           waitUntilDone:YES];
}

//异常信号量处理
void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [BDMUncaughtExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    NSString *reason = [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil), signal];
    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                     reason:reason
                                                   userInfo:userInfo];
    
    BDMUncaughtExceptionHandler *handler = [[BDMUncaughtExceptionHandler alloc] init];
    [handler performSelectorOnMainThread:@selector(handleException:)
                              withObject:exception
                           waitUntilDone:YES];
}

//注册异常处理
void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
