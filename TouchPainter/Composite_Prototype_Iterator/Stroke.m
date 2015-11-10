//
//  Stroke.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "Stroke.h"
#import "MarkEnumerator+Internal.h"

@interface Stroke ()
{
    NSMutableArray *_children;
}

@end

@implementation Stroke

- (id) init
{
    if (self = [super init])
    {
        _children = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return self;
}

- (void) setLocation:(CGPoint)aPoint
{
    // it doesn't set any arbitrary location
}

- (CGPoint) location
{
    // return the location of the first child
    if (_children.count > 0) {
        return [(id<Mark>)_children[0] location];
    }
    
    // otherwise returns the origin
    return CGPointZero;
}

- (void) addMark:(id<Mark>) mark
{
    [_children addObject:mark];
}

- (void) removeMark:(id<Mark>) mark
{
    // if mark is at this level then
    // remove it and return
    // otherwise, let every child
    // search for it
    if ([_children containsObject:mark])
    {
        [_children removeObject:mark];
    }
    else
    {
        [_children makeObjectsPerformSelector:@selector(removeMark:)
                                   withObject:mark];
    }
}


- (id <Mark>) childMarkAtIndex:(NSUInteger) index
{
    if (index >= [_children count]) return nil;
    
    return [_children objectAtIndex:index];
}


// a convenience method to return the last child
- (id <Mark>) lastChild
{
    return [_children lastObject];
}

// returns number of children
- (NSUInteger) count
{
    return [_children count];
}


- (void) acceptMarkVisitor:(id <MarkVisitor>)visitor
{
    for (id <Mark> dot in _children)
    {
        [dot acceptMarkVisitor:visitor];
    }
    
    [visitor visitStroke:self];
}

#pragma mark -
#pragma mark NSCopying method


- (id)copyWithZone:(NSZone *)zone
{
    Stroke *strokeCopy = [[[self class] allocWithZone:zone] init];
    
    // copy the color
    [strokeCopy setColor:[UIColor colorWithCGColor:[_color CGColor]]];
    
    // copy the size
    [strokeCopy setSize:_size];
    
    // copy the children
    for (id <Mark> child in _children)
    {
        id <Mark> childCopy = [child copy];
        [strokeCopy addMark:child];
//        [childCopy release];
    }
    
    return strokeCopy;
}

#pragma mark -
#pragma mark NSCoder methods

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])
    {
        _color = [coder decodeObjectForKey:@"StrokeColor"];
        _size = [coder decodeFloatForKey:@"StrokeSize"];
        _children = [coder decodeObjectForKey:@"StrokeChildren"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_color forKey:@"StrokeColor"];
    [coder encodeFloat:_size forKey:@"StrokeSize"];
    [coder encodeObject:_children forKey:@"StrokeChildren"];
}

#pragma mark -
#pragma mark enumerator methods

- (NSEnumerator *) enumerator
{
    return [[MarkEnumerator alloc] initWithMark:self];
}

- (void) enumerateMarksUsingBlock:(void (^)(id <Mark> item, BOOL *stop)) block
{
    BOOL stop = NO;
    
    NSEnumerator *enumerator = [self enumerator];
    
    for (id <Mark> mark in enumerator)
    {
        block (mark, &stop);
        if (stop)
            break;
    }
}

#pragma mark -
#pragma mark An Extended Direct-draw Example

// for a direct draw example
- (void) drawWithContext:(CGContextRef)context
{
    CGContextMoveToPoint(context, self.location.x, self.location.y);
    
    for (id <Mark> mark in _children)
    {
        [mark drawWithContext:context];
    }
    
    CGContextSetLineWidth(context, self.size);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context,[self.color CGColor]);
    CGContextStrokePath(context);
}

@end
