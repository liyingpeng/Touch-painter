//
//  Vertex.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

@interface Vertex : NSObject <Mark>

@property(nonatomic, strong) UIColor *color;
@property(nonatomic, assign) CGFloat size;
@property(nonatomic, assign) CGPoint location;
@property(nonatomic, readonly) NSUInteger count;
@property(nonatomic, copy, readonly) id<Mark> lastChild;

- (instancetype)initWithLocation:(CGPoint)location;
- (void)addMark:(id <Mark>)mark;
- (void)removeMark:(id <Mark>)mark;
- (id<Mark>)childMarkAtIndex:(NSUInteger)index;

// for the Visitor pattern
- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor;

// for the Prototype pattern
- (id)copyWithZone:(NSZone *)zone;

// for the Iterator pattern
- (NSEnumerator *)enumerator;

// for internal iterator implementation
- (void)enumerateMarksUsingBlock:(void (^)(id <Mark> item, BOOL *stop))block;

// for the Memento pattern
- (instancetype)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end