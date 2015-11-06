//
//  BDMProgressHUD.m
//  iJobs
//
//  Created by sunshiwen on 15-3-17.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMProgressHUD.h"
#import "MBProgressHUD.h"

#define kTagLoadingView 10001


@implementation BDMProgressHUD

#pragma mark - HUD Methods

+ (void)showLoadingView
{
    [self showLoadingView:@""];
}

+ (void)showLoadingView:(NSString *)message
{
    UIWindow *kWindow = [[UIApplication sharedApplication].delegate window];
    [self showLoadingToView:kWindow message:message];
}

+ (void)showLoadingToView:(UIView *)view message:(NSString *)message
{
    if (view == nil) {
        return;
    }
    
    [self hideLoadingViewForView:view];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.userInteractionEnabled = YES;
//    progressHUD.minSize = CGSizeMake(105.f, 105.f);
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = message;
}

+ (void)showTipMessage:(NSString *)message
{
    [self showTipMessage:message afterDelay:2.0];
}

+ (void)showTipMessage:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    UIWindow *kWindow = [[UIApplication sharedApplication].delegate window];
    [self showTipToView:kWindow message:message afterDelay:delay];
}

+ (void)showTipToView:(UIView *)view message:(NSString *)message
{
    [self showTipToView:view message:message afterDelay:2];
}

+ (void)showTipToView:(UIView *)view message:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    if (view == nil) {
        return;
    }
    
    [self hideLoadingViewForView:view];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.transform = CGAffineTransformIdentity;
    progressHUD.userInteractionEnabled = YES;
//    progressHUD.minSize = CGSizeMake(140.f, 60.f);
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.detailsLabelFont = progressHUD.labelFont;
    progressHUD.detailsLabelText = [BDMUtility isEmptyString:message] ? DEFAULT_HUD_MESSAGE : message;
    [progressHUD hide:YES afterDelay:delay];
}

+ (void)hideLoadingView
{
    UIWindow *kWindow = [[UIApplication sharedApplication].delegate window];
    [self hideLoadingViewForView:kWindow];
}

+ (void)hideLoadingViewForView:(UIView *)view
{
    [self hideLoadingViewForView:view animated:YES];
}

+ (void)hideLoadingViewForView:(UIView *)view animated:(BOOL)animated
{
    if (view == nil) {
        return;
    }
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+(void)showBDMLoadingViewForView:(UIView*)view
{
    if (view == nil) {
        return;
    }
    UIView *loadingV = [view viewWithTag:kTagLoadingView];
    [loadingV removeFromSuperview];
   [self initBDMLoadingViewForView:view];
}

+(void)hideBDMLoadingViewForView:(UIView*)view
{
    if (view == nil) {
        return;
    }
    UIView *loadingV = [view viewWithTag:kTagLoadingView];
    [loadingV removeFromSuperview];
}

+ (void)initBDMLoadingViewForView:(UIView*)view
{
    CATransform3D old = view.layer.transform;
    view.layer.transform = CATransform3DIdentity;
    CGRect frame = view.bounds;
    view.layer.transform = old;
    
    UIView *backgroundView = [BDMComponentGenerator createViewWithColor:[UIColor blackColor]
                                                               andFrame:frame
                                                          withSuperView:view];
    backgroundView.alpha = 0.5;
    backgroundView.tag = kTagLoadingView;
    
    float x = (backgroundView.frame.size.width - 105) / 2;
    float y = (backgroundView.frame.size.height - 105) / 2;
    frame = CGRectMake(x, y, 105, 105);
    UIImageView *imageView = [BDMComponentGenerator createImageViewWithImage:@"loading"
                                                                    andFrame:frame
                                                               withSuperView:backgroundView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.delegate = self;
    rotationAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] ;
    rotationAnimation.removedOnCompletion = NO;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark -
#pragma mark UIAlert view
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(UIAlertViewCompletionBlock)tapBlock
{
    return [UIAlertView showWithTitle:title
                              message:message
                                style:style
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles
                             tapBlock:tapBlock
            ];
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(UIAlertViewCompletionBlock)tapBlock
{
    return [UIAlertView showWithTitle:title
                              message:message
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles
                             tapBlock:tapBlock
            ];
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
{
    return [self showAlertViewWithTitle:title
                                message:message cancelButtonTitle:@"知道了"
                      otherButtonTitles:nil
                               tapBlock:nil
            ];
}

//提示
+ (UIAlertView *)showTipsAlertViewWithMessage:(NSString *)message
{
    return [self showAlertViewWithTitle:@"提示" message:message];
}

//错误
+ (UIAlertView *)showErrorAlertViewWithMessage:(NSString *)message
{
    return [self showAlertViewWithTitle:@"错误" message:message];
}
@end
