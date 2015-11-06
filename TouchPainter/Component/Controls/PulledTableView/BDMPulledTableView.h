//
//  SHPulledTableView.h
//  SohuMovie
//
//  Created by Yonkie on 14-3-5.
//  Copyright (c) 2014年 com.sohu.wireless. All rights reserved.
//  带下拉刷新的tableview，与带下拉的scrollview共用EGO控件，方便UI统一配置;
//  该类可以继承使用也可以直接使用；

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@class BDMPulledTableView;
@protocol EGOPulledTableViewDelegate <NSObject>

@optional
//上拉下拉后的回调
-(void)beginToLoadData:(EGORefreshPos)aRefreshPos;
-(void)tableView:(BDMPulledTableView *)tableView beginToLoadData:(EGORefreshPos)aRefreshPos;

@end

@interface BDMPulledTableView : UITableView

@property (nonatomic, weak  ) id<EGOPulledTableViewDelegate>pulledDelegate;
@property (nonatomic, assign) BOOL bHeader;  //要不要支持下拉刷新
@property (nonatomic, assign) BOOL bFooter;  //要不要支持上拉加载更多，默认YES.设为NO则不支持下拉加载
@property (nonatomic, assign) BOOL openInsets; // iOS7时，导航的边距

- (void)finishReloading;  //关闭刷新动画
- (void)startPullToRefreshWithAnimated:(BOOL)animated;

@end
