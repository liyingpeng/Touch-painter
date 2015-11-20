//
//  Mark.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkVisitor.h"

@protocol Mark <NSObject, NSCopying, NSCoding>

@property(nonatomic, strong) UIColor *color;
@property(nonatomic, assign) CGFloat size;
@property(nonatomic, assign) CGPoint location;
@property(nonatomic, assign, readonly) NSUInteger count;// 子节点的个数
@property(nonatomic, assign, readonly) id<Mark> lastChild;

- (instancetype)copy;
- (void)addMark:(id<Mark>)mark;
- (void)removeMark:(id<Mark>)mark;
- (id<Mark>)childMarkAtIndex:(NSUInteger)index;

// for the Visitor pattern
- (void) acceptMarkVisitor:(id <MarkVisitor>) visitor;

// for the Iterator pattern
- (NSEnumerator *)enumerator;

// for internal iterator implementation
- (void)enumerateMarksUsingBlock:(void (^)(id <Mark> item, BOOL *stop))block;

// for a bad example
- (void)drawWithContext:(CGContextRef)context;

@end
