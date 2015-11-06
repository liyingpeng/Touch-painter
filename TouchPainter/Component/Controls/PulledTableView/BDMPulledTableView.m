//
//  SHPulledTableView.m
//  SohuMovie
//
//  Created by Yonkie on 14-3-5.
//  Copyright (c) 2014年 com.sohu.wireless. All rights reserved.
//

#import "BDMPulledTableView.h"

//UIScrollView的代理中转
@interface TransitTableViewPrivateDelegate : NSObject <UITableViewDelegate> {
@public
    __weak id<UITableViewDelegate> _userDelegate;
}
@end


@interface BDMPulledTableView ()<EGOPulledTableViewDelegate, EGORefreshTableDelegate> {
    TransitTableViewPrivateDelegate *_myDelegate;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL                      _reloading;
    
    UIEdgeInsets _insets;  //偏移量设定，为了兼容ios6 controller.view不全屏而ios7 controller.view全屏的问题；
}

@end

@implementation BDMPulledTableView

- (void)initDelegate {
    _bHeader = YES;
    _bFooter = YES;
    
    if (!_myDelegate) {
        _myDelegate = [[TransitTableViewPrivateDelegate alloc] init];
    }
    [super setDelegate:_myDelegate];
    
    if (!_pulledDelegate) {
        _pulledDelegate = self;
    }
    [self setHeaderView];
    [self setFooterView];
}

- (void)dealloc
{
    _myDelegate->_userDelegate = nil;
    _myDelegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initDelegate];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    [self initDelegate];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self initDelegate];
    }
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if (_myDelegate) {
        _myDelegate->_userDelegate = delegate;
        super.delegate = (id)_myDelegate;
    }
}

- (id<UITableViewDelegate>)delegate
{
    return _myDelegate->_userDelegate;
}

- (void)setInsets:(UIEdgeInsets)insets
{
    
}

- (void)setOpenInsets:(BOOL)openInsets
{
    if (openInsets) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            UIEdgeInsets insets = UIEdgeInsetsMake(64, 0, 0, 0);
            _refreshHeaderView.insets = insets;
            _refreshFooterView.insets = insets;
        }
    } else {
        _refreshHeaderView.insets = UIEdgeInsetsZero;
        _refreshFooterView.insets = UIEdgeInsetsZero;
    }
}

//- (void) setContentSize:(CGSize)contentSize
//{ //保证contentsize至少和frame.size.height 相等，这是为了解决上拉加载更多的动画被隐藏的问题
//    CGFloat height = MAX(contentSize.height, self.bounds.size.height);
//    CGSize cz = contentSize;
//    cz.height = height;
//    [super setContentSize:cz];
//}

-(void)setHeaderView
{
    if (!_bHeader) return;
    
    if (_refreshHeaderView) {
        [self removeHeaderView];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                                     self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
    
	[self addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView
{
    if (_refreshHeaderView) {
        if ([_refreshHeaderView superview]) {
            [_refreshHeaderView removeFromSuperview];
        }
         _refreshHeaderView = nil;
    }
}

-(void)setFooterView
{
    if (!_bFooter) return;
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.frame.size.width,
                                              self.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.frame.size.width, self.bounds.size.height)];
        _refreshFooterView.backgroundColor = [UIColor clearColor];
        _refreshFooterView.delegate = self;
        [self addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
    _refreshFooterView.insets = _refreshHeaderView.insets;
}

-(void)removeFooterView
{
    if (_refreshFooterView) {
        if ([_refreshFooterView superview]) {
            [_refreshFooterView removeFromSuperview];
        }
       _refreshFooterView = nil;
    }
}

#pragma mark - Private 截获ScrollView的代理 调用加载动画
- (void) _scrollViewDidScroll
{
    if (_reloading) return;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:self];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:self];
    }
}

- (void) _scrollViewDidEndDragging
{
    if (_reloading) return;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:self];
    }
}



#pragma mark - EGO Delegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    _reloading = YES;
    [self performSelector:@selector(_beginToReloadData:) withObject:[NSNumber numberWithInt:aRefreshPos] afterDelay:0.0];
    //    [self beginToReloadData:aRefreshPos];
}

//用于显示是否正在刷新
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading;
}

//用于显示刷新的时间
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    //    return [NSDate date];
    return nil;
}

- (void) _beginToReloadData:(NSNumber*)EGORefreshPosNumber
{
    //    [self beginToReloadData:[EGORefreshPosNumber integerValue]];
    if ([_pulledDelegate respondsToSelector:@selector(beginToLoadData:)]) {
        [_pulledDelegate beginToLoadData:[EGORefreshPosNumber integerValue]];
    }
    if ([_pulledDelegate respondsToSelector:@selector(tableView:beginToLoadData:)]) {
        [_pulledDelegate tableView:self beginToLoadData:[EGORefreshPosNumber integerValue]];
    }
}

#pragma mark - Public Function
-(void)setBHeader:(BOOL)bHeader
{
    _bHeader = bHeader;
    if (!_bHeader) {
        [self removeHeaderView];
    } else {
        [self setHeaderView];
    }
}

- (void) setBFooter:(BOOL)bFooter
{
    _bFooter = bFooter;
    if (!_bFooter) {
        [self removeFooterView];
    } else {
        [self setFooterView];
    }
}

- (void) finishReloading
{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        [self setFooterView];
    }
    _reloading = NO;
}

- (void) startPullToRefreshWithAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.contentOffset = CGPointMake(0, -(REFRESH_REGION_HEIGHT+_refreshHeaderView.insets.top));
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 if (_refreshHeaderView) {
                                     [_refreshHeaderView finishPullToRefresh:self];
                                 }
                             }
                         }];
    } else {
        self.contentOffset = CGPointMake(0, -(REFRESH_REGION_HEIGHT+_refreshHeaderView.insets.top));
        [self _scrollViewDidEndDragging];
    }
}

- (void) didFinishStartPullToRefreshAnimation
{
    [self _scrollViewDidEndDragging];
}


@end


#pragma mark - UIScrollView Delegate 中转层
@implementation TransitTableViewPrivateDelegate

//And we need to handle all of the other UIScrollViewDelegate methods that we don't have custom code for,
//and all of those messages that will be added in future versions of iOS. We have to implement two methods to make that happen
- (BOOL)respondsToSelector:(SEL)selector { //此函数和forwardInvocation函数可以让我们避免实现所有的UIScrollView的代理(按需实现即可)
    return [_userDelegate respondsToSelector:selector] || [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // This should only ever be called from `UIScrollView`, after it has verified
    // that `_userDelegate` responds to the selector by sending me
    // `respondsToSelector:`.  So I don't need to check again here.
    [invocation invokeWithTarget:_userDelegate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BDMPulledTableView* pulledTable = (BDMPulledTableView*)scrollView;
    [pulledTable _scrollViewDidScroll];
    
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    BDMPulledTableView* pulledTable = (BDMPulledTableView*)scrollView;
    [pulledTable _scrollViewDidEndDragging];
    
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


@end
