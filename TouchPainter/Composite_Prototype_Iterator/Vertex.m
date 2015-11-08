//
//  Vertex.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "Vertex.h"

@implementation Vertex

- (instancetype)initWithLocation:(CGPoint)location {
    if (self = [super init]) {
        _location = location;
    }
    return self;
}

// default properties do nothing
- (void)setColor:(UIColor *)color {}
- (UIColor *)color { return nil; }
- (void)setSize:(CGFloat)size {}
- (CGFloat)size { return 0.0; }

// Mark operations do nothing
- (void)addMark:(id <Mark>) mark {}
- (void)removeMark:(id <Mark>) mark {}
- (id <Mark>)childMarkAtIndex:(NSUInteger) index { return nil; }
- (id <Mark>)lastChild { return nil; }
- (NSUInteger)count { return 0; }
- (NSEnumerator *)enumerator { return nil; }

- (void)acceptMarkVisitor:(id <MarkVisitor>)visitor
{
    [visitor visitVertex:self];
}

#pragma mark -
#pragma mark NSCopying method

// it needs to be implemented for memento
- (id)copyWithZone:(NSZone *)zone
{
    Vertex *vertexCopy = [[[self class] allocWithZone:zone] initWithLocation:_location];
    
    return vertexCopy;
}


#pragma mark -
#pragma mark NSCoder methods

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])
    {
        _location = [(NSValue *)[coder decodeObjectForKey:@"VertexLocation"] CGPointValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSValue valueWithCGPoint:_location] forKey:@"VertexLocation"];
}

#pragma mark -
#pragma mark MarkIterator methods

// for internal iterator implementation
- (void)enumerateMarksUsingBlock:(void (^)(id <Mark> item, BOOL *stop)) block {}

#pragma mark -
#pragma mark An Extended Direct-draw Example

// for a direct draw example
- (void)drawWithContext:(CGContextRef)context
{
    CGFloat x = self.location.x;
    CGFloat y = self.location.y;
    
    CGContextAddLineToPoint(context, x, y);
}

@end
