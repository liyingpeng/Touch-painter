//
//  UIView+Position.h
//  iJobs
//
//  Created by chenzhilei on 14/7/25.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

- (void)setOriginY:(CGFloat)originY;

- (void)setOriginX:(CGFloat)originx;


@end
