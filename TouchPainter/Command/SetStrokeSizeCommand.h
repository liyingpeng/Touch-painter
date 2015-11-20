//
//  SetStrokeSizeCommand.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/20.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "Command.h"

@class SetStrokeSizeCommand;

@protocol SetStrokeSizeCommandDelegate

- (void) command:(SetStrokeSizeCommand *)command didRequestForStrokeSize:(double)size;

@end

@interface SetStrokeSizeCommand : Command

@property (nonatomic, assign) id<SetStrokeSizeCommandDelegate> delegate;

- (void) execute;

@end
