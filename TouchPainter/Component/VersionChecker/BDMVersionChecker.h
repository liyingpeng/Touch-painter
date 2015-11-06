//
//  BDMVersionChecker.h
//  iJobs
//
//  Created by bailu on 15-3-6.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDMJsonModel.h"

/*!
 *  @brief  升级策略
 */
typedef NS_ENUM(NSInteger, BDMUpgradeStrategyType){
    /*!
     *  @brief  可选升级，用户可以取消
     */
    BDMUpgradeStrategyTypeOptional,
    /*!
     *  @brief  强制升级，用户取消后软件退出
     */
    BDMUpgradeStrategyTypeForce,
    /*!
     *  @brief  当前是最新版本，不需要升级
     */
    BDMUpgradeStrategyTypeLatest
};

/*!
 *  @brief  版本检查结果
 */
@interface BDMVersionModel : BDMJsonModel

/*!
 *  @brief  状态码 0表示无错误发生
 */
@property(nonatomic, assign)int status;

/*!
 *  @brief  状态码不为0时的错误信息
 */
@property(nonatomic, strong)NSString<Optional> *statusInfo;

/*!
 *  @brief  升级策略, 存储BDMUpgradeStrategyType
 */
@property(nonatomic, strong)NSNumber<Optional> *upgradeStrategy;

/*!
 *  @brief  新版本描述
 */
@property(nonatomic, strong)NSString<Optional> *versionDescription;

/*!
 *  @brief  新版本下载地址
 */
@property(nonatomic, strong)NSString<Optional> *installURL;

@end

@interface UIApplication (BDMExit)
- (void)terminateWithSuccess;
@end

/*!
 * @brief  必要的前置声明
 */
@class BDMHTTPRequestModel;

/*!
 *  @brief  版本检查
 *          根据服务器返回的升级策略，进行不同的操作
 */
@interface BDMVersionChecker : NSObject

/*!
 * @brief  检查是否有新的版本。
 *
 * @param model 请求的数据。
 */
+ (void)checkVersion:(BDMHTTPRequestModel *)model;

@end
