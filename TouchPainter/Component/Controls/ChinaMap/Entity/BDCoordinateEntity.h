//
//  BDCoordinateEntity.h
//  iJobs
//
//  Created by zc on 14-7-3.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "AFEntity.h"

@interface BDCoordinateEntity : AFEntity<NSCopying>
@property(nonatomic,retain)NSNumber *latitude;
@property(nonatomic,retain)NSNumber *longitude;
@property(nonatomic,assign)float  x;
@property(nonatomic,assign)float  y;
@end
