//
//  CoordinatingController.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanvasViewController.h"
#import "PaletteViewController.h"
#import "ThumbnailViewController.h"

typedef NS_ENUM(NSInteger, ButtonTag) {
    kButtonTagDone = 0,
    kButtonTagOpenPaletteView,
    kButtonTagOpenThumbnailView
};

@class UIViewController, CanvasViewController;

/**
 *  mediator 中介者模式
 */
@interface CoordinatingController : NSObject

SINGLETON_FOR_HEADER

@property(nonatomic, strong) UIViewController *activeViewController;

@property(nonatomic, strong) CanvasViewController *canvasViewController;

- (void)requestViewChangeByObject:(id)object;

@end
