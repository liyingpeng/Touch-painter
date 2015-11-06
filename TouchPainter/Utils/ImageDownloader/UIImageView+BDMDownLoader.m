//
//  UIImageView+BDMDownLoader.m
//  iJobs
//
//  Created by Li Xiaopeng on 15/3/23.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "UIImageView+BDMDownLoader.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView(BDMDownLoader)

- (void)downloadImageWithURL:(NSString *)aUrl
{
    if (![BDMUtility isEmptyString:aUrl]) {
        [self sd_setImageWithURL:[NSURL URLWithString:aUrl]];
    }
}
- (void)downloadImageWithURL:(NSString *)aUrl placeholderImage:(UIImage *)aPlaceholder
{
    if (![BDMUtility isEmptyString:aUrl]) {
        [self sd_setImageWithURL:[NSURL URLWithString:aUrl] placeholderImage:aPlaceholder];;
    }
    
}

@end
