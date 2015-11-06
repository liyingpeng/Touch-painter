//
//  BDMCameraUtil.h
//  Recognizer
//
//  Created by liyingpeng on 15/3/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//最大最小焦距
#define MAX_PINCH_SCALE_NUM   3.f
#define MIN_PINCH_SCALE_NUM   1.f

#define kCapturedPhotoSuccessfully              @"caputuredPhotoSuccessfully"

typedef void(^DidCapturePhotoBlock)(UIImage *image);

@interface BDMCameraUtil : NSObject

- (instancetype)initWithPreview:(UIView *)preview andScale:(CGFloat)scale;
/**
 *  开始启动session
 */
- (void)stopRunning;
/**
 *  停止session
 */
- (void)startRunning;
/**
 *  拍照方法
 *
 *  @param block 拍照成功后的回调方法
 */
- (void)takePicture:(DidCapturePhotoBlock)didCapturePhotoBlock;
/**
 *  切换前后摄像头
 *
 *  @param isFrontCamera 是否是前置摄像头
 */
- (void)switchCamera:(BOOL)isFrontCamera;
/**
 *  拉近拉远摄像头
 *
 *  @param scale 拉近拉远倍数
 */
- (void)pinchCameraViewWithScalNum:(CGFloat)scale;
/**
 *  切换闪光灯模式
 *  （切换顺序：最开始是auto，然后是off，最后是on，一直循环）
 *  @param sender: 闪光灯按钮
 */
- (void)switchFlashMode:(UIButton*)sender;
/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint;

@end
