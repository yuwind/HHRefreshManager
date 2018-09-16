//
//  HHRefreshManager.m
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 16/11/11.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import "HHRefreshManager.h"
#import "HHHeaderRefreshView.h"
#import "HHFooterRefreshView.h"
#import "HHCircleRefreshView.h"
#import "HHPointRefreshView.h"
#import "HHStarRefreshView.h"
#import "UIView+HHLayout.h"

#define REFRESHHEIGHT 60
#define LOSTDISTANCE 0
#define ANIMTIONTIME 0.25

@interface HHRefreshManager ()

@property (nonatomic, strong) HHBaseRefreshView *headerView;
@property (nonatomic, strong) HHBaseRefreshView *footerView;
@property (nonatomic, weak)   id<HHRefreshManagerDelegate>delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isHeaderRefresh;
@property (nonatomic, assign) BOOL isFooterRefresh;
@property (nonatomic, assign) BOOL canHeaderRefresh;
@property (nonatomic, assign) BOOL canFooterRefresh;

@end

@implementation HHRefreshManager

+ (instancetype)refreshWithDelegate:(id<HHRefreshManagerDelegate>)delegate scrollView:(UIScrollView *)scrollView
{
    return [self refreshWithDelegate:delegate scrollView: scrollView type:AnimationTypeNormal];
}
+ (instancetype)refreshWithDelegate:(id<HHRefreshManagerDelegate>)delegate scrollView:(UIScrollView *)scrollView type:(AnimationType)type
{
    HHRefreshManager *refresh = [[HHRefreshManager alloc]init];
    [refresh addNotification:scrollView];
    [refresh setScrollView:scrollView];
    [refresh setDelegate:delegate];
    [refresh configBaseInfo];
    [refresh setAnimationType:type];
    
    return refresh;
}

- (void)addNotification:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)applicationDidBecomeActive:(NSNotification *)notify
{
    if (_isHeaderRefresh){
        if ([_headerView isMemberOfClass:[HHHeaderRefreshView class]]) return;
        [_headerView beginRefresh];
    }
    if (_isFooterRefresh) {
        if ([_footerView isMemberOfClass:[HHFooterRefreshView class]]) return;
        [_footerView beginRefresh];
    }
}

- (void)applicationWillResignActive:(NSNotification *)notify
{
    if (_isHeaderRefresh){
        if([_headerView isMemberOfClass:[HHHeaderRefreshView class]]) return;
        [_headerView endRefresh];
    }
    if (_isFooterRefresh) {
        if([_footerView isMemberOfClass:[HHFooterRefreshView class]]) return;
        [_footerView endRefresh];
    }
}
- (void)configBaseInfo
{
    _gradualAlpha = YES;
    _isNeedRefresh = YES;
    _isNeedFootRefresh = YES;
    _isNeedHeadRefresh = YES;
}

