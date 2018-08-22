//
//  HHFooterRefreshView.m
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 16/11/11.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import "HHFooterRefreshView.h"

@interface HHFooterRefreshView ()

@property (nonatomic, strong) NSArray <NSString *>*titleArray;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation HHFooterRefreshView
{
    BOOL isImageViewDown;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"上拉加载更多...",@"松手即可加载...",@"加载中..."];
    }
    return _titleArray;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.color = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _indicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
    return _indicator;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [self refreshImageBottom];
        [_imageView sizeToFit];
        _imageView.transform =CGAffineTransformMakeRotation(M_PI);
    }
    return _imageView;
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        _label.text = self.titleArray[0];
        [_label sizeToFit];
    }
    return _label;
}

- (UIImage *)refreshImageBottom
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"refreshmImages.bundle" ofType:nil];
    NSString *placeholdPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"common_refresh_arrow@3x.png" ofType:nil];
    return [UIImage imageWithContentsOfFile:placeholdPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configBaseView];
    }
    return self;
}
- (void)layoutSubviews
{
    _indicator.centerY = self.height/2;
    _indicator.centerX = self.width/2 - 50;
    _imageView.centerY = self.height/2;
    _imageView.centerX = self.width/2 - 50;
    _label.centerY     = self.height/2;
    _label.x           = CGRectGetMaxX(_imageView.frame)+10;
}
- (void)configBaseView
{
    [self addSubview:self.indicator];
    [self addSubview:self.imageView];
    [self addSubview:self.label];
}

- (void)normalRefresh:(CGFloat)rate
{
    if (isImageViewDown) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.transform =CGAffineTransformMakeRotation(M_PI);;
        }];
        isImageViewDown = NO;
    }
    _label.text = self.titleArray[0];
    _imageView.hidden = NO;
    _indicator.hidden = YES;
    [self.indicator stopAnimating];
}

- (void)readyRefresh
{
    if (!isImageViewDown) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
        isImageViewDown = YES;
    }
    _label.text = self.titleArray[1];
    _imageView.hidden = NO;
    _indicator.hidden = YES;
}

- (void)beginRefresh
{
    if (isImageViewDown) {
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.transform =CGAffineTransformMakeRotation(M_PI);
        }];
        isImageViewDown = NO;
    }
    _indicator.hidden = NO;
    _imageView.hidden = YES;
    _label.text = self.titleArray[2];
    [self.indicator startAnimating];
}

- (void)endRefresh
{
    isImageViewDown = NO;
    _imageView.hidden = NO;
    _label.text = self.titleArray[0];
    [self.indicator stopAnimating];
}

@end
