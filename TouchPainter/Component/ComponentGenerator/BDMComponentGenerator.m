//
//  BDMComponentGenerator.m
//  iJobs
//
//  Created by sunshiwen on 15-3-17.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BDMComponentGenerator.h"

@implementation BDMComponentGenerator
+(UIImage *) createImageWithColor: (UIColor *) color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImageView *) createImageViewWithImage:(NSString*)image andFrame:(CGRect)frame withSuperView:(UIView*)superview
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    
    imageView.image = [BDMUtility imageWithName:image];
    if (superview != nil)
    {
        [superview addSubview:imageView];
    }
    return imageView;
}

+(UIImageView *) createImageViewWithColor:(UIColor*)color andFrame:(CGRect)frame withSuperView:(UIView*)superview
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [self createImageWithColor:color rect:imageView.bounds];
    if (superview != nil)
    {
        [superview addSubview:imageView];
    }
    return imageView;
}

+(UIView *) createViewWithColor:(UIColor*)color andFrame:(CGRect)frame withSuperView:(UIView*)superview
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    if (superview != nil)
    {
        [superview addSubview:view];
    }
    return view;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame withImage:(NSString*)imagePath withHighlightImage:(NSString*)highlightImagePath withTitle:(NSString*)title withFont:(float)fontsize withTitleColor:(UIColor*)titleColor andHighlightColor:(UIColor*)highlightColor andTarget:(id)target  andSelector:(SEL)selector  andSuperView:(UIView*)superview
{
    UIButton *btn = [UIButton buttonWithType:imagePath == nil ? UIButtonTypeSystem :UIButtonTypeCustom];
    btn.frame = frame;
    if (imagePath != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    }
    if (highlightImagePath != nil) {
        [btn setBackgroundImage:[UIImage imageNamed:highlightImagePath] forState:UIControlStateHighlighted];
    }
    btn.font = [UIFont systemFontOfSize:fontsize];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (superview != nil)
    {
        [superview addSubview:btn];
    }
    
    return btn;
}

+(UILabel*)createLabelWithFrame:(CGRect)frame  withTitle:(NSString*)title withFont:(float)fontsize  withTextColor:(UIColor*)textcolor
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontsize];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textcolor;
    return label;
}

+(UITableView*)createTalbeWithFrame:(CGRect)frame  withDelegate:(id<UITableViewDelegate>)delegate withDatasource:(id<UITableViewDataSource>)datasource
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:frame];
    tableview.delegate = delegate;
    tableview.dataSource = datasource;
    
    return tableview;
}

+(UITextField*)createTextFieldWithFrame:(CGRect)frame  withDelegate:(id<UITextFieldDelegate>)delegate withSuperView:(UIView*)superview andTextColor:(UIColor*)textcolor andFontSize:(int)fontsize andText:(NSString*)text
{
    UITextField *textfield  = [[UITextField alloc]init];
    textfield.frame = frame;
    textfield.text = text;
    textfield.font = [UIFont systemFontOfSize:fontsize];
    textfield.backgroundColor = [UIColor clearColor];
    textfield.textColor = textcolor;
    textfield.delegate = delegate;
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [superview  addSubview:textfield];
    
    
    return textfield;
}

@end
