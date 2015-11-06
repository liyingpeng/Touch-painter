//
//  BDMMobStatModel.m
//  iJobs
//
//  Created by sunshiwen on 15-2-10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMMobStatModel.h"
#import "BDMUtility.h"

@implementation BDMMobStatModel
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
    self.regionProvinceId = [[BDMJobsSharedData sharedInstance] getSelectedRegions];
    self.operateType = BDMOperateTypeUnknow; //默认什么类型都不是
}

//转成参数字符串
- (NSString *)modelToParamsString
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"keywords"] = self.keywords != nil ? self.keywords : @"";
    params[@"pageSerialNo"] = self.pageSerialNo != nil ? self.pageSerialNo : @"";
    params[@"componentSerialNo"] = self.componentSerialNo != nil ? self.componentSerialNo : @"";
    params[@"operateParam"] = self.message != nil ? self.message : @"";
    params[@"regionProvinceId"] = self.regionProvinceId != nil ? self.regionProvinceId : @"";
    params[@"operateType"] = [NSNumber numberWithInt:self.operateType];
    
    return [BDMUtility toJSONString:params];
}
@end
