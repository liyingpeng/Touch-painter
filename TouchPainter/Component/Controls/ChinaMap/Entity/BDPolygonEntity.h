//
//  BDPolygonEntity.h
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "AFEntity.h"
#import "BDPolygonPropertiesEntity.h"
#import "BDPolygonGeometryEntity.h"
#import "BDCoordinateEntity.h"
@interface BDPolygonEntity : AFEntity<NSCopying>
@property(nonatomic,retain)NSString *polygonId;
@property(nonatomic,retain)BDPolygonPropertiesEntity *propertiesEntity;
@property(nonatomic,retain)BDPolygonGeometryEntity *geometryEntity;

@property(nonatomic,assign)float mapHeight;
@property(nonatomic,assign)float mapWidth;
@property(nonatomic,assign)float mapTop;
@property(nonatomic,assign)float mapLeft;

@property(nonatomic,assign)float top;
@property(nonatomic,assign)float left;
@property(nonatomic,assign)float right;
@property(nonatomic,assign)float bottom;

@property(nonatomic,assign)BOOL isCity;

-(void)generateMargin;

-(void)drawWithContext:(CGContextRef) context;
-(CGMutablePathRef)getPath;
-(void)zoomByScale:(float)scale andOrigin:(CGPoint)origin;
-(void)moveByDeltaX:(float)deltax andDeltaY:(float)deltay;
-(void)drawWithContext :(CGContextRef) context WithStrokeColor:(UIColor*)strokeColor andFillColor:(UIColor*)fillColor andTextColor:(UIColor*)textColor;
-(void)makeData;

-(CGPoint)getPolygonCenter;
@end
