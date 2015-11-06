//
//  BDMapView1.m
//  iJobs
//
//  Created by zc on 14-7-9.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDMapView.h"
#import "BDPolygonEntity.h"
#import "BDPolygonGeometryEntity.h"
#import "BDMapData.h"
#import "BDMap.h"
#import "UIColor+Hex.h"
#import "BDMapPaoPaoView.h"
@interface BDMapView ()
{
    BDMap *map;
    CGPoint origin;
    float zoomLevel;
    float previousScale;
    CGPoint ptStart;
    BOOL isMoving ;
    NSString *selectedRegion;
    NSMutableArray *selectedRegions;
    
    //[sunshiwen][add]部分选择区域[2014-12-10][start]
    NSMutableArray *partSelectedRegions;
    //[sunshiwen][add][2014-12-10][end]
    
    //UIImageView *paopaoView;
    //UILabel *paopaoLabel;
    
    //UIImageView *locationView;
    BDMapPaoPaoView *locationView;
    NSMutableDictionary *paopaoViewDict;
    NSMutableDictionary *markViewDict;
    
    NSArray *entityArray;
    
    BOOL canSelect;
    
    CGContextRef memContext ;
    CGImageRef image;
    
    
    
    UIImage* image2  ;
    
    UIImageView *locationPoint1;
    UIImageView *locationPoint2;
    UIImageView *locationPointCenter;
    UILabel *tipLabel;
    
    float totalDeltaX;
    float totalDeltaY;
}

@end
@implementation BDMapView
@synthesize delegate;
@synthesize scale = _scale;
@synthesize defaultStyleEnabled;

#define  MAP_SELECTED_COLOR     [UIColor colorWithHex:@"#6b76b2"]
#define  MAP_SELECTED_TEXTCOLOR  RGBACOLOR(255,255,255,1)
- (id)initWithFrame:(CGRect)frame andRegion:(NSString*)region andContentFrame:(CGRect)contentFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        defaultStyleEnabled = YES;
        map = [[BDMap alloc]initWithRegion:region andRect:contentFrame];
        map.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        
        previousScale = 1;
        
        self.clipsToBounds = YES;
        
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        [self addGestureRecognizer:pinchGesture];
        
        selectedRegions = [[NSMutableArray alloc]init];
        
        //[sunshiwen][add]部分选择区域[2014-12-10][start]
        partSelectedRegions = [[NSMutableArray alloc]init];
        //[sunshiwen][add][2014-12-10][end]
        
        locationView = [[BDMapPaoPaoView alloc]initWithFrame:RECT(0, 0, 32.5, 51)];
        [self addSubview:locationView];
        locationView.hidden = YES;
        
        paopaoViewDict = [[NSMutableDictionary alloc]init];
        markViewDict = [[NSMutableDictionary alloc]init];
        entityArray = [map getPolygons];
        
        for (BDPolygonEntity *entity in entityArray)
        {
            BDMapPaoPaoView  *paopaoView = [[BDMapPaoPaoView alloc]initWithFrame:RECT(0, 0, 32.5, 51)];
            paopaoView.hidden = YES;
            [self addSubview:paopaoView];
            paopaoViewDict[entity.propertiesEntity.name] = paopaoView;
        }
        
        
        //UIView *view = [BDMComponentGenerator createViewWithColor:RGBACOLOR(255, 255, 255, 0.1) andFrame:contentFrame withSuperView:self];
        
        locationPoint1 = [BDMComponentGenerator createImageViewWithImage:@"main_location_circle" andFrame:RECT(0, 0, 16, 16) withSuperView:nil];
        locationPoint2 = [BDMComponentGenerator createImageViewWithImage:@"main_location_circle" andFrame:RECT(0, 0, 16, 16) withSuperView:nil];
        locationPointCenter = [BDMComponentGenerator createImageViewWithImage:@"main_location_circle" andFrame:RECT(0, 0, 16, 16) withSuperView:nil];
        tipLabel = [BDMComponentGenerator createLabelWithFrame:RECT(0, 10, 580, 20) withTitle:@"" withFont:12 withTextColor:[UIColor whiteColor]];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        //[self addSubview:tipLabel];
        
        UILongPressGestureRecognizer* press = nil;
        
        press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        press.minimumPressDuration = 0.3f;
        [self addGestureRecognizer:press];
    }
    return self;
}




- (void)drawRect:(CGRect)rect
{
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    
    [map drawWithContext:context];
   
    return;
    
}

