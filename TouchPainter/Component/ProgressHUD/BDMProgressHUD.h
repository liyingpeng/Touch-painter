//
//  BDMProgressHUD.h
//  iJobs
//
//  Created by sunshiwen on 15-3-17.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+Blocks.h"

//信息提示默认显示文字
#define DEFAULT_HUD_MESSAGE @"系统反应慢，请稍后重试！"

@interface BDMProgressHUD : NSObject

/**
 *  @name BDMProgressHUD
 *  1.showTipMessage:方法是显示提示信息，加载到keywindow上,2秒后消失
 *  2.showTipToView:message:方法是在指定的view上显示提示信息，2秒后消失
 *  3.howTipToView:message:afterDelay:是指定view和消失的时间
 *  4.showLoadingView显示加载图，不带有提示信息，需要手动调用hideLoadingView，都是加载到keywindow上
 *  5.showLoadingView:显示加载图，有提示信息，需要手动调用hideLoadingView，都是加载到keywindow上
 *  6.showLoadingToView:message:显示加载图，有提示信息，需要指定加载的父视图，
 *                              需要手动调用hideLoadingViewForView：
 *  7.hideLoadingView消除加载到keywindow上的loading view
 *  8.hideLoadingViewForView:消除加载到指定视图上的loading view
 *  9.hideLoadingViewForView:animated:消除加载到指定视图上的loading view，指定是否有消除的动画
 *  10.showBDMLoadingViewForView:与hideBDMLoadingViewForView:配套使用，显示乔布斯定制的加载图
 */



/**
 *  显示错误信息，不需要手动删除
 */
+ (void)showTipMessage:(NSString *)message; //用于显示提示信息，加载到keywindow上
+ (void)showTipMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;
+ (void)showTipToView:(UIView *)view message:(NSString *)message;
//显示信息，指定时间后消失
+ (void)showTipToView:(UIView *)view message:(NSString *)message afterDelay:(NSTimeInterval)delay;

/**
 *  显示等待加载View
 *  需要手动调用hide方法
 *  同一时间相同的view下请保证只有一个loadingview的实例
 */

//只显示加载图，不带附加的信息，加载到keywidow
+ (void)showLoadingView;
//带附加的提示信息，同时显示加载图，加载到keywindow
+ (void)showLoadingView:(NSString *)message;
+ (void)showLoadingToView:(UIView *)view message:(NSString *)message;

/**
 *  隐藏等待加载View
 */
+ (void)hideLoadingView; //去除keywindow上的loading view
+ (void)hideLoadingViewForView:(UIView *)view;
+ (void)hideLoadingViewForView:(UIView *)view animated:(BOOL)animated;

/**
 *  显示定制的loading效果
 */
+(void)showBDMLoadingViewForView:(UIView*)view;
/**
 *  隐藏定制的loading效果
 */
+(void)hideBDMLoadingViewForView:(UIView*)view;

#pragma mark -
#pragma mark UIAlert view
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(UIAlertViewCompletionBlock)tapBlock;

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(UIAlertViewCompletionBlock)tapBlock;
//简化方法
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message;

//提示
+ (UIAlertView *)showTipsAlertViewWithMessage:(NSString *)message;

//错误
+ (UIAlertView *)showErrorAlertViewWithMessage:(NSString *)message;
@end
