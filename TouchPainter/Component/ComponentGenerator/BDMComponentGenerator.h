//
//  BDMComponentGenerator.h
//  iJobs
//
//  Created by sunshiwen on 15-3-17.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMComponentGenerator : NSObject
+(UIImage *) createImageWithColor: (UIColor *) color rect:(CGRect)rect;
+(UIButton*)createButtonWithFrame:(CGRect)frame withImage:(NSString*)imagePath withHighlightImage:(NSString*)highlightImagePath withTitle:(NSString*)title withFont:(float)fontsize withTitleColor:(UIColor*)titleColor andHighlightColor:(UIColor*)highlightColor andTarget:(id)target  andSelector:(SEL)selector andSuperView:(UIView*)superview;
+(UILabel*)createLabelWithFrame:(CGRect)frame  withTitle:(NSString*)title withFont:(float)fontsize withTextColor:(UIColor*)textcolor ;
+(UITableView*)createTalbeWithFrame:(CGRect)frame  withDelegate:(id<UITableViewDelegate>)delegate withDatasource:(id<UITableViewDataSource>)datasource;
+(UIImageView *) createImageViewWithImage:(NSString*)image andFrame:(CGRect)frame  withSuperView:(UIView*)superview;
+(UIImageView *) createImageViewWithColor:(UIColor*)color andFrame:(CGRect)frame withSuperView:(UIView*)superview;
+(UITextField*)createTextFieldWithFrame:(CGRect)frame  withDelegate:(id<UITextFieldDelegate>)delegate withSuperView:(UIView*)superview andTextColor:(UIColor*)textcolor andFontSize:(int)fontsize andText:(NSString*)text;
+(UIView *) createViewWithColor:(UIColor*)color andFrame:(CGRect)frame withSuperView:(UIView*)superview;
@end
