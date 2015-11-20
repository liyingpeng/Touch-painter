//
//  SetStrokeColorCommand.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/20.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "Command.h"
#import <UIKit/UIKit.h>

typedef void (^RGBValuesProvider)(CGFloat *red, CGFloat *green, CGFloat *blue);
typedef void (^PostColorUpdateProvider)(UIColor *color);

@class SetStrokeColorCommand;

@protocol SetStrokeColorCommandDelegate

- (void) command:(SetStrokeColorCommand *) command
didRequestColorComponentsForRed:(CGFloat *) red
           green:(CGFloat *) green
            blue:(CGFloat *) blue;

- (void) command:(SetStrokeColorCommand *) command
didFinishColorUpdateWithColor:(UIColor *) color;

@end


@interface SetStrokeColorCommand : Command

@property (nonatomic, assign) id <SetStrokeColorCommandDelegate> delegate;
@property (nonatomic, copy) RGBValuesProvider valuesProvider;
@property (nonatomic, copy) PostColorUpdateProvider postColorUpdateProvider;

- (void) execute;

@end
