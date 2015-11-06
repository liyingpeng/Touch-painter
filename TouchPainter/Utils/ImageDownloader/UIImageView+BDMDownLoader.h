//
//  UIImageView+BDMDownLoader.h
//  iJobs
//
//  Created by Li Xiaopeng on 15/3/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract 异步图片下载类别
 */

@interface UIImageView(BDMDownLoader)

/*!
 @method
 @abstract 异步图片下载
 @discussion
 @param aUrl 图片地址
 @result
 */
- (void)downloadImageWithURL:(NSString *)aUrl;

/*!
 @method
 @abstract 异步图片下载
 @discussion
 @param aUrl 图片地址
 @param aPlaceholder 占位图
 @result
 */
- (void)downloadImageWithURL:(NSString *)aUrl placeholderImage:(UIImage *)aPlaceholder;

@end
