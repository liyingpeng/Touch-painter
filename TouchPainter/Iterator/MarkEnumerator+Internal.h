//
//  MarkEnumerator+Internal.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "MarkEnumerator.h"

@interface MarkEnumerator (Internal)

- (id) initWithMark:(id <Mark>)mark;
- (void) traverseAndBuildStackWithMark:(id <Mark>)mark;

@end
