//
//  ScribbleThumbnailView.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scribble.h"
#import "ScribbleSource.h"

@interface ScribbleThumbnailView : UIView <ScribbleSource>

@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) Scribble *scribble;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *scribblePath;

@end
