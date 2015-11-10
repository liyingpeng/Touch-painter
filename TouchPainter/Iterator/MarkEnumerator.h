//
//  MarkEnumerator.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"
#import "NSMutableArray+Stack.h"

@interface MarkEnumerator : NSEnumerator

- (NSArray *)allObjects;
- (id)nextObject;

@end
