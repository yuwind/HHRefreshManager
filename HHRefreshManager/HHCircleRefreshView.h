//
//  HHCircleRefreshView.h
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 2017/3/30.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "HHBaseRefreshView.h"

@interface HHCircleRefreshView : HHBaseRefreshView

@property (nonatomic, assign) AnimationType animateType;//动画类型默认:AnimationTypeCircle
@property (nonatomic, assign) CGFloat animationTime;//动画时间
@property (nonatomic, strong) UIColor *shadowColor;//背景颜色
@property (nonatomic, strong) UIColor *coverColor;//前景颜色
@property (nonatomic, assign) BOOL isShowShadow;//是否显示背景layer
@property (nonatomic, assign) CGFloat radius;//设置圆环半径
@property (nonatomic, assign) BOOL isFooter; //修改刷新控件坐标,如果是底部刷新设置为YES

@end
