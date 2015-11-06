//
//  BDMMobStatUtility.m
//  iJobs
//
//  Created by sunshiwen on 15-1-28.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMMobStatUtility.h"
#import "BDMNetworkManager.h"
#import "BDMUtility.h"
#import "UIDevice+serialNumber.h"
#import "BaiduMobStat.h"

@implementation BDMMobStatUtility

+ (void)initMobStatUtility
{
    [self setBaiduMobStat];
}

+ (void)setBaiduMobStat
{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    [statTracker startWithAppId:kBaiduLogKey];
    statTracker.channelId = @"Baidu";
    statTracker.logSendWifiOnly = NO;
}

+ (void)logOpperationToServerWithParams:(BDMMobStatModel *)params
{
    BDMHTTPRequestModel *requestModel =[[BDMHTTPRequestModel alloc] init];
    requestModel.requestUrl = [BDMProxyProtocol sendLogURL];
    requestModel.requestType = HTTP_REQUEST_TYPE_JSON;
    NSString *tempParam = [params modelToParamsString];
    requestModel.paraDict[@"reqParam"] = tempParam;
    
    [[BDMNetworkManager sharedInstance] sendHttpRequestWithModel:requestModel success:^(id responseObject) {
        NSLog(@"log to server successfully!");
    } failure:^(BDMError *error) {
        NSLog(@"log to server failed!");
    }];
}

//页面统计
+ (void)logPageStartToServerWithPage:(NSString *)pageName
{
    BDMMobStatModel *params = [[BDMMobStatModel alloc] init];
    params.pageSerialNo = pageName;
    params.operateType = BDMOperateTypePageStart;
    [self logOpperationToServerWithParams:params];
    
    //百度统计
    [[BaiduMobStat defaultStat]pageviewStartWithName:pageName];
}

//页面统计
+ (void)logPageEndToServerWithPage:(NSString *)pageName
{
    BDMMobStatModel *params = [[BDMMobStatModel alloc] init];
    params.pageSerialNo = pageName;
    params.operateType = BDMOperateTypePageEnd;
    [self logOpperationToServerWithParams:params];
    
    //百度统计
    [[BaiduMobStat defaultStat]pageviewEndWithName:pageName];
}

//统计组件操作
+ (void)logBTNClickToServerWithComponent:(NSString *)componentName andPageName:(NSString *)pageName
{
    
    BDMMobStatModel *params = [[BDMMobStatModel alloc] init];
    params.componentSerialNo = componentName;
    params.pageSerialNo = pageName;
    params.operateType = BDMOperateTypeClick;
    
    [self logOpperationToServerWithParams:params];
    
    //百度统计
   [[BaiduMobStat defaultStat]logEvent:kButtonClick eventLabel:componentName];
}

//登录事件
+ (void)logLoginEventWithUserName:(NSString *)userName
{
    BDMHTTPRequestModel *requestModel =[[BDMHTTPRequestModel alloc] init];
    requestModel.requestUrl = [BDMProxyProtocol sendLoginURL];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appVersion"] = kAppVersion;
    params[@"osVersion"] = kSystemVersion;
    params[@"latitude"] = [NSNumber numberWithDouble:[BDMJobsSharedData sharedInstance].latitude];
    params[@"longitude"] = [NSNumber numberWithDouble:[BDMJobsSharedData sharedInstance].longitude];
    params[@"deviceNo"] = [UIDevice currentDevice].serialNumber ;
    
    requestModel.paraDict[@"reqParam"] = [BDMUtility toJSONString:params];;
    
    [[BDMNetworkManager sharedInstance] sendHttpRequestWithModel:requestModel success:^(id responseObject) {
        NSLog(@"send login event to server successfully!");
    } failure:^(BDMError *error) {
        NSLog(@"send login event to server failed!");
    }];
    
    //百度统计
    [[BaiduMobStat defaultStat]logEvent:kLoginAccountButton eventLabel:userName];
}

//登出事件
+ (void)logLogoutEvent
{
    BDMHTTPRequestModel *requestModel =[[BDMHTTPRequestModel alloc] init];
    requestModel.requestUrl = [BDMProxyProtocol sendLogoutURL];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"latitude"] = [NSNumber numberWithDouble:[BDMJobsSharedData sharedInstance].latitude];
    params[@"longtitude"] = [NSNumber numberWithDouble:[BDMJobsSharedData sharedInstance].longitude];
    requestModel.paraDict[@"reqParam"] = [BDMUtility toJSONString:params];
    [[BDMNetworkManager sharedInstance] sendHttpRequestWithModel:requestModel success:^(id responseObject) {
        NSLog(@"send logout event to server successfully!");
    } failure:^(BDMError *error) {
        NSLog(@"send logout event to server failed!");
    }];
}

//崩溃日志
+(void)logCrashWithMessage:(NSString *)message
{
    BDMHTTPRequestModel *requestModel =[[BDMHTTPRequestModel alloc] init];
    requestModel.requestUrl = [BDMProxyProtocol sendCrashURL];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"message"] = (message == nil ? @"" : message);
    
    requestModel.paraDict[@"reqParam"] = [BDMUtility toJSONString:params];;
    
    [[BDMNetworkManager sharedInstance] sendHttpRequestWithModel:requestModel success:^(id responseObject) {
        NSLog(@"send crash to server successfully!");
    } failure:^(BDMError *error) {
        NSLog(@"send crash to server failed!");
    }];
    
    NSLog(@"崩溃日志：%@",message);
}
@end
