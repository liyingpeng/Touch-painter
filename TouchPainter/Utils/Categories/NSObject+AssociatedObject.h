//
//  NSObject+AssociatedObject.h
//  pangu
//
//  Created by chenzhilei on 14/7/4.
//  Copyright (c) 2014年 baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObject)

/**
 *  动态添加属性，并设置属性值
 *
 *  @param propertyName 属性名
 *  @param value        属性值
 */
- (void)setProperty:(const void *)propertyName value:(id)value;


/**
 *  根据属性名获取动态添加的属性值
 *
 *  @param propertyName 属性名
 *
 *  @return 属性值
 */
- (id)getPropertyValue:(const void *)propertyName;


@end
