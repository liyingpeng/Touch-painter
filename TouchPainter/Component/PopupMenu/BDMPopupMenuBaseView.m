//
//  BDMPopupMenuBaseView.m
//  iJobs
//
//  Created by sunshiwen on 15-3-27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMPopupMenuBaseView.h"

@interface BDMPopupMenuBaseView ()<UIGestureRecognizerDelegate>

@end

@implementation BDMPopupMenuBaseView
- (id)initWithSuperView:(UIView*)aSuperView
{
    self = [super initWithFrame:aSuperView.frame];

    if (self) {
        self.superView = aSuperView;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        [self.superView addSubview:self];
        
        self.animationType = BDMPopupMenuAnimationTypeNormal;
        self.point = CGPointZero;
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:self.tapGesture];
        self.tapGesture.delegate = self;
    }
    return self;
}

- (UIView *)createPopupContentView
{
    self.popupMenuContentView = [self.popupMenuDataSource contentViewForPopupMenu];
    self.popupMenuContentView.alpha = 0;
    [self addSubview:self.popupMenuContentView];

    self.popupMenuContentFrame = [self.popupMenuDataSource frameForContentView];
    
    return self.popupMenuContentView;
}

- (void)dealloc
{
    [self removeGestureRecognizer:_tapGesture];
}

- (id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        CGRect rect =  self.popupMenuContentFrame;
        if (CGRectContainsPoint(rect, point)) {
            return nil ;
        } else {
            return hitView;
        }
    }
    return hitView;
}

- (void)show
{
    //显示hit test图层
    if (_animationType == BDMPopupMenuAnimationTypeFade) {
        self.alpha = 0;
    } else {
        self.alpha = 1;
    }
    
    if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                   @selector(popupMenuWillAppear:)]){
        [self.popupMenuDelegate popupMenuWillAppear:self.popupMenuContentView];
    }

    switch (self.animationType) {
        case BDMPopupMenuAnimationTypeNormal:
        {
            self.popupMenuContentView.alpha = 1; //直接显示
            break;
        }
        case BDMPopupMenuAnimationTypeBottom:
        {
            self.popupMenuContentView.frame = CGRectMake(self.popupMenuContentFrame.origin.x, CGRectGetHeight(self.frame), CGRectGetWidth(self.popupMenuContentFrame), CGRectGetHeight(self.popupMenuContentFrame));
            self.popupMenuContentView .alpha = 1;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.popupMenuContentView.frame = self.popupMenuContentFrame;
                             }
                             completion:^(BOOL finished){
                                 if(finished){
                                 }
                             }];

            break;
        }
        case BDMPopupMenuAnimationTypeScale:
        {
            self.popupMenuContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.popupMenuContentView.center = self.point;
            self.popupMenuContentView.alpha = 0;
            
            [UIView animateWithDuration:0.3 animations:^(void){
                self.popupMenuContentView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
                self.popupMenuContentView.transform = CGAffineTransformIdentity;
                self.popupMenuContentView.alpha = 1;
            } completion:^(BOOL completed){
                
            }];
            break;
        }
        case BDMPopupMenuAnimationTypeFade:
        {
            [UIView animateWithDuration:0.3 animations:^(void){
                self.popupMenuContentView.alpha = 1;
                self.alpha  = 1;
            } completion:^(BOOL completed){
            }];
            break;
        }
        default:
        {
            self.popupMenuContentView.alpha = 1;
            break;
        }
            
    }
    
    if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                   @selector(popupMenuDidAppear:)]){
        [self.popupMenuDelegate popupMenuDidAppear:self.popupMenuContentView];
    }
}


- (void)hide
{
    if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                   @selector(popupMenuWillDisappear:)]){
        [self.popupMenuDelegate popupMenuWillDisappear:self.popupMenuContentView];
    }
    
    switch (self.animationType) {
        case BDMPopupMenuAnimationTypeNormal:
        {
            self.popupMenuContentView.alpha = 0;
            
            if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                           @selector(popupMenuDidDisappear:)]){
                [self.popupMenuDelegate popupMenuDidDisappear:self.popupMenuContentView];
            }
            
            [self removeFromSuperview];
            break;
        }
        case BDMPopupMenuAnimationTypeBottom:
        {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.popupMenuContentView.frame = CGRectMake(self.popupMenuContentFrame.origin.x, CGRectGetHeight(self.frame), CGRectGetWidth(self.popupMenuContentFrame), CGRectGetHeight(self.popupMenuContentFrame));
                             }
                             completion:^(BOOL finished){
                                 if(finished){
                                     self.popupMenuContentView.alpha = 0;
                                 }
                                 
                                 if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                                                @selector(popupMenuDidDisappear:)]){
                                     [self.popupMenuDelegate popupMenuDidDisappear:self.popupMenuContentView];
                                 }
                                 
                                 [self removeFromSuperview];
                             }];
            
            break;
        }
        case BDMPopupMenuAnimationTypeScale:
        {
            [UIView animateWithDuration:0.3 animations:^(void){
                self.popupMenuContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                self.popupMenuContentView.center = self.point;
                self.popupMenuContentView.alpha  = 0;
                
            } completion:^(BOOL completed){
                if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                               @selector(popupMenuDidDisappear:)]){
                    [self.popupMenuDelegate popupMenuDidDisappear:self.popupMenuContentView];
                }
                
                [self removeFromSuperview];
            }];
            break;
        }
        case BDMPopupMenuAnimationTypeFade:
        {
            [UIView animateWithDuration:0.3 animations:^(void){
                self.popupMenuContentView.alpha = 0;
                self.alpha  = 0;
            } completion:^(BOOL completed){
                if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                               @selector(popupMenuDidDisappear:)]){
                    [self.popupMenuDelegate popupMenuDidDisappear:self.popupMenuContentView];
                }
                [self removeFromSuperview];
            }];
            break;
        }
        default:
        {
            self.popupMenuContentView.alpha = 0;
            
            if (self.popupMenuDelegate && [self.popupMenuDelegate respondsToSelector:
                                           @selector(popupMenuDidDisappear:)]){
                [self.popupMenuDelegate popupMenuDidDisappear:self.popupMenuContentView];
            }
            
            [self removeFromSuperview];
            break;
        }
            
    }
}

#pragma - gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGRect rect =  self.popupMenuContentFrame;
    if (CGRectContainsPoint(rect, [gestureRecognizer locationInView:self])) {
        return NO;
    } else {
        return YES;
    }
}
@end