-(void)pinch:(UIPinchGestureRecognizer*)gestureRecognizer
{
    
    
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        
        tipLabel.text = [NSString stringWithFormat:@"zoomLevel:%f previouScale:%f,gestureRecognizer:%f",zoomLevel,previousScale,gestureRecognizer.scale ];
        
        CGPoint pt1 = [gestureRecognizer locationOfTouch:0 inView:self];
        CGPoint pt2 = [gestureRecognizer locationOfTouch:1 inView:self];
        
        
        origin = CGPointMake((pt1.x + pt2.x )/2, (pt1.y + pt2.y )/2);
        [self hidePaoPao];
        [self hideMark];
        
        locationPoint1.center = pt1;
        locationPoint2.center = pt2;
        locationPointCenter.center = origin;
        
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        zoomLevel = previousScale * gestureRecognizer.scale ;
        
        NSLog(@"previouScale = %f,zoomLevel = %f",previousScale,zoomLevel);
        
        
        tipLabel.text = [NSString stringWithFormat:@"zoomLevel:%f previouScale:%f,gestureRecognizer:%f",zoomLevel,previousScale,gestureRecognizer.scale ];
        
        if (zoomLevel >=self.maxScale  )
        {
            // if (previousScale < self.maxScale)
            {
                [map zoomByScale:self.maxScale   andOrigin:origin];
         
            }
            
            return;
        }
        else if ( zoomLevel <=self.minScale)
        {
            // if (previousScale > self.minScale)
            {
                [map zoomByScale:self.minScale andOrigin:origin];
                
           
            }
            
        }
        
        if (zoomLevel >= self.minScale && zoomLevel <= self.maxScale)
        {
            [map zoomByScale:zoomLevel andOrigin:origin];
   
            NSLog(@"pinch");
            
        }
        
        
        
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (zoomLevel >= self.maxScale)
        {
            previousScale = self.maxScale;
        }
        else if (zoomLevel <= self.minScale)
        {
            previousScale = self.minScale;
        }
        else
        {
            previousScale = zoomLevel;
        }
        [self updatePaoPaoPaosition];
        [self updateMarkViewPosition];
        
    }
    
    
    [self setNeedsDisplay];
    
    
    
}

-(void)hidePaoPao
{
 
    for (BDPolygonEntity *entity in entityArray)
    {
        BDMapPaoPaoView *paopaoView = paopaoViewDict[entity.propertiesEntity.name];
        paopaoView.hidden = YES;
    }
}

-(void)hideMark
{
 
    for (BDPolygonEntity *entity in entityArray)
    {
        UIView *markView = markViewDict[entity.propertiesEntity.name];
        markView.alpha = 0;
    }
}

-(void)updatePaoPaoPaosition
{
    for (BDPolygonEntity *entity in entityArray)
    {
        BDMapPaoPaoView *paopaoView = paopaoViewDict[entity.propertiesEntity.name];
        CGPoint pt = [entity getPolygonCenter];
        paopaoView.center = pt;
        if ([selectedRegions containsObject:entity.propertiesEntity.name])
        {
            paopaoView.hidden = NO;
        }
        //[sunshiwen][add]部分选择区域[2014-12-10][start]
        if ([partSelectedRegions containsObject:entity.propertiesEntity.name])
        {
            paopaoView.hidden = NO;
        }
        //[sunshiwen][add][2014-12-10][end]
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    
        UITouch* touch = [touches anyObject];
        ptStart = [touch locationInView:self];
        isMoving = YES;
        
        
        
        
        
        [self setNeedsDisplay];
        
        
        canSelect = YES;
        NSLog(@"touchesBegan");
   

}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoving && zoomLevel > self.minScale * 1.01)//默认情况不允许拖动,放大之后才可以拖动
    {
        
        UITouch* touch = [touches anyObject];
        CGPoint ptEnd = [touch locationInView:self];
        [map moveByDeltaX:ptEnd.x - ptStart.x andDeltaY:ptEnd.y - ptStart.y];
  
        ptStart = ptEnd;
        
        
        
        [self setNeedsDisplay];
        [self hidePaoPao];
        [self hideMark];
        

 
    }
    canSelect = NO;
    NSLog(@"touchesMoved");
    

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BDPolygonEntity *polygon = [map getPolygonAtPoint:ptStart];
    selectedRegion = polygon.propertiesEntity.name;
    if (polygon != nil && canSelect == YES && defaultStyleEnabled)
    {
        
        if ([selectedRegions containsObject:selectedRegion]
            || [partSelectedRegions containsObject:selectedRegion]
            )
        {
            [self unSelectProvince:polygon];
        }
        else
        {
            [self selectProvince:polygon];
            //[sunshiwen][add]调用点击代理[2014-12-03][start]
            if (delegate != nil && [delegate respondsToSelector:@selector(mapView:regionSelected:)])
            {
                [delegate mapView:self regionSelected:selectedRegion];
            }
            //[sunshiwen][add][2014-12-03][end]
        }
        
    }
    
    if (polygon != nil)
    {
        
        if (delegate != nil && [delegate respondsToSelector:@selector(mapView:regionClicked:)])
        {
            
 
            [delegate mapView:self regionClicked:selectedRegion];
        }
        
        [self setNeedsDisplay];
    }
    else
    {
        if (delegate != nil && [delegate respondsToSelector:@selector(mapViewClicked:)])
        {

            [delegate mapViewClicked:self];
        }
      
    }
    
    
    selectedRegion = nil;
    
    
    isMoving = NO;
    [self setNeedsDisplay];
    [self performSelector:@selector(updatePaoPaoPaosition) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(updateMarkViewPosition) withObject:nil afterDelay:0.2];
    NSLog(@"touchesEnded");
    
}

