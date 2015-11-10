//
//  ScribbleSource.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scribble.h"

@protocol ScribbleSource <NSObject>

- (Scribble *)scribble;

@end

@interface ScribbleSource : UIView

@end
