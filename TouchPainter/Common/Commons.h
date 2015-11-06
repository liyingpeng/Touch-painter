//
//  Commons.h
//  iJobs
//
//  Created by chenzhilei on 14/7/22.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#ifndef iJobs_Commons_h
#define iJobs_Commons_h

// 全局宏定义
#import "SigletonMarco.h"
#import "SysConfig.h"


// 全局管理器声明
#import "BDMUCAssistant.h"


// 通用组件声明
#import "MBProgressHUD.h"
#import "BDUtilityFunction.h"


// 全局扩展声明
#import "UIView+Position.h"
#import "UIColor+Hex.h"

//全局网络检查
#import "Reachability.h"

//全局代理文件
#import "BDAppDelegate.h"

//全局代理协议
/**
 *  关闭浮窗
 */
@protocol BDCloseViewDelegate <NSObject>

@optional
- (void)closeView;

@end

#endif
