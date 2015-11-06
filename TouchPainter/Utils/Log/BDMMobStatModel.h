//
//  BDMMobStatModel.h
//  iJobs
//
//  Created by sunshiwen on 15-2-10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDMMobStatDef.h"

@interface BDMMobStatModel : NSObject

@property (nonatomic,strong) NSString *keywords; //检索关键字
@property (nonatomic,strong) NSString *pageSerialNo; //面页序列号
@property (nonatomic,strong) NSString *componentSerialNo; //页面组件序列号
@property (nonatomic,strong) NSString *message; //附加信息
@property (nonatomic,strong) NSString *regionProvinceId; //地域省级id，如果是多个，请用逗号分隔
@property (nonatomic) short operateType;//操作类型:0代表进入页面，1代表离开页面，2代表错误，3代表点击事件

//转成参数字符串
- (NSString *)modelToParamsString;
@end
