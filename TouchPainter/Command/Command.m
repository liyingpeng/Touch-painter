//
//  Command.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "Command.h"

@implementation Command

- (void) execute
{
    // should throw an exception.
}

- (void) undo
{
    // do nothing
    // subclasses need to override this
    // method to perform actual undo.
}

@end
