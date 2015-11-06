//
//  BDMBarCodeScanner.m
//  medicine
//
//  Created by bailu on 15-4-28.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "BDMBarCodeScanner.h"

@interface BDMBarCodeScanner () <AVCaptureMetadataOutputObjectsDelegate>

/*!
 *  @brief  摄像头处理的Session。
 */
@property(nonatomic, strong) AVCaptureSession *session;

/*!
 *  @brief  预览的CALayer。
 */
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

/*!
 *  @brief  要识别的AVMetadataObjectType。
 */
@property(nonatomic, strong) NSArray *barCodeTypes;

/*!
 *  @brief  承载预览Layer的视图。
 */
@property(nonatomic, weak) UIView *previewView;

/*!
 *  @brief  保存扫描成功后，供回调适用的block。
 */
@property(nonatomic, copy) void (^resultBlock)(NSString *code);

/*!
 *  @brief  重复调用保护。
 */
@property(nonatomic, assign) BOOL isSessionActive;

@end

@implementation BDMBarCodeScanner

- (instancetype)initWithPreviewView:(UIView *)view{
    if (self = [super init]) {
        NSParameterAssert(view);
        
        _previewView = view;
        _barCodeTypes = [self defaultBarCodeTypes];
    }
    return self;
}


- (instancetype)initWithPreviewView:(UIView *)view barCodeTypes:(NSArray *)types {
    
    if (self = [super init]) {
        NSParameterAssert(view);
        NSParameterAssert(types && types.count);
        NSParameterAssert([types indexOfObject:AVMetadataObjectTypeFace] == NSNotFound);
        
        _previewView = view;
        _barCodeTypes = types;
    }
    return self;
}

+ (BOOL)cameraIsProhibited {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
        return YES;
    default:
        return NO;
    }
}

+ (void)requestCameraPermissionWithBlock:(void(^)(BOOL success))block {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
    case AVAuthorizationStatusAuthorized:
        block(YES);
        break;
        
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
        block(NO);
        break;
        
    case AVAuthorizationStatusNotDetermined:
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         block(granted);
                                     });
                                     
                                 }];
        break;
    }
}

- (void)startScanningWithBlock:(void(^)(NSString *code))block {
    NSAssert(![[self class] cameraIsProhibited], @"camera is disabled");
    
    self.resultBlock = block;
    if (!self.isSessionActive) {
        AVCaptureDevice *device = [self findCaptureDevice];
        self.session = [self createSessionWithCaptureDevice:device];
        self.isSessionActive = YES;
    }
    
    [self.session startRunning];
    self.previewLayer.cornerRadius = self.previewView.layer.cornerRadius;
    [self.previewView.layer addSublayer:self.previewLayer];
}

- (void)stopScanning {
    
    if (self.isSessionActive) {
        
        self.resultBlock = nil;
        self.isSessionActive = NO;
        [self.previewLayer removeFromSuperlayer];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (AVCaptureInput *input in self.session.inputs) {
                [self.session removeInput:input];
            }
            
            for (AVCaptureOutput *output in self.session.outputs) {
                [self.session removeOutput:output];
            }
            
            [self.session stopRunning];
            self.session = nil;
            self.previewLayer = nil;
        });
    }
}

- (void)pauseScanning {
    if (_isSessionActive) {
        for (id output in _session.outputs) {
            if ([output isMemberOfClass:[AVCaptureMetadataOutput class]]) {
                AVCaptureMetadataOutput *metadataOutput = (AVCaptureMetadataOutput *)output;
                [metadataOutput setMetadataObjectsDelegate:nil queue:nil];
            }
        }
    }
}

- (void)resumeScanning {
    if (_isSessionActive) {
        for (id output in _session.outputs) {
            if ([output isMemberOfClass:[AVCaptureMetadataOutput class]]) {
                AVCaptureMetadataOutput *metadataOutput = (AVCaptureMetadataOutput *)output;
                [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            }
        }
    }
}

#pragma mark - Private Methods

- (NSArray *)defaultBarCodeTypes {
    NSMutableArray *types = [@[AVMetadataObjectTypeUPCECode,
                               AVMetadataObjectTypeCode39Code,
                               AVMetadataObjectTypeCode39Mod43Code,
                               AVMetadataObjectTypeEAN13Code,
                               AVMetadataObjectTypeEAN8Code,
                               AVMetadataObjectTypeCode93Code,
                               AVMetadataObjectTypeCode128Code] mutableCopy];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        [types addObjectsFromArray:@[
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code
                                     ]];
    }
    
    return types;
}

- (AVCaptureDevice *)findCaptureDevice {
    
    AVCaptureDevice *device = nil;
    NSError *error = nil;
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *tempDevice in videoDevices) {
        if (tempDevice.position == AVCaptureDevicePositionBack) {
            device = tempDevice;
            break;
        }
    }
    
    if (!device) {
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if ([device lockForConfiguration:&error]) {
        
        if ([device respondsToSelector:@selector(isAutoFocusRangeRestrictionSupported)] &&
            device.isAutoFocusRangeRestrictionSupported) {
            device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
        }
        
        if ([device respondsToSelector:@selector(isFocusPointOfInterestSupported)] &&
            device.isFocusPointOfInterestSupported) {
            device.focusPointOfInterest = CGPointMake(0.5, 0.5);
        }
        
        if ([device respondsToSelector:@selector(setVideoZoomFactor:)]) {
            float zoomFactor = device.activeFormat.videoZoomFactorUpscaleThreshold;
            [device setVideoZoomFactor:zoomFactor];
        }
        
        [device unlockForConfiguration];
    }
    
    return device;
}

- (AVCaptureSession *)createSessionWithCaptureDevice:(AVCaptureDevice *)captureDevice {
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDeviceInput *input = [self deviceInputForCaptureDevice:captureDevice];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addInput:input];
    
    AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:captureOutput];
    
    captureOutput.metadataObjectTypes = self.barCodeTypes;
    
    self.previewLayer = nil;
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.previewView.bounds;
    
    [session commitConfiguration];
    return session;
}

- (AVCaptureDeviceInput *)deviceInputForCaptureDevice:(AVCaptureDevice *)captureDevice {
    
    NSError *error = nil;
    AVCaptureDeviceInput *input;
    input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"Error adding AVCaptureDeviceInput to AVCaptureSession: %@", error);
    }
    
    return input;
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    AVMetadataObject *middleObj;
    AVMetadataMachineReadableCodeObject *metaObj;
    AVMetadataMachineReadableCodeObject *readableObj;
    for (AVMetadataObject *metaData in metadataObjects) {
        metaObj = (AVMetadataMachineReadableCodeObject *)metaData;
        middleObj = [self.previewLayer transformedMetadataObjectForMetadataObject:metaObj];
        readableObj = (AVMetadataMachineReadableCodeObject *)middleObj;
        
        if (readableObj && self.resultBlock) {
            self.resultBlock(readableObj.stringValue);
            break;
        }
    }
}

@end
