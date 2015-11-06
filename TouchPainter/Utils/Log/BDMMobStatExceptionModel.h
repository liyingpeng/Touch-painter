//
//  BDMMobStatExceptionModel.h
//  iJobs
//
//  Created by sunshiwen on 15-2-10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMMobStatExceptionModel : NSObject
@property (nonatomic,strong) NSString *keywords; //检索关键字
@property (nonatomic,assign) double latitude; //纬度
@property (nonatomic,assign) double longitude; //经度
@property (nonatomic,strong) NSString *regionProvinceId; //地域省级id，如果是多个，请用逗号分隔
@property (nonatomic,strong) NSString *appVersion; //应用版本号
@property (nonatomic,strong) NSString *iosVersion;//ios系统版本
@property (nonatomic,strong) NSString *exceptionMessage; //异常信息
//转成参数字符串
- (NSString *)modelToParamsString;

@end
