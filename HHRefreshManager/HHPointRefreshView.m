//
//  HHPointRefreshView.m
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 2018/7/10.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "HHPointRefreshView.h"

@interface HHPointRefreshView()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation HHPointRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configBaseView];
    }
    return self;
}

- (void)configBaseView
{
    _leftView = [UIView new];
    _leftView.backgroundColor = NORMALCLOLR;
    _leftView.size = CGSizeMake(DEFAULTDIAMETER, DEFAULTDIAMETER);
    _leftView.layer.cornerRadius = DEFAULTDIAMETER/2;
    _leftView.layer.masksToBounds = YES;
    [self addSubview:_leftView];
    
    _middleView = [UIView new];
    _middleView.backgroundColor = NORMALCLOLR;
    _middleView.size = CGSizeMake(DEFAULTDIAMETER, DEFAULTDIAMETER);
    _middleView.layer.cornerRadius = DEFAULTDIAMETER/2;
    _middleView.layer.masksToBounds = YES;
    [self addSubview:_middleView];
    
    _rightView = [UIView new];
    _rightView.backgroundColor = NORMALCLOLR;
    _rightView.size = CGSizeMake(DEFAULTDIAMETER, DEFAULTDIAMETER);
    _rightView.layer.cornerRadius = DEFAULTDIAMETER/2;
    _rightView.layer.masksToBounds = YES;
    [self addSubview:_rightView];
}

- (void)normalRefresh:(CGFloat)rate
{
    if (rate<=0.5) {
        
        _middleView.transform = CGAffineTransformMakeScale(3*rate, 3*rate);
        _leftView.hidden = _rightView.hidden = YES;
    }else{
        _middleView.transform = CGAffineTransformMakeScale(2-rate, 2-rate);
        _leftView.hidden = _rightView.hidden = NO;
        if (self.isFooter) {
            _leftView.y = _rightView.y = (self.height-DEFAULTDIAMETER)/2 * rate;
        }else{
            _leftView.maxY = _rightView.maxY = self.height - (self.height-DEFAULTDIAMETER)/2 * rate;
        }
        _leftView.centerX = self.width/2 - DEFAULTDISTANCE*(rate-0.5);
        _rightView.centerX = self.width/2 + DEFAULTDISTANCE*(rate-0.5);
    }
    if (self.isFooter) {
        _middleView.y = (self.height-DEFAULTDIAMETER)/2 * rate;
    }else{
        
        _middleView.maxY = self.height - (self.height-DEFAULTDIAMETER)/2 * rate;
    }
    _middleView.centerX = self.width/2;
    _leftView.backgroundColor = _middleView.backgroundColor = _rightView.backgroundColor = NORMALCLOLR;
}

- (void)readyRefresh
{
    _middleView.transform = CGAffineTransformIdentity;
    _leftView.hidden = _rightView.hidden = NO;
    if (self.isFooter) {
        _leftView.y = _rightView.y = _middleView.y = (self.height-DEFAULTDIAMETER)/2;
    }else{
        _leftView.maxY = _rightView.maxY = _middleView.maxY = self.height - (self.height-DEFAULTDIAMETER)/2;
    }
    _middleView.centerX = self.width/2;
    _leftView.centerX = self.width/2 - DEFAULTDISTANCE/2;
    _rightView.centerX = self.width/2 + DEFAULTDISTANCE/2;
    _leftView.backgroundColor = _middleView.backgroundColor = _rightView.backgroundColor = REFRESHCOLOR;
}

- (void)beginRefresh
{
    _middleView.transform = CGAffineTransformIdentity;
    _leftView.hidden = _rightView.hidden = NO;
    if (self.isFooter) {
        _leftView.y = _rightView.y = _middleView.y = (self.height-DEFAULTDIAMETER)/2;
    }else{
        _leftView.maxY = _rightView.maxY = _middleView.maxY = self.height - (self.height-DEFAULTDIAMETER)/2;
    }
    //todo
    _middleView.centerX = [UIScreen mainScreen].bounds.size.width/2;
    _leftView.centerX = [UIScreen mainScreen].bounds.size.width/2 - DEFAULTDISTANCE/2;
    _rightView.centerX = [UIScreen mainScreen].bounds.size.width/2 + DEFAULTDISTANCE/2;
    
    _leftView.backgroundColor = _middleView.backgroundColor = _rightView.backgroundColor = REFRESHCOLOR;
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    CATransform3D t3 = CATransform3DScale(t, 0.1, 0.1, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    scaleAnim.duration = 0.45;
    scaleAnim.autoreverses = YES;
    scaleAnim.repeatCount = HUGE;
    [self.leftView.layer addAnimation:scaleAnim forKey:nil];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        CATransform3D t2 = CATransform3DScale(t, 1.0, 1.0, 0.0);
        CATransform3D t3 = CATransform3DScale(t, 0.1, 0.1, 0.0);
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
        scaleAnim.duration = 0.45;
        scaleAnim.autoreverses = YES;
        scaleAnim.repeatCount = HUGE;
        [weakSelf.middleView.layer addAnimation:scaleAnim forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
            CATransform3D t = CATransform3DIdentity;
            CATransform3D t2 = CATransform3DScale(t, 1.0, 1.0, 0.0);
            CATransform3D t3 = CATransform3DScale(t, 0.1, 0.1, 0.0);
            scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
            scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
            scaleAnim.duration = 0.45;
            scaleAnim.autoreverses = YES;
            scaleAnim.repeatCount = HUGE;
            [weakSelf.rightView.layer addAnimation:scaleAnim forKey:nil];
        });
    });
}

- (void)endRefresh
{
    [self.leftView.layer removeAllAnimations];
    [self.middleView.layer removeAllAnimations];
    [self.rightView.layer removeAllAnimations];
    _leftView.backgroundColor = _middleView.backgroundColor = _rightView.backgroundColor = NORMALCLOLR;
}

@end
