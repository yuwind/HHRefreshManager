//
//  HHPointRefreshView.h
//  https://github.com/yuwind/HHRefreshManager
//
//  Created by 豫风 on 2018/7/10.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "HHBaseRefreshView.h"

#define DEFAULTDIAMETER 10 //圆直径
#define DEFAULTDISTANCE 30 //间距
#define NORMALCLOLR [UIColor lightGrayColor] //默认颜色
#define REFRESHCOLOR [UIColor redColor] //刷新颜色

@interface HHPointRefreshView : HHBaseRefreshView

@property (nonatomic, assign) BOOL isFooter;

@end
