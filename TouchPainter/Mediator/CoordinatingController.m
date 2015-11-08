//
//  CoordinatingController.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "CoordinatingController.h"
#import "CanvasViewController.h"
#import "PaletteViewController.h"
#import "ThumbnailViewController.h"

@implementation CoordinatingController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _canvasViewController = [[CanvasViewController alloc] init];
        _activeViewController = _canvasViewController;
    }
    return self;
}

SINGLETON_FOR_CLASS(CoordinatingController)

-(void)requestViewChangeByObject:(id)object {
    if ([object isKindOfClass:[UIBarButtonItem class]])
    {
        switch ([(UIBarButtonItem *)object tag])
        {
            case kButtonTagOpenPaletteView:
            {
                // load a PaletteViewController
                PaletteViewController *controller = [[PaletteViewController alloc] init];
                
                // transition to the PaletteViewController
                [self.canvasViewController presentViewController:controller animated:YES completion:nil];
                
                // set the activeViewController to
                // paletteViewController
                self.activeViewController = controller;
            }
                break;
            case kButtonTagOpenThumbnailView:
            {
                // load a ThumbnailViewController
                ThumbnailViewController *controller = [[ThumbnailViewController alloc] init];
                
                
                // transition to the ThumbnailViewController
                [self.canvasViewController presentViewController:controller animated:YES completion:nil];
                
                // set the activeViewController to
                // ThumbnailViewController
                self.activeViewController = controller;
            }
                break;
            default:
                // just go back to the main canvasViewController
                // for the other types
            {
                // The Done command is shared on every
                // view controller except the CanvasViewController
                // When the Done button is hit, it should
                // take the user back to the first page in
                // conjunction with the design
                // other objects will follow the same path
                [self.canvasViewController dismissViewControllerAnimated:YES completion:nil];
                
                // set the activeViewController back to
                // canvasViewController
                self.activeViewController = self.canvasViewController;
            }
                break;
        }
    }
    // every thing else goes to the main canvasViewController
    else 
    {
        [self.canvasViewController dismissViewControllerAnimated:YES completion:nil];
        
        // set the activeViewController back to 
        // canvasViewController
        self.activeViewController = self.canvasViewController;
    }
}

@end
