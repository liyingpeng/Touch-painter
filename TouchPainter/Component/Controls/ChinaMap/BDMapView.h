//
//  BDMapView.h
//  iJobs
//
//  Created by zc on 14-7-9.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDMap.h"
@class BDMapView;
@protocol BDMapViewDelegate <NSObject>
@optional
-(void)mapView:(BDMapView*)mapView regionClicked:(NSString*)regionName ;
-(void)mapViewClicked:(BDMapView*)mapView ;
-(UIColor*)fillColorForRegion:(NSString *)regionName;
-(UIColor*)textColorForRegion:(NSString *)regionName;
//[sunshiwen][add]添加新的代理[2014-12-03][start]
-(void)mapView:(BDMapView*)mapView regionSelected:(NSString*)regionName ;
-(UIColor*)strokeColorForRegion:(NSString*)regionName;
-(UIColor*)selectFillColorForRegion:(NSString*)regionName;
-(UIColor*)selectTextColorForRegion:(NSString*)regionName;
//[sunshiwen][add][2014-12-03][end]

-(void)mapViewSectedRegionCountChanged:(int)currentCount;
-(void)mapView:(BDMapView *)mapView regionLongPressed:(NSString *)regionName andPoint:(CGPoint)pt;


@end
@interface BDMapView : UIView<BDMapDelegate>

- (id)initWithFrame:(CGRect)frame andRegion:(NSString*)region andContentFrame:(CGRect)contentFrame;
@property(nonatomic,unsafe_unretained)id<BDMapViewDelegate> delegate;

-(void)setRegion:(NSString*)region;

@property(nonatomic,assign) float scale;

-(void)setScale:(float)scale andLeftMargin:(float)left andTopMargin:(float)top;
-(void)showMarkViewWithRegion:(NSString*)region andVisible:(BOOL)bShow;

-(void)selectAllProvince;
-(void)unSelectAllProvince;

-(NSArray*)selectedRegions;

-(int)totalRegionCount;

-(void)addMarkView:(UIView*)markView toRegion:(NSString*)region ;
-(void)removeAllMarkView;

//[sunshiwen][add]选中取消区域方法[2014-12-08][start]
- (void)selectRegion:(NSString *)regionName; //选中指定区域
- (void)selectPartRegion:(NSString *)regionName; //选中半指定区域
- (void)unselectRegion:(NSString *)regionName; //取消指定区域
- (void)selectRegions:(NSArray *)regions; //选中指定的多个区域
- (void)unselectRegions:(NSArray *)regions; //取消指定的多个区域
- (NSArray *)getAllRegions; // 获得所有区域名称
//[sunshiwen][add]选中区域方法[2014-12-08][end]
@property(nonatomic,assign) float maxScale;

@property(nonatomic,assign) float minScale;

@property(nonatomic,assign) BOOL  defaultStyleEnabled;
@end