-(UIColor*)fillColorForRegion:(NSString *)regionName
{
    if ([selectedRegions containsObject:regionName])
    {
        //[sunshiwen][chg]设置了代理调用代理[2014-12-03][start]
//        return MAP_SELECTED_COLOR;
        if (delegate != nil && [delegate respondsToSelector:@selector(selectFillColorForRegion:)]) {
            return [delegate selectFillColorForRegion:regionName];
        } else {
            return MAP_SELECTED_COLOR;
        }
        //[sunshiwen][chg][2014-12-03][end]
    }
    
    if (delegate != nil && [delegate respondsToSelector:@selector(fillColorForRegion:)])
    {
        return [delegate fillColorForRegion:regionName];
    }
    
    return nil;
}

-(UIColor*)textColorForRegion:(NSString *)regionName
{
    if ([selectedRegions containsObject:regionName])
    {
        //[sunshiwen][chg]设置了代理调用代理[2014-12-03][start]
//        return MAP_SELECTED_TEXTCOLOR;
        if (delegate != nil && [delegate respondsToSelector:@selector(selectTextColorForRegion:)]) {
            return [delegate selectTextColorForRegion:regionName];
        } else {
            return MAP_SELECTED_TEXTCOLOR;
        }
        //[sunshiwen][chg]设置了代理调用代理[2014-12-03][end]
    }
    
    if (delegate != nil && [delegate respondsToSelector:@selector(textColorForRegion:)])
    {
        return [delegate textColorForRegion:regionName];
    }
    
    return nil;
}

//[sunshiwen][add]修改地图画线颜色[2014-12-03][start]
-(UIColor *)strokeColorForRegion:(NSString *)regionName {
    if (delegate != nil && [delegate respondsToSelector:@selector(strokeColorForRegion:)])
    {
        return [delegate strokeColorForRegion:regionName];
    }
    
    return nil;
}
//[sunshiwen][add][2014-12-03][end]

-(void)setRegion:(NSString*)region
{
    [map setRegion:region];
    
    for (NSString *name in [paopaoViewDict allKeys])
    {
        BDMapPaoPaoView *previousPaoPaoView = paopaoViewDict[name];
        [previousPaoPaoView removeFromSuperview];
        
        //[sunshiwen][add]删除选中区域[2014-12-03][start]
        [selectedRegions removeObject:name];
        [partSelectedRegions removeObject:name];
        //[sunshiwen][add]删除选中区域[2014-12-03][end]
    }
    [paopaoViewDict removeAllObjects];
    entityArray = [map getPolygons];
    
    for (BDPolygonEntity *entity in entityArray)
    {
        BDMapPaoPaoView  *paopaoView = [[BDMapPaoPaoView alloc]initWithFrame:RECT(0, 0, 32.5, 51)];
        paopaoView.hidden = YES;
        [self addSubview:paopaoView];
        paopaoViewDict[entity.propertiesEntity.name] = paopaoView;
    }
    [self setNeedsDisplay];
}

