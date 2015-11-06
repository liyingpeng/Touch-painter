//
//  BDMMobStatExceptionModel.m
//  iJobs
//
//  Created by sunshiwen on 15-2-10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMMobStatExceptionModel.h"

@implementation BDMMobStatExceptionModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBaseProperties];
    }
    return self;
}

//初始化基础的参数，即不需要用户指定的参数
- (void)initBaseProperties
{
    self.keywords = [BDMJobsSharedData sharedInstance].keyword;
    self.regionProvinceId = [self getSelectedRegions];
    self.latitude = [BDMJobsSharedData sharedInstance].latitude;
    self.longitude = [BDMJobsSharedData sharedInstance].longitude;
    self.appVersion = kAppVersion;
    self.iosVersion = kSystemVersion;
}

//获得用户输入的区域
- (NSString *)getSelectedRegions
{
    __block int i = 0;
    __block NSMutableString* regions = [[NSMutableString alloc] init];
    int count = [BDMJobsSharedData sharedInstance].selectedRegion.count;
    [[BDMJobsSharedData sharedInstance].selectedRegion enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         [regions appendFormat:@"%d", idx];
         if (++i != count)
             [regions appendString:@","];
     }];
    return regions;
}

//转成参数字符串
- (NSString *)modelToParamsString
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"keywords"] = self.keywords;
    params[@"latitude"] = [NSNumber numberWithDouble:self.latitude];
    params[@"longitude"] = [NSNumber numberWithDouble:self.longitude];
    params[@"regionProvinceId"] = self.regionProvinceId;
    params[@"appVersion"] = self.appVersion;
    params[@"iosVersion"] = self.iosVersion;
    params[@"exceptionMessage"] = self.exceptionMessage;
    
    return [BDUtilityFunction toJSONString:params];
}
@end
