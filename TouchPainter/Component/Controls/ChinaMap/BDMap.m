//
//  BDMap.m
//  iJobs
//
//  Created by zc on 14-7-9.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDMap.h"
#import "BDPolygonEntity.h"
#import "BDPolygonGeometryEntity.h"
#import "BDMapData.h"

#define WHOLE_COUNTRY @"全国"

@interface BDMap ()
{
    NSString *mapRegion;
}
@end
@implementation BDMap
@synthesize mapRect;
@synthesize polygonArray;
@synthesize delegate;

-(id)initWithRegion:(NSString*)region andRect:(CGRect)rect
{
    self = [super init];
    if (self)
    {
        mapRect = rect;
        mapRegion = region;
        [self loadPolygonWithRegion:region];
    }
    
    return self;
}

-(void)loadPolygonWithRegion:(NSString*)regionName
{
    if (polygonArray.count > 0)
    {
        [polygonArray removeAllObjects];
    }
    BDMapData *mapData = [BDMapData sharedInstance];
    if ([regionName isEqualToString:WHOLE_COUNTRY])
    {
        polygonArray = [mapData getProvinceData];
        for (BDPolygonEntity *entity in polygonArray)
        {
            entity.mapWidth = mapRect.size.width;
            entity.mapHeight = mapRect.size.height;
            entity.mapLeft = mapRect.origin.x;
            entity.mapTop = mapRect.origin.y;
            [entity makeData];
        }
    }
    else
    {
        polygonArray = [mapData getCityData][regionName];
        
        float top = 0 ;
        float bottom = 0;
        float left = 0;
        float right = 0;
        float i = 0;
        for (BDPolygonEntity *entity in polygonArray)
        {
            entity.mapWidth = mapRect.size.width;
            entity.mapHeight = mapRect.size.height;
            entity.mapLeft = mapRect.origin.x;
            entity.mapTop = mapRect.origin.y;
            entity.isCity = YES;
            [entity generateMargin];
            if (i == 0)
            {
                top = entity.top;
                bottom = entity.bottom;
                left = entity.left;
                right = entity.right;
            }
            else
            {
                if (entity.top > top)
                {
                    top = entity.top;
                }
                if (entity.bottom < bottom)
                {
                    bottom = entity.bottom;
                }
                if (entity.left < left)
                {
                    left = entity.left;
                }
                if (entity.right > right)
                {
                    right = entity.right;
                }
            }
            i ++ ;
            
           
        }
        mapData.provinceBottomLatitude = bottom;
        mapData.provinceLeftLongitude = left;
        mapData.provinceRightLongitude = right;
        mapData.provinceTopLatitude = top;
        
    }
}

-(void)drawWithContext:(CGContextRef)context
{
    for (BDPolygonEntity *polygon in polygonArray)
    {
        UIColor *fillColor = nil;
        
        if (delegate != nil && [delegate respondsToSelector:@selector(fillColorForRegion:)]) {
            fillColor =  [delegate fillColorForRegion:polygon.propertiesEntity.name];
        }
        
        UIColor *strokeColor = nil;
        
        if (delegate != nil && [delegate respondsToSelector:@selector(strokeColorForRegion:)]) {
            strokeColor =  [delegate strokeColorForRegion:polygon.propertiesEntity.name];
        }
        
        UIColor *textColor = nil;
        
        if (delegate != nil && [delegate respondsToSelector:@selector(textColorForRegion:)]) {
            textColor =  [delegate textColorForRegion:polygon.propertiesEntity.name];
        }
        
        
        [polygon drawWithContext:context WithStrokeColor:strokeColor andFillColor:fillColor andTextColor:textColor];
        
        
    }
}

-(void)zoomByScale:(float)scale andOrigin:(CGPoint)origin
{
    for (BDPolygonEntity *polygon in polygonArray)
    {
        [polygon zoomByScale:scale andOrigin:origin];
    }
}
-(void)moveByDeltaX:(float)deltax andDeltaY:(float)deltay
{
 
    //[sunshiwen][chg]二级地域拖动范围限定[2014-12-09][start]
    if ([mapRegion isEqualToString:WHOLE_COUNTRY]) {
        if (deltax > 0)
        {
            BOOL bCanMoveRight = NO;
            BDPolygonEntity *hljEntity = [self getPolygonAtRegion:@"黑龙江"];
            for (BDCoordinateEntity *coorEntity in hljEntity.geometryEntity.coordinatesArray)
            {
                if (coorEntity.x < 1024  )
                {
                    bCanMoveRight = YES;
                    break;
                }
            }
            
            if (bCanMoveRight == NO)
            {
                deltax = 0;
            }
        }
        if(deltax < 0  )
        {
            BDPolygonEntity *xjEntity = [self getPolygonAtRegion:@"新疆"];
            BOOL bCanMoveLeft = NO;
            for (BDCoordinateEntity *coorEntity in xjEntity.geometryEntity.coordinatesArray)
            {
                if (coorEntity.x > 0)
                {
                    bCanMoveLeft = YES;
                    break;
                }
            }
            if (bCanMoveLeft == NO)
            {
                deltax = 0;
            }
            
            
        }
        
        if (deltay < 0)
        {
            BOOL bCanMoveTop = NO;
            BDPolygonEntity *gxEntity = [self getPolygonAtRegion:@"黑龙江"];
            for (BDCoordinateEntity *coorEntity in gxEntity.geometryEntity.coordinatesArray)
            {
                if (coorEntity.y > 0  )
                {
                    bCanMoveTop = YES;
                    break;
                }
            }
            
            
            
            if (bCanMoveTop == NO)
            {
                deltay = 0;
            }
            
            
        }
        if (deltay > 0)
        {
            BOOL bCanMoveBottom = NO;
            BDPolygonEntity *gxEntity = [self getPolygonAtRegion:@"广西"];
            for (BDCoordinateEntity *coorEntity in gxEntity.geometryEntity.coordinatesArray)
            {
                if (coorEntity.y < 700  )
                {
                    bCanMoveBottom = YES;
                    break;
                }
            }
            if (bCanMoveBottom == NO)
            {
                deltay = 0;
            }
        }

    }
    //[sunshiwen][chg][2014-12-09][end]
    
    for (BDPolygonEntity *polygon in polygonArray)
    {
        [polygon moveByDeltaX:deltax andDeltaY:deltay];
    }
    
}

