//
//  ScribbleMemento.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "ScribbleMemento.h"

@interface ScribbleMemento ()
{
    BOOL _hasCompleteSnapshot;
}

@property(nonatomic, assign) id<Mark> mark;

@end

@implementation ScribbleMemento

- (NSData *) data
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_mark];
    return data;
}

+ (ScribbleMemento *) mementoWithData:(NSData *)data
{
    // It raises an NSInvalidArchiveOperationException if data is not a valid archive
    id <Mark> retoredMark = (id <Mark>)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    ScribbleMemento *memento = [[ScribbleMemento alloc] initWithMark:retoredMark];
    
    return memento;
}

#pragma mark -
#pragma mark Private methods

- (id) initWithMark:(id <Mark>)aMark
{
    if (self = [super init])
    {
        [self setMark:aMark];
    }
    
    return self;
}

@end
