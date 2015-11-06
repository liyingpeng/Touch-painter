//
//  BDMapPaoPaoView.m
//  iJobs
//
//  Created by zc on 14-8-17.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDMapPaoPaoView.h"
@interface BDMapPaoPaoView()
{
    UIImageView *background;
    UIImageView *circle;
}

@end
@implementation BDMapPaoPaoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       background = [BDMComponentGenerator createImageViewWithImage:@"main_location_empty" andFrame:RECT(0, 0, 32.5, 51) withSuperView:self];
        circle = [BDMComponentGenerator createImageViewWithImage:@"main_location_circle" andFrame:RECT(8.5, 7, 16, 16) withSuperView:self];
    }
    return self;
}

-(void)startAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    circle.transform =  CGAffineTransformMakeRotation(M_PI); // CGAffineTransformRotate(circle.transform, M_PI   ) ;
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
