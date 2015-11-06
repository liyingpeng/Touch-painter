//
//  BDMMobStatUtility.h
//  iJobs
//
//  Created by sunshiwen on 15-1-28.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDMMobStatModel.h"

/*!
 @class
 @abstract 统计工具类
 */
@interface BDMMobStatUtility : NSObject

/*!
 @class
 @abstract 初始化
 */
+ (void)initMobStatUtility;

/**
 *  @method
 *  @abstract 服务器统计
 */
+ (void)logOpperationToServerWithParams:(BDMMobStatModel *)params;

/**
 *  @method
 *  @abstract 服务器统计页面
 */
+ (void)logPageStartToServerWithPage:(NSString *)pageName;

/**
 *  @method
 *  @abstract 服务器统计页面
 */
+ (void)logPageEndToServerWithPage:(NSString *)pageName;

/**
 *  @method
 *  @abstract 服务器统计组件
 */
+ (void)logBTNClickToServerWithComponent:(NSString *)componentName andPageName:(NSString *)pageName;

/**
 *  @method
 *  @abstract 服务器统计登录事件
 */
+ (void)logLoginEventWithUserName:(NSString *)userName;

/**
 *  @method
 *  @abstract 服务器统计登出事件
 */
+ (void)logLogoutEvent;

/**
 *  @method
 *  @abstract 服务器统计崩溃事件
 */
+ (void)logCrashWithMessage:(NSString *)message;
@end
