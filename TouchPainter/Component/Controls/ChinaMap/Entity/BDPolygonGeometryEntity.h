//
//  BDPolygonGeometryEntity.h
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "AFEntity.h"

@interface BDPolygonGeometryEntity : AFEntity<NSCopying>
@property(nonatomic,retain)NSMutableArray *coordinatesArray;
@end