-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint pt = [gestureRecognizer locationInView:self];
    
    BDPolygonEntity *polygon = [map getPolygonAtPoint:pt];
    selectedRegion = polygon.propertiesEntity.name;
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if (delegate != nil && [delegate respondsToSelector:@selector(mapView:regionLongPressed:andPoint:)])
        {
            [delegate mapView:self regionLongPressed:selectedRegion andPoint:pt];
        }
        
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
   
        
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        
        
    }
    
    
}

-(void)selectAllProvince
{
    for (BDPolygonEntity *polygon in entityArray)
    {
        if (polygon != nil )
        {
            if (![selectedRegions containsObject:polygon.propertiesEntity.name]
                )
            {
                
                [self selectProvince:polygon];
            }
        }
    }
    
    
}

-(void)unSelectAllProvince
{
    for (BDPolygonEntity *polygon in entityArray)
    {
        if (polygon != nil )
        {
            if ([selectedRegions containsObject:polygon.propertiesEntity.name]
                )
            {
                
                [self unSelectProvince:polygon];
            }
        }
    }
    
}


-(void)unSelectProvince:(BDPolygonEntity*)entity
{
    NSString *name = entity.propertiesEntity.name;
    [selectedRegions removeObject:name];
    //[sunshiwen][add]部分选择区域[2014-12-10][start]
    [partSelectedRegions removeObject:name];
    //[sunshiwen][add]部分选择区域[2014-12-10][end]
    BDMapPaoPaoView *paopaoView = paopaoViewDict[name];
    
    [UIView animateWithDuration:0.5 animations:^(void){
        paopaoView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        paopaoView.alpha = 0;
        
    } completion:^(BOOL finished){
        paopaoView.hidden = YES;
        paopaoView.alpha = 1;
        paopaoView.transform = CGAffineTransformIdentity;
    }];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(mapViewSectedRegionCountChanged:)])
    {
        [delegate mapViewSectedRegionCountChanged:selectedRegions.count];
    }
    
    
    [self setNeedsDisplay];
}

-(void)selectProvince:(BDPolygonEntity*)entity
{
    NSString *name = entity.propertiesEntity.name;
    [selectedRegions addObject:name];
    //[sunshiwen][add]部分选择区域[2014-12-10][start]
    [partSelectedRegions removeObject:name];
    //[sunshiwen][add]部分选择区域[2014-12-10][end]
    BDMapPaoPaoView *paopaoView = paopaoViewDict[name];
    
    paopaoView.hidden = NO;
    paopaoView.alpha = 0;
    CGPoint pt =  [entity getPolygonCenter];
    paopaoView.center = CGPointMake(pt.x, pt.y - 200);
    [UIView animateWithDuration:0.5 animations:^(void){
        //  locationView.center = CGPointMake(ptStart.x, ptStart.y-20);
        paopaoView.center = pt;
        paopaoView.alpha = 1;
        
    } completion:^(BOOL finished){
        [paopaoView startAnimation];
    }];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(mapViewSectedRegionCountChanged:)])
    {
        [delegate mapViewSectedRegionCountChanged:selectedRegions.count];
    }
    [self setNeedsDisplay];
    
}
-(void)setScale:(float)scale andLeftMargin:(float)left andTopMargin:(float)top
{
    
    
    previousScale = scale;
    
    
    [map zoomByScale:previousScale andOrigin:self.center];
    [map moveByDeltaX:left andDeltaY:top];
    [self setNeedsDisplay];
    
}

-(NSArray*)selectedRegions
{
    return selectedRegions;
}

-(int)totalRegionCount
{
    return entityArray.count;
}

-(void)selectCity:(BDPolygonEntity*)entity
{

 
    [paopaoViewDict removeAllObjects];
    entityArray = [map getPolygons];
    
    for (BDPolygonEntity *entity in entityArray)
    {
        BDMapPaoPaoView  *paopaoView = [[BDMapPaoPaoView alloc]initWithFrame:RECT(0, 0, 32.5, 51)];
        paopaoView.hidden = YES;
        [self addSubview:paopaoView];
        paopaoViewDict[entity.propertiesEntity.name] = paopaoView;
    }

}

-(void)updateMarkViewPosition
{
    for (BDPolygonEntity *entity in entityArray)
    {
        UIView *markView = markViewDict[entity.propertiesEntity.name];
        CGPoint pt = [entity getPolygonCenter];
        markView.center = pt;
     
        markView.alpha = 1;
       
    }
}

