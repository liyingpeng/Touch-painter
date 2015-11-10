//
//  CanvasView.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "CanvasView.h"
#import "MarkRenderer.h"

@implementation CanvasView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // create a renderer visitor
    MarkRenderer *markRenderer = [[MarkRenderer alloc] initWithCGContext:context];
    
    // pass this renderer along the mark composite structure
    [_mark acceptMarkVisitor:markRenderer];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
