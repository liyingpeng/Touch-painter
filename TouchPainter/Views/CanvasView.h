//
//  CanvasView.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Mark;

@interface CanvasView : UIView

@property (nonatomic, assign) id<Mark> mark;

@end
