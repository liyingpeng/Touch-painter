//
//  BDCoordinateEntity.m
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDCoordinateEntity.h"

@implementation BDCoordinateEntity
-(id)copyWithZone:(NSZone *)zone
{
    BDCoordinateEntity *entity = [[BDCoordinateEntity alloc]init];
    entity.latitude =  [self.latitude copy];
    entity.longitude = [self.longitude copy];
    entity.x = self.x;
    entity.y = self.y;
    return entity;
}
@end
