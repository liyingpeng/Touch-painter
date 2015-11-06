//
//  UIView+Shake.h
//  pangu
//
//  Created by chenzhilei on 14/6/20.
//  Copyright (c) 2014年 baidu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShakeDirection)
{
    ShakeDirectionHorizontal = 0,
    ShakeDirectionVertical
};


@interface UIView (Shake)



/** Shake the UITextField
 *
 * Shake the text field a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param direction of the shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection;

@end
