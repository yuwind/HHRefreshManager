//
//  HHCircleRefreshView.m
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 2017/3/30.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "HHCircleRefreshView.h"

#define ANIMATETIME 0.75
#define LINEWIDTH 2
#define RADIUS 12

@interface HHCircleRefreshView ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *shadowLayer;
@property (nonatomic, strong) CAShapeLayer *coverLayer;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation HHCircleRefreshView

- (CAShapeLayer *)shadowLayer
{
    if (_shadowLayer == nil) {
        _shadowLayer = [CAShapeLayer layer];
        _shadowLayer.fillColor = [UIColor clearColor].CGColor;
        _shadowLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _shadowLayer.lineCap = kCALineCapRound;
        _shadowLayer.lineJoin = kCALineJoinRound;
        _shadowLayer.lineWidth = LINEWIDTH;
        _shadowLayer.frame = CGRectMake(0, 0,RADIUS * 2, RADIUS * 2);
        _shadowLayer.path = [UIBezierPath bezierPathWithOvalInRect:_shadowLayer.bounds].CGPath;
    }
    return _shadowLayer;
}

- (CAShapeLayer *)coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [CAShapeLayer layer];
        _coverLayer.fillColor = [UIColor clearColor].CGColor;
        _coverLayer.strokeColor = [UIColor redColor].CGColor;
        _coverLayer.lineCap = kCALineCapRound;
        _coverLayer.lineJoin = kCALineJoinRound;
        _coverLayer.lineWidth = LINEWIDTH;
        _coverLayer.bounds = CGRectMake(0, 0,RADIUS * 2, RADIUS * 2);
        _coverLayer.path = [UIBezierPath bezierPathWithOvalInRect:_coverLayer.bounds].CGPath;
        _coverLayer.strokeStart = 0;
        _coverLayer.strokeEnd = 0;
    }
    return _coverLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self initBaseConifg];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        
        [self initBaseConifg];
    }
    return self;
}

- (void)initBaseConifg
{
    _rate = 0;
    _animateType = AnimationTypeCircle;
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.shadowLayer];
    [self.layer addSublayer:self.coverLayer];
}

- (void)layoutSubviews
{
    CGPoint position = self.coverLayer.position;
    position.x = self.width/2;
    position.y = _isFooter?self.height/2-5:self.height/2+5;
    self.coverLayer.position = position;
    self.shadowLayer.position = position;
}
- (void)setIsFooter:(BOOL)isFooter
{
    _isFooter = isFooter;
    [self layoutSubviews];
}
- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    self.shadowLayer.hidden = !isShowShadow;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    self.coverLayer.bounds = CGRectMake(0, 0,radius * 2, radius * 2);
    self.coverLayer.path = [UIBezierPath bezierPathWithOvalInRect:_coverLayer.bounds].CGPath;
    self.shadowLayer.bounds = CGRectMake(0, 0,radius * 2, radius * 2);
    self.shadowLayer.path = [UIBezierPath bezierPathWithOvalInRect:_coverLayer.bounds].CGPath;
}

- (void)setCoverColor:(UIColor *)coverColor
{
    _coverColor = coverColor;
    self.coverLayer.strokeColor = coverColor.CGColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    self.shadowLayer.strokeColor = shadowColor.CGColor;
}

- (void)normalRefresh:(CGFloat)rate
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.coverLayer.strokeEnd = rate-0.05;
    [CATransaction commit];
    [self resetRefreshData];
    _isRefresh = NO;
}

- (void)readyRefresh
{
    self.coverLayer.strokeEnd = 1;
    [self resetRefreshData];
    _isRefresh = NO;
}

- (void)beginRefresh
{
    if (_isRefresh)return;
    _isRefresh = YES;
    [self startAnimation:NO];
}

- (void)endRefresh
{
    if (_isRefresh == NO)return;
    _rate = 0;
    _isRefresh = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.coverLayer.opacity = 0;
    }];
    __weak __typeof(self)wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        wSelf.coverLayer.opacity = 1;
        wSelf.coverLayer.strokeStart = 0;
        wSelf.coverLayer.strokeEnd = 0;
        [wSelf.coverLayer removeAllAnimations];
    });
}
- (void)resetRefreshData
{
    if (_isRefresh == NO)return;
    _rate = 0;
    self.coverLayer.opacity = 1;
    _coverLayer.strokeStart = 0;
    _coverLayer.strokeEnd = 0;
}

- (void)startAnimation:(BOOL)reverse
{
    switch (_animateType) {
        case AnimationTypeCircle:{
            [self startCircleAnimation:reverse];
        }
            break;
        case AnimationTypeSemiCircle:{
            [self startSemiCircleAnimation];
        }
            break;
        default:
            break;
    }
}
- (void)startCircleAnimation:(BOOL)reverse
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (reverse) {
        
        self.coverLayer.strokeStart = 0.89;
        self.coverLayer.strokeEnd = 0.9;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @(0.9);
        strokeAnimation.duration = _animationTime?_animationTime:ANIMATETIME;
        strokeAnimation.delegate = self;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
        [self.coverLayer removeAnimationForKey:@"strokeStart"];
        [self.coverLayer addAnimation:strokeAnimation forKey:@"strokeStart"];
        
    }else{
        if (_isFirst) _rate -= 0.2*M_PI;
        _isFirst = YES;
        self.coverLayer.strokeStart = 0;
        self.coverLayer.strokeEnd = 0.9;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @(0.9);
        strokeAnimation.duration = _animationTime?_animationTime:ANIMATETIME;
        strokeAnimation.delegate = self;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
        
        [self.coverLayer removeAnimationForKey:@"strokeEnd"];
        [self.coverLayer addAnimation:strokeAnimation forKey:@"strokeEnd"];
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(_rate);
        rotationAnimation.toValue = @(_rate + 2 * M_PI);
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.duration = _animationTime?2*_animationTime:2*ANIMATETIME;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        [self.coverLayer removeAnimationForKey:@"rotation"];
        [self.coverLayer addAnimation:rotationAnimation forKey:@"rotation"];
    }
    [CATransaction commit];
}

- (void)startSemiCircleAnimation
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.coverLayer.strokeStart = 0;
    self.coverLayer.strokeEnd = 0.8;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = _animationTime?_animationTime:1;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = HUGE;
    [self.coverLayer removeAnimationForKey:@"rotation"];
    [self.coverLayer addAnimation:rotationAnimation forKey:@"rotation"];
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished && [anim isKindOfClass:[CABasicAnimation class]]){
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
        BOOL isStrokeEnd = [basicAnim.keyPath isEqualToString:@"strokeEnd"];
        [self startAnimation:isStrokeEnd];
    }
}


@end
