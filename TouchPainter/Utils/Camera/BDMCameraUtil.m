//
//  BDMCameraUtil.m
//  Recognizer
//
//  Created by liyingpeng on 15/3/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "BDMCameraUtil.h"
#import <AssertMacros.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

static const NSUInteger MIN_DISK_SPACE = 200;

@interface BDMCameraUtil()
{
    UIView                     *_previewView;
    dispatch_queue_t           _videoDataOutputQueue;
    AVCaptureSession           *_session;
    AVCaptureVideoPreviewLayer *_previewLayer;
    AVCaptureDeviceInput       *_inputDevice;
    AVCaptureStillImageOutput  *_stillImageOutput;
    AVCaptureVideoDataOutput   *_videoDataOutput;
    
    CGFloat                    _effectiveScale;//缩放比例
    CGFloat                    _beginGestureScale;
    BOOL                       _isUsingFrontFacingCamera;
}



@end

@implementation BDMCameraUtil

#pragma mark -
- (void)dealloc {
    [self teardownAVCapture];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self commonInitForAVCapture];
        _effectiveScale = 1.f;
    }
    return self;
}

- (instancetype)initWithPreview:(UIView *)preview andScale:(CGFloat)scale {
    self = [super init];
    if (self != nil) {
        [self commonInitForAVCapture];
        _effectiveScale = scale;
        
        _previewView = preview;
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        CALayer *rootLayer = [preview layer];
        [_previewLayer setFrame:CGRectMake(0, 0, 768, 1024)];
        [rootLayer addSublayer:_previewLayer];
    }
    return self;
}

- (void)commonInitForAVCapture {
    NSError *error = nil;
    
    //检查是否开启相机权限
    if (!([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined)) {
        [BDMProgressHUD showTipMessage:@"请在ipad的“设置-隐私-相机”选项中，允许访问您的相机。"];
        return;
    }
    //检查输入硬件的可用性
    if (![self checkInputAvailable]) {
        return;
    }
    
    //检查内存空间
    if (((int)[self getFreeDiskspace]-MIN_DISK_SPACE) <= 0)
    {
        [BDMProgressHUD showTipMessage:@"存储空间不足!!!"];
        return;
    }
    
    //session
    AVCaptureSession *session = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    _session = session;
    
    //input
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];

    require(error == nil, fail);
    
fail:
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self teardownAVCapture];
    }
    
    _isUsingFrontFacingCamera = NO;
    if ( [session canAddInput:_inputDevice] )
        [session addInput:_inputDevice];
    
    //output
    _stillImageOutput = [AVCaptureStillImageOutput new];    
    if ([_session canAddOutput:_stillImageOutput]) {
        [_session addOutput:_stillImageOutput];
    }
    
    //队列
    _videoDataOutputQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
}

- (void)teardownAVCapture {
    if (_videoDataOutputQueue) {
        _videoDataOutputQueue = nil;
    }
    _stillImageOutput = nil;
    [_previewLayer removeFromSuperlayer];
    _previewLayer = nil;
}

- (BOOL)checkInputAvailable
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (! audioHWAvailable)
    {
        [BDMProgressHUD showTipMessage:@"Audio input hardware not available"];
    }
    return audioHWAvailable;
}

- (uint64_t)getFreeDiskspace
{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = ([fileSystemSizeInBytes floatValue]/1024ll)/1024ll;
        totalFreeSpace = ([freeFileSystemSizeInBytes floatValue]/1024ll)/1024ll;
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", totalSpace, totalFreeSpace);
    }
    else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    
    return totalFreeSpace;
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    else
        result = AVCaptureVideoOrientationLandscapeRight;
    return result;
}

- (void)displayErrorOnMainQueue:(NSError *)error withMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%d)", message, (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}

#pragma mark - actions
-(void)startRunning {
    [_session startRunning];
}

- (void)stopRunning {
    [_session stopRunning];
}