-(void)moveByDeltaX2:(float)deltax andDeltaY:(float)deltay
{
    {
        
    }
   
    
    if (deltax >= 0 && deltay >= 0)
    {
        BOOL bCanMoveRight = NO;
        BDPolygonEntity *hljEntity = [self getPolygonAtRegion:@"黑龙江"];
        for (BDCoordinateEntity *coorEntity in hljEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.x < 1024  )
            {
                bCanMoveRight = YES;
                break;
            }
        }
        BOOL bCanMoveBottom = NO;
        BDPolygonEntity *gxEntity = [self getPolygonAtRegion:@"广西"];
        for (BDCoordinateEntity *coorEntity in gxEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.y < 700  )
            {
                bCanMoveBottom = YES;
                break;
            }
        }

        
        if (bCanMoveRight && bCanMoveBottom)
        {
            for (BDPolygonEntity *polygon in polygonArray)
            {
                [polygon moveByDeltaX:deltax andDeltaY:deltay];
            }
        }
        return;

    }
    else if(deltax < 0 && deltay >= 0)
    {
         BDPolygonEntity *xjEntity = [self getPolygonAtRegion:@"新疆"];
        BOOL bCanMoveLeft = NO;
        for (BDCoordinateEntity *coorEntity in xjEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.x > 0)
            {
                bCanMoveLeft = YES;
                break;
            }
        }
        
        BOOL bCanMoveBottom = NO;
        BDPolygonEntity *gxEntity = [self getPolygonAtRegion:@"广西"];
        for (BDCoordinateEntity *coorEntity in gxEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.y < 700  )
            {
                bCanMoveBottom = YES;
                break;
            }
        }
        
        if (bCanMoveLeft && bCanMoveBottom)
        {
            for (BDPolygonEntity *polygon in polygonArray)
            {
                [polygon moveByDeltaX:deltax andDeltaY:deltay];
            }
        }
        return;

    }
    
    if (deltax >=0 && deltay < 0)
    {
        BOOL bCanMoveTop = NO;
        BDPolygonEntity *gxEntity = [self getPolygonAtRegion:@"黑龙江"];
        for (BDCoordinateEntity *coorEntity in gxEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.y > 0  )
            {
                bCanMoveTop = YES;
                break;
            }
        }
        
        BOOL bCanMoveRight = NO;
        BDPolygonEntity *hljEntity = [self getPolygonAtRegion:@"黑龙江"];
        for (BDCoordinateEntity *coorEntity in hljEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.x < 1024  )
            {
                bCanMoveRight = YES;
                break;
            }
        }

        
        if (bCanMoveTop && bCanMoveRight)
        {
            for (BDPolygonEntity *polygon in polygonArray)
            {
                [polygon moveByDeltaX:deltax andDeltaY:deltay];
            }
        }
        return;
        
    }
     else if(deltax < 0 && deltay < 0)
    {
        BDPolygonEntity *xjEntity = [self getPolygonAtRegion:@"新疆"];
        BOOL bCanMoveLeft = NO;
        for (BDCoordinateEntity *coorEntity in xjEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.x > 0)
            {
                bCanMoveLeft = YES;
                break;
            }
        }
        
        BOOL bCanMoveTop = NO;
        BDPolygonEntity *gxEntity = [self getPolygonAtRegion:@"黑龙江"];
        for (BDCoordinateEntity *coorEntity in gxEntity.geometryEntity.coordinatesArray)
        {
            if (coorEntity.y > 0  )
            {
                bCanMoveTop = YES;
                break;
            }
        }
        
        if (bCanMoveLeft && bCanMoveTop )
        {
            for (BDPolygonEntity *polygon in polygonArray)
            {
                [polygon moveByDeltaX:deltax andDeltaY:deltay];
            }
        }
        return;
        
    }

    
   
}

-(BDPolygonEntity*)getPolygonAtPoint:(CGPoint)pt
{
    for (BDPolygonEntity *provinceEntity in polygonArray)
    {
        CGMutablePathRef  path = [provinceEntity getPath];
        BOOL bContain = CGPathContainsPoint(path, NULL, pt, YES);
        
        CGPathRelease(path);
        if (bContain)
        {
            return provinceEntity;
        }
    }
    return nil;
    
}

-(BDPolygonEntity*)getPolygonAtRegion:(NSString*)region
{
    for (BDPolygonEntity *provinceEntity in polygonArray)
    {
        if ([provinceEntity.propertiesEntity.name isEqualToString:region]) {
            return provinceEntity;
        }
    }
    return nil;
    
}

-(NSArray*)getPolygons
{
    return polygonArray;
}

-(void)setRegion:(NSString*)region
{
    mapRegion = region;
    [self loadPolygonWithRegion:region];
}

@end
