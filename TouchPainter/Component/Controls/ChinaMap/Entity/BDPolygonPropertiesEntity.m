//
//  BDPolygonPropertiesEntity.m
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDPolygonPropertiesEntity.h"

@implementation BDPolygonPropertiesEntity
static NSMutableDictionary *dict;
@synthesize cp = _cp;
@synthesize childNum;
@synthesize name;
@synthesize latitude;
@synthesize longitude;

+(void)initialize
{
    dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"cp" forKey:@"cp"];
    [dict setObject:@"childNum" forKey:@"childNum"];
    [dict setObject:@"name" forKey:@"name"];
    
}

+(NSMutableDictionary*)getDict
{
    return dict;
}

-(void)setCp:(NSArray *)cp
{
    longitude = cp[0];
    latitude = cp[1];
}

-(id)copyWithZone:(NSZone *)zone
{
    BDPolygonPropertiesEntity *entity = [[BDPolygonPropertiesEntity alloc]init];
    entity.latitude = [self.latitude copy];
    entity.longitude = [self.longitude copy];
    entity.name = self.name;
    return entity;
}
@end
