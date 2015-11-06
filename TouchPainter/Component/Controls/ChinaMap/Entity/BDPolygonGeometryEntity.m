//
//  BDPolygonGeometryEntity.m
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDPolygonGeometryEntity.h"
#import "BDCoordinateEntity.h"
@implementation BDPolygonGeometryEntity
static NSMutableDictionary *dict;
@synthesize coordinatesArray = _coordinatesArray;


+(void)initialize
{
    dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"coordinatesArray" forKey:@"coordinates"];
 
    
}

+(NSMutableDictionary*)getDict
{
    return dict;
}

-(void)setCoordinatesArray:(NSMutableArray *)coordinatesArray
{
    _coordinatesArray = [[NSMutableArray alloc]init];
    if (coordinatesArray.count > 0)
    {
        NSArray *data = coordinatesArray[0];
        
        for (NSArray *coordinate in data)
        {
            BDCoordinateEntity *entity = [[BDCoordinateEntity alloc]init];
            if (coordinate.count > 0)
            {
                entity.longitude = coordinate[0];
                entity.latitude = coordinate[1];
                [_coordinatesArray addObject:entity];
            }
       
        }
    }
  
}

-(id)copyWithZone:(NSZone *)zone
{
    BDPolygonGeometryEntity *entity = [[BDPolygonGeometryEntity alloc]init];
    entity.coordinatesArray = [[NSMutableArray alloc]init];
    for (BDCoordinateEntity* cood  in self.coordinatesArray)
    {
        BDCoordinateEntity *coodEntity = [cood copy];
        [entity.coordinatesArray addObject:coodEntity];
    }
    return entity;
}


@end