-(void)addMarkView:(UIView*)markView toRegion:(NSString*)region
{
 
    [self addSubview:markView];
    markViewDict[region] = markView;
    
    for (BDPolygonEntity *entity in entityArray)
    {
        if ([entity.propertiesEntity.name isEqualToString:region])
        {
            CGPoint pt = [entity getPolygonCenter];
            markView.center = pt;
            break;
        }
    }
    
    markView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    markView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^(void){
        markView.alpha = 1;
        markView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
    }];
}

-(void)removeAllMarkView
{
    NSArray *array = [markViewDict allKeys];
    for (NSString  *region  in array) {
        UIView *markView = markViewDict[region];
        [markView removeFromSuperview];
        [markViewDict removeObjectForKey:region];
    }
}

-(void)removeMarkViewFromRegion:(NSString*)region
{
  
    UIView* markView = markViewDict[region];
  
    [UIView animateWithDuration:0.5 animations:^(void){
        markView.alpha = 0;
        markView.transform = CGAffineTransformMakeScale(0.1, 0.1);
 
    } completion:^(BOOL finished){
        [markViewDict removeObjectForKey:region];
        [markView removeFromSuperview];
    }];
}

-(void)showMarkViewWithRegion:(NSString*)region andVisible:(BOOL)bShow
{
    UIView* markView = markViewDict[region];
    if (markView != nil)
    {
        if (bShow)
        {
            markView.hidden = !bShow;
            markView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            markView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^(void){
                markView.alpha = 1;
                markView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
               
            }];

        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^(void){
                markView.alpha = 0;
                markView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                
            } completion:^(BOOL finished){
                markView.hidden = !bShow;
            }];
        }
    }

}

//[sunshiwen][add]选中取消区域方法[2014-12-08][start]
-(void)selectPartProvince:(BDPolygonEntity*)entity
{
    NSString *name = entity.propertiesEntity.name;
    [selectedRegions removeObject:name];
    [partSelectedRegions addObject:name];
    BDMapPaoPaoView *paopaoView = paopaoViewDict[name];
    
    paopaoView.hidden = NO;
    paopaoView.alpha = 0;
    CGPoint pt =  [entity getPolygonCenter];
    paopaoView.center = CGPointMake(pt.x, pt.y - 200);
    [UIView animateWithDuration:0.5 animations:^(void){
        //  locationView.center = CGPointMake(ptStart.x, ptStart.y-20);
        paopaoView.center = pt;
        paopaoView.alpha = 1;
        
    } completion:^(BOOL finished){
        [paopaoView startAnimation];
    }];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(mapViewSectedRegionCountChanged:)])
    {
        [delegate mapViewSectedRegionCountChanged:selectedRegions.count];
    }
    [self setNeedsDisplay];
    
}

//选中指定区域
- (void)selectRegion:(NSString *)regionName {
    for (BDPolygonEntity *entity in entityArray) {
        if ([entity.propertiesEntity.name isEqualToString:regionName]) {
            [self selectProvince:entity];
        }
    }
}

//选中部分区域
-(void)selectPartRegion:(NSString *)regionName {
    for (BDPolygonEntity *entity in entityArray) {
        if ([entity.propertiesEntity.name isEqualToString:regionName]) {
            [self selectPartProvince:entity];
        }
    }
}

//取消指定区域
- (void)unselectRegion:(NSString *)regionName {
    for (BDPolygonEntity *entity in entityArray) {
        if ([entity.propertiesEntity.name isEqualToString:regionName]) {
            [self unSelectProvince:entity];
        }
    }
}

//选中指定的多个区域
- (void)selectRegions:(NSArray *)regions {
    for (NSString *regionName in regions) {
        for (BDPolygonEntity *entity in entityArray) {
            if ([entity.propertiesEntity.name isEqualToString:regionName]) {
                [self selectProvince:entity];
            }
        }
    }
}

//取消指定的多个区域
- (void)unselectRegions:(NSArray *)regions {
    for (NSString *regionName in regions) {
        for (BDPolygonEntity *entity in entityArray) {
            if ([entity.propertiesEntity.name isEqualToString:regionName]) {
                [self unSelectProvince:entity];
            }
        }
    }
}

//获得所有区域名称
- (NSArray *)getAllRegions {
    NSMutableArray *allRegions = [[NSMutableArray alloc] init];
    for (BDPolygonEntity *entity in entityArray) {
        [allRegions addObject:entity.propertiesEntity.name];
    }
    return allRegions;
}
//[sunshiwen][add]选中区域方法[2014-12-08][end]
@end
