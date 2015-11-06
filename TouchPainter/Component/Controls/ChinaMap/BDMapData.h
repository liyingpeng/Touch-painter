//
//  BDMapData.h
//  iJobs
//
//  Created by zc on 14-7-9.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMapData : NSObject
+(BDMapData*)sharedInstance;
 

@property(nonatomic,assign)float countryLeftLongitude;
@property(nonatomic,assign)float countryRightLongitude;
@property(nonatomic,assign)float countryTopLatitude;
@property(nonatomic,assign)float countryBottomLatitude;


@property(nonatomic,assign)float provinceLeftLongitude;
@property(nonatomic,assign)float provinceRightLongitude;
@property(nonatomic,assign)float provinceTopLatitude;
@property(nonatomic,assign)float provinceBottomLatitude;

/*!
 *  @brief  异步加载地图数据
 */
- (void)readProvinceData;

- (NSMutableDictionary*)getCityData;
- (NSMutableArray*)getProvinceData;
@end
