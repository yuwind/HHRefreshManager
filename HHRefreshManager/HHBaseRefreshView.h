//
//  HHBaseRefreshView.h
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 2017/3/30.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HHLayout.h"

typedef enum : NSUInteger {
    AnimationTypeNormal,
    AnimationTypeCircle,
    AnimationTypeSemiCircle,
    AnimationTypePoint,
    AnimationTypeStar,
} AnimationType;

@interface HHBaseRefreshView : UIView

/**
 需要子类重写

 @param rate 比率eg.[0 1]
 */
- (void)normalRefresh:(CGFloat)rate;

- (void)readyRefresh;

- (void)beginRefresh;

- (void)endRefresh;


@end
