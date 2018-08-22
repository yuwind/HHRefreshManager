//
//  HHHeaderRefreshView.m
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 16/11/11.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import "HHHeaderRefreshView.h"

@interface HHHeaderRefreshView ()

@property (nonatomic, strong) NSArray <NSString *>*titleArray;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation HHHeaderRefreshView
{
    BOOL isImageViewUp;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"下拉可以刷新...",@"松开即可刷新...",@"刷新中..."];
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
        _imageView.image =[self refreshmImageTop];
        [_imageView sizeToFit];
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
- (UIImage *)refreshmImageTop
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
    _indicator.centerY = self.height/2 + 8;
    _indicator.centerX = self.width/2 - 50;
    _imageView.centerY = self.height/2 + 8;
    _imageView.centerX = self.width/2 - 50;
    _label.centerY     = self.height/2 + 8;
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
    if (isImageViewUp) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.transform =CGAffineTransformMakeRotation(0);
        }];
        isImageViewUp = NO;
    }
    _label.text = self.titleArray[0];
    _imageView.hidden = NO;
    _indicator.hidden = YES;
    [self.indicator stopAnimating];
}

- (void)readyRefresh
{
    if (!isImageViewUp) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        isImageViewUp = YES;
    }
    _label.text = self.titleArray[1];
    _imageView.hidden = NO;
    _indicator.hidden = YES;
}

- (void)beginRefresh
{
    if (isImageViewUp) {
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.transform =CGAffineTransformIdentity;
        }];
        isImageViewUp = NO;
    }
    _indicator.hidden = NO;
    _imageView.hidden = YES;
    _label.text = self.titleArray[2];
    [self.indicator startAnimating];
}

- (void)endRefresh
{
    isImageViewUp = NO;
    _imageView.hidden = NO;
    _label.text = self.titleArray[0];
    [self.indicator stopAnimating];
}


@end
