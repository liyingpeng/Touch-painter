//
//  BDMVersionChecker.m
//  iJobs
//
//  Created by bailu on 15-3-6.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMVersionChecker.h"
#import "BDMNetworkManager.h"
#import "UIAlertView+Blocks.h"

@implementation BDMVersionModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data.upgradeStrategy": @"upgradeStrategy",
                                                       @"data.description": @"versionDescription",
                                                       @"data.url": @"installURL"
                                                       }];
}
@end

@implementation BDMVersionChecker

+ (void)checkVersion:(BDMHTTPRequestModel *)model {
    
    model.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    [[BDMNetworkManager sharedInstance] sendHttpRequestWithModel:model success:^(id responseObject) {
        NSError *error = nil;
        BDMVersionModel *model = nil;
        @try {
            model = [[BDMVersionModel alloc] initWithDictionary:responseObject error:&error];
        }
        @catch (NSException *exception) {
//            [BDMProgressHUD showTipMessage:exception.description];
        }
        
        if (error || !model || model.status != 0) {
            return;
        }
        
        NSString *cancelTitle;
        NSInteger upgradeStrategy = [model.upgradeStrategy intValue];
        if (upgradeStrategy == BDMUpgradeStrategyTypeLatest) {
            return;
        } else if (upgradeStrategy == BDMUpgradeStrategyTypeOptional) {
            cancelTitle = @"取消";
        } else if (upgradeStrategy == BDMUpgradeStrategyTypeForce) {
            cancelTitle = @"退出";
        }
        
        [UIAlertView showWithTitle:@"检测到服务器有新版本"
                           message:model.versionDescription
                 cancelButtonTitle:cancelTitle
                 otherButtonTitles:@[@"升级"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (buttonIndex == 0 && upgradeStrategy == BDMUpgradeStrategyTypeOptional) {
                                  return;
                              }
                              
                              if (buttonIndex == 1) {
                                  NSURL *url = [NSURL URLWithString:model.installURL];
                                  if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                      [[UIApplication sharedApplication] openURL:url];
                                  }
                              }
                              
                              [[UIApplication sharedApplication] performSelector:@selector(suspend)];
                              [[UIApplication sharedApplication] terminateWithSuccess];
                              
                          }];
        
        
    } failure:nil];

}
@end
