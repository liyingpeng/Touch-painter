//
//  DeleteScribbleCommon.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/20.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "DeleteScribbleCommon.h"
#import "CoordinatingController.h"
#import "CanvasViewController.h"

@implementation DeleteScribbleCommon

- (void) execute
{
    // get a hold of the current
    // CanvasViewController from
    // the CoordinatingController
    CoordinatingController *coordinatingController = [CoordinatingController sharedInstance];
    CanvasViewController *canvasViewController = [coordinatingController canvasViewController];
    
    // create a new scribble for
    // canvasViewController
    Scribble *newScribble = [[Scribble alloc] init];
    [canvasViewController setScribble:newScribble];
}

@end
