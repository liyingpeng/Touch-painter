//
//  BDMUncaughtExceptionHandler.h
//  iJobs
//
//  Created by sunshiwen on 15-3-9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMUncaughtExceptionHandler : NSObject
+ (void)installUncaughtExceptionHandler;
@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);