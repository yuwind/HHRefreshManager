//
//  HHStarRefreshView.m
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 2018/7/11.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "HHStarRefreshView.h"

#define STARWIDTH 20

@interface HHStarRefreshView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation HHStarRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configInitialInfo];
    }
    return self;
}

- (void)configInitialInfo
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.containerView = containerView;
    [self addSubview:containerView];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.bounds = CGRectMake(0, 0, 40, 40);
    self.shapeLayer.lineWidth = 2.0f;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [containerView.layer addSublayer:self.shapeLayer];
    self.shapeLayer.position = CGPointMake(20, 20);
    self.shapeLayer.strokeStart = 0.0f;
    self.shapeLayer.strokeEnd = 0.0f;
    self.shapeLayer.speed = 0.0f;
    
    CGFloat radius = STARWIDTH/2/sin(72*M_PI/180);//外接圆半径
    CGFloat hight = cos(36*M_PI/180) * radius;//中心点到两点间垂线
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    [bezierPath moveToPoint:CGPointMake(20, 20-radius)];
    [bezierPath addLineToPoint:CGPointMake(20-sin(36*M_PI/180)*radius, 20+hight)];
    [bezierPath addLineToPoint:CGPointMake(20+STARWIDTH/2, 20-STARWIDTH/2*tan(18*M_PI/180))];
    [bezierPath addLineToPoint:CGPointMake(20-STARWIDTH/2, 20-STARWIDTH/2*tan(18*M_PI/180))];
    [bezierPath addLineToPoint:CGPointMake(20+sin(36*M_PI/180)*radius, 20+hight)];
    [bezierPath closePath];
    self.shapeLayer.path = bezierPath.CGPath;
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.fromValue = @(0.0);
    basic.toValue = @(1.0f);
    basic.duration = 0.1f;
    basic.removedOnCompletion = NO;
    basic.fillMode = kCAFillModeForwards;
    [self.shapeLayer addAnimation:basic forKey:@"AnimationStroke"];
}

- (void)layoutSubviews
{
    self.containerView.center = CGPointMake(self.width/2, self.height/2);
}

- (void)normalRefresh:(CGFloat)rate
{
    if (self.isFooter) {
        self.containerView.y = 10*rate;
    }else{    
        self.containerView.centerY = self.height-(self.height-10)/2*rate-5;
    }
    self.shapeLayer.speed = 0.0f;
    self.shapeLayer.timeOffset = rate/10;
}

- (void)readyRefresh
{
    self.shapeLayer.timeOffset = 0.1f;
}

- (void)beginRefresh
{
    self.shapeLayer.speed = 1.0f;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @(0.0);
    rotate.toValue = @(2*M_PI);
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;

    CAKeyframeAnimation *scale =[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[[NSValue valueWithCGPoint:CGPointMake(1, 1)],[NSValue valueWithCGPoint:CGPointMake(0.6, 0.6)],[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
    scale.removedOnCompletion = NO;
    scale.fillMode = kCAFillModeForwards;

    CAAnimationGroup *groupAni = [CAAnimationGroup animation];
    groupAni.duration = 2.0f;
    groupAni.repeatCount = HUGE;
    groupAni.removedOnCompletion = NO;
    groupAni.fillMode = kCAFillModeForwards;
    groupAni.animations = @[rotate,scale];
    [self.shapeLayer addAnimation:groupAni forKey:@"animationGroup"];
}

- (void)endRefresh
{
    self.shapeLayer.speed = 0.0f;
    self.shapeLayer.timeOffset = 0.0f;
    [self.shapeLayer removeAnimationForKey:@"animationGroup"];
}


@end
