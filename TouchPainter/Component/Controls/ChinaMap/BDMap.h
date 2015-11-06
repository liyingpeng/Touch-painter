//
//  BDMap.h
//  iJobs
//
//  Created by zc on 14-7-9.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDPolygonEntity.h"
@protocol BDMapDelegate <NSObject>

@optional
-(UIColor*)strokeColorForRegion:(NSString*)regionName;
-(UIColor*)fillColorForRegion:(NSString*)regionName;
-(UIColor*)textColorForRegion:(NSString*)regionName;

@end
@interface BDMap : NSObject
@property(nonatomic,assign)CGRect mapRect;
@property(nonatomic,retain)NSMutableArray *polygonArray;
-(id)initWithRegion:(NSString*)region andRect:(CGRect)rect;
-(void)drawWithContext:(CGContextRef)context;

-(void)zoomByScale:(float)scale andOrigin:(CGPoint)origin;
-(void)moveByDeltaX:(float)deltax andDeltaY:(float)deltay;

-(BDPolygonEntity*)getPolygonAtPoint:(CGPoint)pt;
-(BDPolygonEntity*)getPolygonAtRegion:(NSString*)region;

@property(nonatomic,unsafe_unretained)id<BDMapDelegate> delegate;

-(void)setRegion:(NSString*)region;
-(NSArray*)getPolygons;
@end
