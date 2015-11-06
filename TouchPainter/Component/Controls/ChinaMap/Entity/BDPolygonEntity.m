//
//  BDPolygonEntity.m
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDPolygonEntity.h"
#import "BDMapData.h"
#import "UIColor+Hex.h"
@interface BDPolygonEntity ()
{
    BOOL bHasData;
    CGPoint entityCenter;
}

@end
@implementation BDPolygonEntity
static NSMutableDictionary *dict;
@synthesize geometryEntity;
@synthesize polygonId;
@synthesize propertiesEntity;


//对于省级行政区，需要边界的经纬度
@synthesize top;
@synthesize bottom;
@synthesize left;
@synthesize right;
@synthesize isCity;


+(void)initialize
{
    dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"geometryEntity" forKey:@"geometry"];
    [dict setObject:@"polygonId" forKey:@"id"];
    [dict setObject:@"propertiesEntity" forKey:@"properties"];
    
}

+(NSMutableDictionary*)getDict
{
    return dict;
}

-(float)getXByLongitude:(float)longitude
{
    BDMapData *mapData = [BDMapData sharedInstance];
    
    float x = 0;
    
    if (isCity)
    {
        float   width = mapData.provinceRightLongitude - mapData.provinceLeftLongitude;
        x = (self.mapWidth/ width ) * (longitude - mapData.provinceLeftLongitude)  ;
        
    }
    else
    {
        float width = mapData.countryRightLongitude - mapData.countryLeftLongitude;
        x = (self.mapWidth/ width ) * (longitude - mapData.countryLeftLongitude)  ;
    }
    
    return x;
}



-(float)getXByLatitude:(float)latitude andLongitude:(float)longitude
{
    BDMapData *mapData = [BDMapData sharedInstance];
    
    float x = 0;

    if (isCity)
    {
        float   height = mapData.provinceTopLatitude - mapData.provinceBottomLatitude;
        float   width = mapData.provinceRightLongitude - mapData.provinceLeftLongitude;
        
        
        if (width/height > self.mapWidth/self.mapHeight)
        {
            
            x = (self.mapWidth/ width ) * (longitude - mapData.provinceLeftLongitude)   + self.mapLeft   ;
            return x;
        }
        else
        {
             //self.mapWidth =  width / height * self.mapHeight;
            x = ((width / height * self.mapHeight)/ width ) * (longitude - mapData.provinceLeftLongitude)  + self.mapLeft  ;
              x = x +  (self.mapWidth - width / height * self.mapHeight ) /2;
        }
        
        
        
        
    }
    else
    {
        float width = mapData.countryRightLongitude - mapData.countryLeftLongitude;
        x = (self.mapWidth/ width ) * (longitude - mapData.countryLeftLongitude) + self.mapLeft  ;
    }
    
    return x;
}

-(float)getYByLatitude:(float)latitude andLongitude:(float)longitude
{
    BDMapData *mapData = [BDMapData sharedInstance];
    
    float y = 0;
    
    if (isCity)
    {
        float   height = mapData.provinceTopLatitude - mapData.provinceBottomLatitude;
        float   width = mapData.provinceRightLongitude - mapData.provinceLeftLongitude;
        
   
        if (width/height > self.mapWidth/self.mapHeight)
        {
           
            //self.mapHeight = height / width * self.mapWidth;
            y = ((height / width * self.mapWidth) / height ) * fabs(latitude - mapData.provinceTopLatitude)  + self.mapTop;
            y = y +  (self.mapHeight - height / width * self.mapWidth ) /2;
            return y;
        }
        else
        {
            
            y = (self.mapHeight  / height ) * fabs(latitude - mapData.provinceTopLatitude)  + self.mapTop ;
        }
        
     
        
   
        return y;
        
        
        self.mapHeight = height / width * self.mapWidth;
        y = (self.mapHeight / height ) * fabs(latitude - mapData.provinceTopLatitude)  ;
        
        
        
    }
    else
    {
        float height = mapData.countryTopLatitude - mapData.countryBottomLatitude;
        y = (self.mapHeight / height ) * fabs(latitude - mapData.countryTopLatitude) + self.mapTop ;
    }
    
    return y;
}

