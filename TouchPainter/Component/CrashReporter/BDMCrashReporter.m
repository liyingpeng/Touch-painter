//
//  BDMCrashReporter.m
//  iJobs
//
//  Created by bailu on 15-3-5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMCrashReporter.h"

@implementation BDMCrashReporter

+ (void)setCrashDelegate:(id<CrashSignalCallBackDelegate>)delegate {
    [[CrabCrashReport sharedInstance] setCrashCallBackDelegate:delegate];
}

+ (void)installCrashReporter:(BOOL)enableLog
                      appKey:(NSString *)key
                     channel:(NSString *)channel
{
    CrabCrashReport *reporter = [CrabCrashReport sharedInstance];
    [reporter setDebugEnabled:enableLog];
//    据说这个接口服务端还没有调好，暂时不能用。
//    [reporter setStackSymbolsEnabled:YES];
    [reporter setBuildnumber:kBuildVersion];
    [reporter initCrashReporterWithAppKey:key AndVersion:kAppVersion AndChannel:channel];
    
}

+ (void)setUser:(NSString *)user
{
    [[CrabCrashReport sharedInstance] setAppUsername:user];
}

@end
