//
//  Command.h
//  TouchPainter
//
//  Created by liyingpeng on 15/11/10.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

@property(nonatomic, strong) NSDictionary *userInfo;

- (void)execute;
- (void)undo;

@end
