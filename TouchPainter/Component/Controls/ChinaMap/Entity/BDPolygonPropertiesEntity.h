//
//  BDPolygonPropertiesEntity.h
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "AFEntity.h"

@interface BDPolygonPropertiesEntity : AFEntity<NSCopying>
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSMutableArray *cp;
@property(nonatomic,retain)NSNumber *childNum;
@property(nonatomic,retain)NSNumber *latitude;
@property(nonatomic,retain)NSNumber *longitude;

@end
