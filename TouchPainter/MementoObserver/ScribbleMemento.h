//
//  ScribbleMemento.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

@interface ScribbleMemento : NSObject

+ (ScribbleMemento *) mementoWithData:(NSData *)data;
- (NSData *) data;

@end
