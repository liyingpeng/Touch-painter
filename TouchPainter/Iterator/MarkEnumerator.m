//
//  MarkEnumerator.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "MarkEnumerator.h"

@interface MarkEnumerator ()
{
    NSMutableArray *_stack;
}

@end

@implementation MarkEnumerator

- (NSArray *)allObjects
{
    // returns an array of yet-visited Mark nodes
    // i.e. the remaining elements in the stack
    return [[_stack reverseObjectEnumerator] allObjects];
}

- (id)nextObject
{
    return [_stack pop];
}

#pragma mark -
#pragma mark Private Methods

- (id) initWithMark:(id <Mark>)aMark
{
    if (self = [super init])
    {
        _stack = [[NSMutableArray alloc] initWithCapacity:[aMark count]];
        
        // post-orderly traverse the whole Mark aggregate
        // and add individual Marks in a private stack
        [self traverseAndBuildStackWithMark:aMark];
    }
    
    return self;
}

- (void) traverseAndBuildStackWithMark:(id <Mark>)mark
{
    // push post-order traversal
    // into the stack
    if (mark == nil) return;
    
    [_stack push:mark];
    
    NSUInteger index = [mark count];
    id <Mark> childMark;
    while (childMark = [mark childMarkAtIndex:--index])
    {
        [self traverseAndBuildStackWithMark:childMark];
    }
}

@end
