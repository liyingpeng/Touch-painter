//
//  BDMPopupMenuBaseView.h
//  iJobs
//
//  Created by sunshiwen on 15-3-27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
//展示弹窗的动画类型
typedef enum {
    BDMPopupMenuAnimationTypeNormal, //直接展示和消失
    BDMPopupMenuAnimationTypeBottom, //从底部弹出和收回
    BDMPopupMenuAnimationTypeScale, //在指定的地方展示和收回到指定位置
    BDMPopupMenuAnimationTypeFade //淡入淡出
}BDMPopupMenuAnimationType;

@protocol BDMPopupMenuBaseDataSource <NSObject>

@required

- (UIView *)contentViewForPopupMenu; //自定义的弹窗内容

- (CGRect)frameForContentView; //弹窗的frame

@end

@protocol BDMPopupMenuBaseDelegate <NSObject>
@optional
- (void)popupMenuWillAppear:(UIView *)popupMenu; //在展示弹窗之前回调
- (void)popupMenuDidAppear:(UIView *)popupMenu; //在展示弹窗之后回调
- (void)popupMenuWillDisappear:(UIView *)popupMenu; //在取消弹窗之前回调
- (void)popupMenuDidDisappear:(UIView *)popupMenu; //在取消弹窗之后回调

@end

@interface BDMPopupMenuBaseView : UIView
@property (nonatomic,strong) UIView *superView; //加载到的父视图
@property (nonatomic,strong) UIView *popupMenuContentView; //自定义弹窗
@property CGRect popupMenuContentFrame; //自定义弹窗的frame
@property CGPoint point;
@property BDMPopupMenuAnimationType animationType; //弹窗的动画类别
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic,weak) id<BDMPopupMenuBaseDataSource> popupMenuDataSource;
@property (nonatomic,weak) id<BDMPopupMenuBaseDelegate> popupMenuDelegate;

- (id)initWithSuperView:(UIView*)aSuperView;

- (UIView *)createPopupContentView;

- (void)show;

- (void)hide;

@end