- (void)takePicture:(DidCapturePhotoBlock)didCapturePhotoBlock {
    AVCaptureConnection *stillImageConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:_effectiveScale];
    [_stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG
                                                                     forKey:AVVideoCodecKey]];
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (error) {
            [self displayErrorOnMainQueue:error withMessage:@"Take picture failed"];
        }
        else {
            NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *captureImage = [[UIImage alloc] initWithData:jpegData];
            
            if (didCapturePhotoBlock) {
                didCapturePhotoBlock(captureImage);
            }
        }
    }];
}

/**
 *  切换前后摄像头
 *
 *  @param isFrontCamera YES:前摄像头  NO:后摄像头
 */
- (void)switchCamera:(BOOL)isFrontCamera {
    AVCaptureDevicePosition desiredPosition;
    if (isFrontCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [_session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [_session inputs]) {
                [_session removeInput:oldInput];
            }
            [_session addInput:input];
            [_session commitConfiguration];
            break;
        }
    }
    _isUsingFrontFacingCamera = !isFrontCamera;
}

/**
 *  手势拉近拉远镜头
 *
 *  @param scale 拉伸倍数
 */
- (void)pinchCameraViewWithScalNum:(CGFloat)scale {
    _effectiveScale = scale;
    if (_effectiveScale < MIN_PINCH_SCALE_NUM) {
        _effectiveScale = MIN_PINCH_SCALE_NUM;
    } else if (_effectiveScale > MAX_PINCH_SCALE_NUM) {
        _effectiveScale = MAX_PINCH_SCALE_NUM;
    }
    [self doPinch];
    _beginGestureScale = scale;
}

- (void)pinchCameraView:(UIPinchGestureRecognizer *)gesture {
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [gesture numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [gesture locationOfTouch:i inView:_previewView];
        CGPoint convertedLocation = [_previewLayer convertPoint:location fromLayer:_previewLayer.superlayer];
        if ( ! [_previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        _effectiveScale = _beginGestureScale * gesture.scale;
        
        if (_effectiveScale < MIN_PINCH_SCALE_NUM) {
            _effectiveScale = MIN_PINCH_SCALE_NUM;
        } else if (_effectiveScale > MAX_PINCH_SCALE_NUM) {
            _effectiveScale = MAX_PINCH_SCALE_NUM;
        }
        
        [self doPinch];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded ||
        [gesture state] == UIGestureRecognizerStateCancelled ||
        [gesture state] == UIGestureRecognizerStateFailed) {
        _beginGestureScale = _effectiveScale;
        NSLog(@"final scale: %f", _effectiveScale);
    }
}

- (void)doPinch {
    AVCaptureConnection *videoConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;//videoScaleAndCropFactor这个属性取值范围是1.0-videoMaxScaleAndCropFactor。iOS5+才可以用
    if (_effectiveScale > maxScale) {
        _effectiveScale = maxScale;
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [_previewLayer setAffineTransform:CGAffineTransformMakeScale(_effectiveScale, _effectiveScale)];
    [CATransaction commit];
}

/**
 *  切换闪光灯模式
 *  （切换顺序：最开始是auto，然后是off，最后是on，一直循环）
 *  @param sender: 闪光灯按钮
 */
- (void)switchFlashMode:(UIButton*)sender {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *imgStr = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            imgStr = @"flashing_on.png";
            
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            imgStr = @"flashing_auto.png";
            
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            imgStr = @"flashing_off.png";
            
        }
        
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有闪光灯功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    [device unlockForConfiguration];
}

/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint {
    if (CGRectContainsPoint(_previewLayer.bounds, devicePoint) == NO) {
        return;
    }
    devicePoint = [self convertToPointOfInterestFromViewCoordinates:devicePoint];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    
    dispatch_async(_videoDataOutputQueue, ^{
        AVCaptureDevice *device = [_inputDevice device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}

/**
 *  外部的point转换为camera需要的point(外部point/相机页面的frame)
 *
 *  @param viewCoordinates 外部的point
 *
 *  @return 相对位置的point
 */
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _previewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = _previewLayer;
    
    if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for(AVCaptureInputPort *port in [[_session.inputs lastObject]ports]) {
            if([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspect]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                    
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

@end
