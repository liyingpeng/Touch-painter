//
//  BDMCacheManager.h
//  iJobs
//
//  Created by bailu on 15-3-24.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *
 * 路径管理类。
 * /Documents/-------------------------AppLevel/---------Config/
 *           |                                 |---------Database/
 *           |                                 |---------Log/
 *           |                                 |---------CrashReporter/
 *           |                                 |
 *           |                                 |...
 *           |                                 |
 *           |                                 |---------XXX/
 *           |
 *           |-------------------------UserLevel/--------UserMD5/
 *                                              |--------UserMD5/
 *                                              |--------UserMD5/
 *
 * /Library/Caches/--------------------AppLevel/---------Images/
 *                |                            |---------Sounds/
 *                |                            |---------Videos/
 *                |
 *                |--------------------UserLevel/--------UserMD5/
 *                                              |--------UserMD5/
 *                                              |--------UserMD5/
 *
 */

/*!
 *  @brief  路径管理类, 对一些常用的路径进行管理。
 */
@interface BDMPathManager : NSObject

@property(nonatomic, readonly)NSString *appRootDocumentPath;
@property(nonatomic, readonly)NSString *appConfigPath;
@property(nonatomic, readonly)NSString *appDatabasePath;
@property(nonatomic, readonly)NSString *appLogPath;
@property(nonatomic, readonly)NSString *appCrashReporterPath;
@property(nonatomic, readonly)NSString *userRootDocumentPath;

@property(nonatomic, readonly)NSString *appRootCachePath;
@property(nonatomic, readonly)NSString *appImagesCachePath;
@property(nonatomic, readonly)NSString *appSoundsCachePath;
@property(nonatomic, readonly)NSString *appVideosCachePath;
@property(nonatomic, readonly)NSString *userRootCachePath;

/*!
 *  @brief  单例模式
 *
 *  @return 唯一实例对象
 */
+ (BDMPathManager *)sharedInstance;

/*!
 *  @brief  获取缓存大小
 *
 *  @return 缓存大小
 */
- (NSString *)cacheSize;

/*!
 *  @brief  清空所有缓存
 */
- (void)clearAllCaches;

/*!
 *  @brief  清空AppLevel的缓存
 */
- (void)clearAppCaches;

/*!
 *  @brief  清空UserLevel的缓存
 */
- (void)clearUserCaches;

/*!
 *  @brief  根据用户名和特征返回用户的文档路径
 *
 *  @param user      用户
 *  @param signature 用户的特定识别信息
 *
 *  @return 用户的文档路径
 */
- (NSString *)userDocumentPath:(NSString *)user signature:(NSString *)signature;

/*!
 *  @brief  根据用户名和特征返回用户的缓存路径
 *
 *  @param user      用户
 *  @param signature 用户的特定识别信息
 *
 *  @return 用户的缓存路径
 */
- (NSString *)userCachePath:(NSString *)user signature:(NSString *)signature;

/*!
 *  @brief  清空用户的缓存路径
 *
 *  @param user      用户
 *  @param signature 用户的特定识别信息
 */
- (void)clearUserCache:(NSString *)user signature:(NSString *)signature;

/**
 *  @brief  获取已下载的文件大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path;
@end