-(float)getYByLatitude:(float)latitude
{
    BDMapData *mapData = [BDMapData sharedInstance];
    
    float y = 0;
    
    if (isCity)
    {
        float   height = mapData.provinceTopLatitude - mapData.provinceBottomLatitude;
        
        y = (self.mapHeight / height ) * fabs(latitude - mapData.provinceTopLatitude)  ;
        
        
        
    }
    else
    {
        float height = mapData.countryTopLatitude - mapData.countryBottomLatitude;
        y = (self.mapHeight / height ) * fabs(latitude - mapData.countryTopLatitude)  ;
    }
    
    return y;
}

-(void)drawWithContext :(CGContextRef) context WithStrokeColor:(UIColor*)strokeColor andFillColor:(UIColor*)fillColor andTextColor:(UIColor*)textColor
{
    if (strokeColor == nil)
    {
        strokeColor = [UIColor colorWithHex:@"#a5aac6"];//RGBACOLOR(255, 255, 255, 0.3);
    }
    
    if (fillColor == nil)
    {
        //fillColor = RGBACOLOR(0, 121, 255,0.3);
        fillColor = RGBACOLOR(255, 255, 255, 0.1);
    }
    
    if (textColor == nil)
    {
        textColor = RGBCOLOR(99, 107, 155);
    }
    
    
    
    float r1 ,g1,b1,a1;
    [fillColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    CGContextSetRGBFillColor(context, r1, g1, b1, a1);
    CGMutablePathRef pathRef = [self getPath];
    
    CGContextAddPath(context, pathRef);
    CGContextFillPath(context);
    
    //CGPathRelease(pathRef);
    
    //pathRef = [self getPath];
    CGContextAddPath(context, pathRef);
    CGContextSetLineWidth(context, 1);
    float r2 ,g2,b2,a2;
    [strokeColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    CGContextSetRGBStrokeColor(context, r2, g2, b2, a2);
    CGContextStrokePath(context);
    
    
    NSString *name = self.propertiesEntity.name;
    float r3 ,g3,b3,a3;
    
    [textColor getRed:&r3 green:&g3 blue:&b3 alpha:&a3];
    
    CGContextSetRGBFillColor(context, r3, g3, b3, a3);
    
    
    CGRect rc =  CGPathGetPathBoundingBox(pathRef);
    
    CGPathRelease(pathRef);
    CGPoint pt = CGPointMake(rc.origin.x + rc.size.width / 3, rc.origin.y + rc.size.height / 2);
    if ([name isEqualToString:@"内蒙古"])
    {
        pt.y += rc.size.height / 4;
    }
    else  if ([name isEqualToString:@"甘肃"])
    {
        pt.y -= rc.size.height / 4;
    }
    else  if ([name isEqualToString:@"新疆"])
    {
        pt.x += rc.size.width / 5;
    }
    else  if ([name isEqualToString:@"辽宁"])
    {
        pt.x += rc.size.width / 6;
    }
    else  if ([name isEqualToString:@"江西"])
    {
        pt.x -= rc.size.width / 4;
    }
    else  if ([name isEqualToString:@"海南"])
    {
        pt.x -= rc.size.width / 4;
    }
    else  if ([name isEqualToString:@"江苏"])
    {
        pt.x += rc.size.width / 6;
    }
    else  if ([name isEqualToString:@"广东"])
    {
        pt.y -= rc.size.height / 4;
    }
    else  if ([name isEqualToString:@"陕西"])
    {
        pt.x += rc.size.width / 6;
    }
    
    /*
    if ([name isEqualToString:@"四川"])
    {
        if (pt.x < 0 || pt.y > 600)
        {
            int a = 0;
            for (BDCoordinateEntity *entity in self.geometryEntity.coordinatesArray)
            {
                a ++;
                NSLog(@"la=%f,lo=%f",entity.x,entity.y);
         
            }
        }
    }
    */
    
//    entityCenter = CGPointMake(pt.x + 5, pt.y - 20);
    
    
    //[name drawAtPoint:CGPointMake(pt.x, pt.y) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSStrokeColorAttributeName:[[UIColor greenColor] colorWithAlphaComponent:0.5]}];
    
    //[sunshiwen][add]中心位置[2014-12-05][start]
    CGSize size = [name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    CGPoint cp = CGPointMake(entityCenter.x - size.width / 2, entityCenter.y - size.height / 2);
    [name drawAtPoint:cp withFont:[UIFont systemFontOfSize:12]];
    //[sunshiwen][add][2014-12-05][end]
 
    // CGContextDrawPath
    
}


-(CGMutablePathRef)getPath
{
    
    
    [self makeData];
    int count = 0;
    CGMutablePathRef pathRef=CGPathCreateMutable();
    float x = 0 ;
    float y = 0;
    BDCoordinateEntity *lastEntity = nil;
    for (BDCoordinateEntity *coordinate in geometryEntity.coordinatesArray)
    {
        if (count == 0)
        {
            CGPathMoveToPoint(pathRef,NULL, coordinate.x, coordinate.y);
            x = coordinate.x;
            y = coordinate.y;
        }
        else
        {
            
            CGPoint pt1,pt2;
            if (coordinate.x > x)
            {
                pt1.x = x + (coordinate.x - x ) * 0.3;
                pt2.x = x + (coordinate.x -x ) * 0.7;
                
            }
            else
            {
                pt1.x = coordinate.x + (x - coordinate.x) * 0.3;
                pt2.x = coordinate.x + (x - coordinate.x) * 0.7;
            }
            
            if (coordinate.y > y)
            {
                pt1.y = y + (coordinate.y - y ) * 0.3;
                pt2.y = y + (coordinate.y -y ) * 0.7;
                
            }
            else
            {
                pt1.y = coordinate.y + (y - coordinate.y) * 0.3;
                pt2.y = coordinate.y + (y - coordinate.y) * 0.7;
            }
            
             //CGPathAddLineToPoint(pathRef, NULL,coordinate.x, coordinate.y);
            
            if ((x > 1024 && coordinate.x > 1024) || (x < 0 && coordinate.x < 0) || (y > 0 && coordinate.y > 768) || (y < 0 && coordinate.y < 768))
            {
                //   continue;
            }
            
            
            if ([propertiesEntity.name isEqualToString:@"河北"])
            {
                if (lastEntity != nil && (coordinate.longitude.floatValue - lastEntity.longitude.floatValue > 2))
                {
                    CGPathMoveToPoint(pathRef,NULL, coordinate.x, coordinate.y);
                    x = coordinate.x;
                    y = coordinate.y;
                }
                else
                {
                    CGPathAddArcToPoint(pathRef, NULL, x, y, coordinate.x, coordinate.y, M_PI / 2);
                    // CGPathAddCurveToPoint(pathRef, NULL, pt1.x, pt1.y, pt2.x, pt2.y, coordinate.x, coordinate.y);
                    // CGPathAddCurveToPoint(pathRef, NULL, x  + 1 , y + 1, coordinate.x - 1, coordinate.y - 1, coordinate.x, coordinate.y);
                    //  CGPathAddCurveToPoint(pathRef, NULL, coordinate.x+ (coordinate.x - x ) * 0.3, 2, coordinate.x+(coordinate.x - x ) * 0.7, 2, coordinate.x, coordinate.y);
                    x = coordinate.x;
                    y = coordinate.y;
                }
            }
            else
            {
                if ([propertiesEntity.name isEqualToString:@"四川"]) {
                    if (coordinate.x != x) {
                        CGPathAddArcToPoint(pathRef, NULL, x, y, coordinate.x, coordinate.y, M_PI  /3);
                        // CGPathAddCurveToPoint(pathRef, NULL, pt1.x, pt1.y, pt2.x, pt2.y, coordinate.x, coordinate.y);
                        // CGPathAddCurveToPoint(pathRef, NULL, x  + 1 , y + 1, coordinate.x - 1, coordinate.y - 1, coordinate.x, coordinate.y);
                        //  CGPathAddCurveToPoint(pathRef, NULL, coordinate.x+ (coordinate.x - x ) * 0.3, 2, coordinate.x+(coordinate.x - x ) * 0.7, 2, coordinate.x, coordinate.y);
                        x = coordinate.x;
                        y = coordinate.y;
                    }
                }
                else
                {
                 
                        // CGPathAddArcToPoint(pathRef, NULL, x, y, coordinate.x, coordinate.y, M_PI  /3);
                        CGPathAddLineToPoint(pathRef, NULL, x, y);
                        x = coordinate.x;
                        y = coordinate.y;
                  
                }
            
               
            }
            
            
        }
        
        count ++;
        lastEntity = coordinate;
        
    }
    CGPathCloseSubpath(pathRef);
    return pathRef;
}

-(void)makeData
{
    if (!bHasData)
    {
        for (BDCoordinateEntity *coordinate in geometryEntity.coordinatesArray)
        {
            if ([coordinate.longitude isKindOfClass:[NSArray class]]) {
                
                continue;
            }
            if ([coordinate.latitude isKindOfClass:[NSArray class]]) {
                
                continue;
            }
            coordinate.x = [self getXByLatitude:coordinate.latitude.floatValue andLongitude:coordinate.longitude.floatValue];
            coordinate.y = [self getYByLatitude:coordinate.latitude.floatValue  andLongitude:coordinate.longitude.floatValue];
        }
        //[sunshiwen][add]中心位置[2014-12-05][start]
        float x = [self getXByLatitude:self.propertiesEntity.latitude.floatValue andLongitude:self.propertiesEntity.longitude.floatValue];
        float y = [self getYByLatitude:self.propertiesEntity.latitude.floatValue andLongitude:self.propertiesEntity.longitude.floatValue];
        entityCenter = CGPointMake(x, y);
        //[sunshiwen][add][2014-12-05][end]
        bHasData = !bHasData;
    }
}

-(void)zoomByScale:(float)scale andOrigin:(CGPoint)origin
{
    for (BDCoordinateEntity *coordinate in geometryEntity.coordinatesArray)
    {
        float x = [self getXByLatitude:coordinate.latitude.floatValue andLongitude:coordinate.longitude.floatValue];
        coordinate.x = scale * x - (scale -1)*origin.x;
        
        float y = [self getYByLatitude:coordinate.latitude.floatValue  andLongitude:coordinate.longitude.floatValue];
        coordinate.y = scale * y - (scale -1)*origin.y;
    }
    //[sunshiwen][add]中心位置[2014-12-05][start]
    float cpX = [self getXByLatitude:self.propertiesEntity.latitude.floatValue andLongitude:self.propertiesEntity.longitude.floatValue];
    float cpY = [self getYByLatitude:self.propertiesEntity.latitude.floatValue  andLongitude:self.propertiesEntity.longitude.floatValue];
    entityCenter.x = scale * cpX - (scale -1)*origin.x;
    entityCenter.y = scale * cpY - (scale -1)*origin.y;
    //[sunshiwen][add]中心位置[2014-12-05][end]
}

-(void)moveByDeltaX:(float)deltax andDeltaY:(float)deltay
{
    
    for (BDCoordinateEntity *coordinate in geometryEntity.coordinatesArray)
    {
       
        coordinate.x += deltax;
        coordinate.y += deltay;
    }
    //[sunshiwen][add]修改文字显示位置[2014-12-04][start]
    entityCenter.x += deltax;
    entityCenter.y += deltay;
    //[sunshiwen][add][2014-12-04][end]
}


-(id)copyWithZone:(NSZone *)zone
{
    BDPolygonEntity *entity = [[BDPolygonEntity alloc]init];
    entity.geometryEntity = [self.geometryEntity copy];
    entity.polygonId = self.polygonId;
    entity.propertiesEntity = [self.propertiesEntity copy];
    return entity;
}

-(void)generateMargin
{
    int i = 0 ;
    for (BDCoordinateEntity *coordinate in geometryEntity.coordinatesArray)
    {
        if ([coordinate.longitude isKindOfClass:[NSArray class]]) {
            
            continue;
        }
        if ([coordinate.latitude isKindOfClass:[NSArray class]]) {
            
            continue;
        }
        
        if (i == 0)
        {
            bottom = coordinate.latitude.floatValue;
            top = coordinate.latitude.floatValue;
            right = coordinate.longitude.floatValue;
            left = coordinate.longitude.floatValue;
        }
        else
        {
            if(coordinate.latitude.floatValue < bottom)
            {
                bottom = coordinate.latitude.floatValue;
            }
            if(coordinate.latitude.floatValue > top)
            {
                top = coordinate.latitude.floatValue;
            }
            if(coordinate.longitude.floatValue < left)
            {
                left = coordinate.longitude.floatValue;
            }
            if(coordinate.longitude.floatValue > right)
            {
                right = coordinate.longitude.floatValue;
            }
            
        }
        i ++ ;
        
    }
    
    
}

-(CGPoint)getPolygonCenter
{
    //[sunshiwen][chg]popView中心位置[2014-12-05][start]
//    return entityCenter;
    [self makeData];
    return CGPointMake(entityCenter.x, entityCenter.y - 20) ;
    //[sunshiwen][chg][2014-12-05][end]
}
@end
