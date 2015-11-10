//
//  OpenScribbleCommand.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "Command.h"
#import "ScribbleSource.h"

@interface OpenScribbleCommand : Command

@property (nonatomic, retain) id <ScribbleSource> scribbleSource;

- (id) initWithScribbleSource:(id <ScribbleSource>) aScribbleSource;
- (void) execute;

@end
