//
//  BDMBarCodeScanner.h
//  medicine
//
//  Created by bailu on 15-4-28.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

/*!
 *  @brief 支持二维码、条形码扫描。
 */
@interface BDMBarCodeScanner : NSObject

/*!
 *  @brief  传入视图进行初始化。预览Layer将加在这个视图上。此方法初始化后只支持一维条形码扫码。
 *
 *  @param view 承载预览Layer 的视图。
 *
 *  @return 返回对象实例。
 */
- (instancetype)initWithPreviewView:(UIView *)view;

/*!
 *  @brief  传入视图进行初始化。预览Layer将加在这个视图上。并指定识别的类型。
 *
 *  @param view  承载预览 Layer 的视图。
 *  @param types 识别哪些 AVMetadataObjectType。
 *
 *  @return 返回对象实例。
 */
- (instancetype)initWithPreviewView:(UIView *)view barCodeTypes:(NSArray *)types;

/*!
 *  @brief  摄像头是否被禁用。
 *
 *  @return 是否禁用。
 */
+ (BOOL)cameraIsProhibited;

/*!
 *  @brief  请求摄像头权限。
 *
 *  @param block 请求权限完成后的回调。
 */
+ (void)requestCameraPermissionWithBlock:(void(^)(BOOL success))block;

/*!
 *  @brief  开始扫描。
 *
 *  @param block 扫描结果的数组。
 */
- (void)startScanningWithBlock:(void(^)(NSString *code))block;

/*!
 *  @brief  停止扫描。
 */
- (void)stopScanning;

/*!
 * @brief  暂停扫描。
 */
- (void)pauseScanning;

/*!
 * @brief  继续扫描。
 */
- (void)resumeScanning;

@end
