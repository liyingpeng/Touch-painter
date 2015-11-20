//
//  Dot.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "Vertex.h"

@interface Dot : Vertex

// for the Visitor pattern
//- (void)acceptMarkVisitor:(id <MarkVisitor>)visitor;

// for the Prototype pattern
- (id)copyWithZone:(NSZone *)zone;

// for the Memento pattern
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end
