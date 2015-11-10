//
//  NSMutableArray+Stack.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (void) push:(id)object;
- (id) pop;
- (void) dropBottom;

@end
