//
//  SetStrokeSizeCommand.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/20.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "SetStrokeSizeCommand.h"
#import "CoordinatingController.h"
#import "CanvasViewController.h"

@implementation SetStrokeSizeCommand

- (void) execute
{
    // get the current stroke size
    // from whatever it's my delegate
    double strokeSize = 1;
    [_delegate command:self didRequestForStrokeSize:strokeSize];
    
    // get a hold of the current
    // canvasViewController from
    // the coordinatingController
    // (see the Mediator pattern chapter
    // for details)
    CoordinatingController *coordinator = [CoordinatingController sharedInstance];
    CanvasViewController *controller = [coordinator canvasViewController];
    
    // assign the stroke size to
    // the canvasViewController
    [controller setStrokeSize:strokeSize];
}

@end
