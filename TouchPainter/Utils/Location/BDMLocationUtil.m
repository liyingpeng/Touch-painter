//
//  BDMLocationUtil.m
//  iJobs
//
//  Created by Li Xiaopeng on 15/2/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMLocationUtil.h"
#import "BDMProgressHUD.h"

@interface BDMLocationUtil()<CLLocationManagerDelegate>
{
    CLLocationManager *_LocManager;        //定位管理实例
}

@property (nonatomic, copy) GetPositionSuccessBlock successBlock;

@property (nonatomic, copy) GetPositionFailureBlock failureBlock;
@end

@implementation BDMLocationUtil

#pragma mark 初始化

SINGLETON_FOR_CLASS(BDMLocationUtil)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _LocManager = [[CLLocationManager alloc] init];
        //表示更新位置的距离，太小会导致重复调用N次，所以，设定一个较大的值
        _LocManager.distanceFilter = 1000.0f;
        //表示取位置的精度
        _LocManager.desiredAccuracy = kCLLocationAccuracyBest;
        _LocManager.delegate = self;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            [_LocManager requestAlwaysAuthorization];
        }
        
    }
    return self;
}

-(void)startGetLongtitudeLatitude;
{
    //判断是否可以定位
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [_LocManager startUpdatingLocation];
    } else {
        [BDMProgressHUD showTipMessage:@"请在ipad的 设置-隐私-定位服务 选项中，允许移动体验中心始终访问位置信息。"];
        if (self.failureBlock) {
            self.failureBlock(@"不支持定位功能");
        }
    }
    return ;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_LocManager stopUpdatingLocation];
    //经度，维度
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    
    [BDMJobsSharedData sharedInstance].longitude = longitude;
    [BDMJobsSharedData sharedInstance].latitude = latitude;
    if (self.successBlock) {
        self.successBlock(latitude,longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        //访问被拒绝
        if (self.failureBlock) {
            self.failureBlock(@"访问被拒绝");
        }
    } else if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        if (self.failureBlock) {
            self.failureBlock(@"无法获取位置信息");
        }
    }
}

- (void)getCurrentPosition
{
    [self startGetLongtitudeLatitude];
}

- (void)getCurrentPositionSuccess:(GetPositionSuccessBlock) aSuccessBlock
                          Failure:(GetPositionFailureBlock) aFailureBlock
{
    self.successBlock = aSuccessBlock;
    self.failureBlock = aFailureBlock;
    [self startGetLongtitudeLatitude];
}

@end
