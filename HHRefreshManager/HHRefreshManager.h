//
//  HHRefreshManager.h
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 16/11/11.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBaseRefreshView.h"

typedef enum : NSUInteger {
    HHRefreshTypeNone = 0,
    HHRefreshTypeFooter,
    HHRefreshTypeHeader,
} HHRefreshType;

@protocol HHRefreshManagerDelegate <NSObject>

- (void)beginRefreshWithType:(HHRefreshType)type;

@end

@interface HHRefreshManager : NSObject

@property (nonatomic, assign) BOOL gradualAlpha;//是否需要渐变，默认YES
@property (nonatomic, assign) BOOL isNeedRefresh;//是否需要刷新, 默认YES
@property (nonatomic, assign) BOOL isNeedHeadRefresh;//是否隐藏头部刷新
@property (nonatomic, assign) BOOL isNeedFootRefresh;//是否隐藏尾部刷新
@property (nonatomic, assign) AnimationType animationType;//刷新类型

/**
 实例化方法, 内部KVO监听tableView的contentOffset
 
 @param delegate 代理对象
 @param scrollView 需要监听的对象
 @return 当前类的实例
 */
+ (instancetype)refreshWithDelegate:(id<HHRefreshManagerDelegate>)delegate scrollView:(UIScrollView *)scrollView;

+ (instancetype)refreshWithDelegate:(id<HHRefreshManagerDelegate>)delegate scrollView:(UIScrollView *)scrollView type:(AnimationType)type;

/**
 结束刷新
 */
- (void)endRefreshWithType:(HHRefreshType)type;

/**
 移除初始化视图
 */
- (void)removeInitialSubviews;

/**
 头部自动刷新
 */
- (void)automaticHeaderRefresh;

@end
