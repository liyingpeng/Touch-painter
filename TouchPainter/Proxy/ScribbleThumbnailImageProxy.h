//
//  ScribbleThumbnailImageProxy.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScribbleThumbnailView.h"
#import "Command.h"

@interface ScribbleThumbnailImageProxy : ScribbleThumbnailView

@property (nonatomic, strong) Command *touchCommand;

@end
