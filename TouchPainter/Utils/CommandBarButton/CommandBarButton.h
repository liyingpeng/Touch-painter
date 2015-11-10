//
//  CommandBarButton.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"

@interface CommandBarButton : UIBarButtonItem

@property(nonatomic, strong) Command *command;

@end
