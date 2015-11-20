//
//  CanvasViewGenerator.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanvasView.h"

/**
 *  工厂方法模式
 */
@interface CanvasViewGenerator : NSObject

- (CanvasView *) canvasViewWithFrame:(CGRect) aFrame;

@end
