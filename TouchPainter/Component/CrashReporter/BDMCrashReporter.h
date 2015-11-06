//
//  BDMCrashReporter.h
//  iJobs
//
//  Created by bailu on 15-3-5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrabCrashReport.h"

/*!
 *  @brief  App具备收集崩溃信息功能 目前使用Crab平台:http://crab.baidu.com
 *          前期准备: 
 *                  1、需要在Crab平台申请产品线，得到AppKey;
 *                  2、需要在编译脚本中修改 Info.plist 中 CFBundleVersion 的值为整数(Jenkins的Build Number会自动递增)。
 *
 */
@interface BDMCrashReporter : NSObject

/*!
 * @brief  设置崩溃时的回调函数。在installCrashReporter:appKey:channel之前调用。
 *
 * @param delegate 代理。
 */
+ (void)setCrashDelegate:(id<CrashSignalCallBackDelegate>)delegate;

/*!
 *  @brief  启动崩溃收集SDK。
 *
 *  @param enableLog 是否打开崩溃日志。
 *  @param key       Crab平台申请到的产品线AppKey。
 *  @param channel   App的发布渠道。
 */
+ (void)installCrashReporter:(BOOL)enableLog
                      appKey:(NSString *)key
                     channel:(NSString *)channel;

/*!
 *  @brief  设置用户名。上报崩溃信息时，会明确每次崩溃影响的用户。
 *
 *  @param user 用户名
 */
+ (void)setUser:(NSString *)user;

@end