- (void)setAnimationType:(AnimationType)animationType
{
    _animationType = animationType;
    if (_headerView) {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    if (_footerView) {
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    
    switch (_animationType) {
        case AnimationTypeNormal:{
            _headerView = [[HHHeaderRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            _footerView = [[HHFooterRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
        }
            break;
        case AnimationTypeCircle:{
            HHCircleRefreshView *circleHeaderView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            circleHeaderView.isShowShadow = NO;
            _headerView = circleHeaderView;
            HHCircleRefreshView *circleFooterView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            circleFooterView.isFooter = YES;
            circleFooterView.isShowShadow = NO;
            _footerView = circleFooterView;
        }
            break;
        case AnimationTypeSemiCircle:{
            HHCircleRefreshView *semiHeaderView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            semiHeaderView.animateType = AnimationTypeSemiCircle;
            semiHeaderView.isShowShadow = NO;
            semiHeaderView.coverColor = [UIColor redColor];
            semiHeaderView.animationTime = 1;
            _headerView = semiHeaderView;
            
            HHCircleRefreshView *semiFooterView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            semiFooterView.animateType = AnimationTypeSemiCircle;
            semiFooterView.isShowShadow = NO;
            semiFooterView.coverColor = [UIColor redColor];
            semiFooterView.animationTime = 1;
            semiFooterView.isFooter = YES;
            _footerView = semiFooterView;
        }
            break;
        case AnimationTypePoint:{
            _gradualAlpha = NO;
            
            HHPointRefreshView *circleHeaderView = [[HHPointRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            _headerView = circleHeaderView;
            
            HHPointRefreshView *circleFooterView = [[HHPointRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            circleFooterView.isFooter = YES;
            _footerView = circleFooterView;
        }
            break;
        case AnimationTypeStar:{
            _gradualAlpha = NO;
            
            HHStarRefreshView *starHeaderView = [[HHStarRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            _headerView = starHeaderView;
            
            HHStarRefreshView *starFooterView = [[HHStarRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, REFRESHHEIGHT)];
            starFooterView.isFooter = YES;
            _footerView = starFooterView;
        }
            break;
        default:
            break;
    }
    [_scrollView addSubview:_headerView];
    _headerView.width = _scrollView.width;
    _headerView.maxY = 0;
    _headerView.x = 0;
    [_scrollView addSubview:_footerView];
    _footerView.y =_scrollView.height >_scrollView.contentSize.height?_scrollView.height:_scrollView.contentSize.height;
    _footerView.x = 0;
}

- (void)setIsNeedRefresh:(BOOL)isNeedRefresh
{
    _isNeedRefresh = isNeedRefresh;
    _headerView.hidden = !isNeedRefresh;
    _footerView.hidden = !isNeedRefresh;
}
- (void)setIsNeedHeadRefresh:(BOOL)isNeedHeadRefresh
{
    _isNeedHeadRefresh = isNeedHeadRefresh;
    _headerView.hidden = !isNeedHeadRefresh;
}
- (void)setIsNeedFootRefresh:(BOOL)isNeedFootRefresh
{
    _isNeedFootRefresh = isNeedFootRefresh;
    _footerView.hidden = !isNeedFootRefresh;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (!_isNeedRefresh)return;
    _headerView.width=_footerView.width=_scrollView.width;
    
    _footerView.y =_scrollView.height >_scrollView.contentSize.height?_scrollView.height:_scrollView.contentSize.height;
    if (_scrollView.isDragging) {
        
        CGFloat _offsetY = _scrollView.contentOffset.y;
        if (_offsetY>0) {
            if (_isFooterRefresh)return;
            if (!_isNeedFootRefresh)return;
            CGFloat distance = _scrollView.frame.size.height>_scrollView.contentSize.height?_offsetY:_offsetY+_scrollView.frame.size.height-_scrollView.contentSize.height;
            
            if (distance>0) {
                if (distance < REFRESHHEIGHT) {
                    _canFooterRefresh = NO;
                    [_footerView normalRefresh:(distance-LOSTDISTANCE>0?distance-LOSTDISTANCE:0)/(REFRESHHEIGHT-LOSTDISTANCE)];
                    if (_gradualAlpha) {
                        
                        _footerView.alpha = distance/REFRESHHEIGHT;
                    }
                }else{
                    _canFooterRefresh = YES;
                    _footerView.alpha = 1.0f;
                    [_footerView readyRefresh];
                }
            }
        }else{
            if (_isHeaderRefresh)return;
            if (!_isNeedHeadRefresh) return;
            if (_offsetY > -REFRESHHEIGHT && _offsetY < 0) {
                _canHeaderRefresh = NO;
                [_headerView normalRefresh:(fabs(_offsetY)-LOSTDISTANCE>0?fabs(_offsetY)-LOSTDISTANCE:0)/(REFRESHHEIGHT-LOSTDISTANCE)];
                if (_gradualAlpha) {
                    
                    _headerView.alpha = fabs(_offsetY)/REFRESHHEIGHT;
                }
            }
            if (_offsetY <= -REFRESHHEIGHT) {
                _canHeaderRefresh = YES;
                _headerView.alpha = 1.0f;
                [_headerView readyRefresh];
            }
        }
    }else{
        if (_canFooterRefresh){
            _canFooterRefresh = NO;
            [_footerView beginRefresh];
            _isFooterRefresh = YES;
            if (_isHeaderRefresh) {
                [UIView animateWithDuration:ANIMTIONTIME animations:^{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(REFRESHHEIGHT, 0, REFRESHHEIGHT, 0)];
                }];
            }else{
                if (_scrollView.height >_scrollView.contentSize.height) {
                    [UIView animateWithDuration:ANIMTIONTIME animations:^{
                        [self.scrollView setContentInset:UIEdgeInsetsMake(-REFRESHHEIGHT, 0, 0, 0)];
                    }];
                }else{
                    [UIView animateWithDuration:ANIMTIONTIME animations:^{
                        [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, REFRESHHEIGHT, 0)];
                    }];
                }
            }
            if (_delegate && [_delegate respondsToSelector:@selector(beginRefreshWithType:)]) {
                [_delegate beginRefreshWithType:HHRefreshTypeFooter];
            }
        }
        
        if (_canHeaderRefresh) {
            _canHeaderRefresh = NO;
            [_headerView beginRefresh];
            _isHeaderRefresh = YES;
            if (_isFooterRefresh) {
                [UIView animateWithDuration:ANIMTIONTIME animations:^{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(REFRESHHEIGHT, 0, REFRESHHEIGHT, 0)];
                }];
            }else{
                [UIView animateWithDuration:ANIMTIONTIME animations:^{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(REFRESHHEIGHT, 0, 0, 0)];
                }];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(beginRefreshWithType:)]) {
                [_delegate beginRefreshWithType:HHRefreshTypeHeader];
            }
        }
    }
}

- (void)endRefreshWithType:(HHRefreshType)type
{
    if (type == HHRefreshTypeHeader) {
        _isHeaderRefresh = NO;
        [_headerView endRefresh];
        if (_isFooterRefresh) {
            [UIView animateWithDuration:ANIMTIONTIME animations:^{
                
                [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, REFRESHHEIGHT, 0)];
            }];
        }else{
            [UIView animateWithDuration:ANIMTIONTIME animations:^{
                
                [self.scrollView setContentInset:UIEdgeInsetsZero];
            }];
        }
    }else{
        _isFooterRefresh = NO;
        [_footerView endRefresh];
        if (_isHeaderRefresh) {
            [UIView animateWithDuration:ANIMTIONTIME animations:^{
                
                [self.scrollView setContentInset:UIEdgeInsetsMake(REFRESHHEIGHT, 0, 0, 0)];
            }];
        }else{
            [UIView animateWithDuration:ANIMTIONTIME animations:^{
                
                [self.scrollView setContentInset:UIEdgeInsetsZero];
            }];
        }
    }
}
- (void)removeInitialSubviews
{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        _scrollView = nil;
    }
    [_headerView removeFromSuperview];
    [_footerView removeFromSuperview];
    _headerView = nil;
    _footerView = nil;
}

- (void)automaticHeaderRefresh
{
    if (self.animationType == AnimationTypeStar) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.canHeaderRefresh = YES;
            [self.scrollView setContentOffset:CGPointMake(0, -60)];
        });
    }else{
        self.canHeaderRefresh = YES;
        [self.scrollView setContentOffset:CGPointMake(0, -60)];
    }
}

- (void)dealloc
{
    !_scrollView?:[_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
