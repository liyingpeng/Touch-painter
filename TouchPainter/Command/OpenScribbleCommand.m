//
//  OpenScribbleCommand.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "OpenScribbleCommand.h"
#import "CoordinatingController.h"
#import "CanvasViewController.h"

@implementation OpenScribbleCommand

- (id) initWithScribbleSource:(id <ScribbleSource>) aScribbleSource
{
    if (self = [super init])
    {
        [self setScribbleSource:aScribbleSource];
    }
    
    return self;
}

- (void) execute
{
    // get a scribble from the scribbleSource_
    Scribble *scribble = [_scribbleSource scribble];
    
    // set it to the current CanvasViewController
    CoordinatingController *coordinator = [CoordinatingController sharedInstance];
    CanvasViewController *controller = [coordinator canvasViewController];
    [controller setScribble:scribble];
    
    // then tell the coordinator to change views
    [coordinator requestViewChangeByObject:self];
}

@end
