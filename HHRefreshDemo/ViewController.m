//
//  ViewController.m
//  RefreshManager
//
//  Created by 豫风 on 16/11/11.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import "ViewController.h"
#import "HHTableViewController.h"

NSString * refreshStyle[] =
{
    @"RefreshNormal",
    @"RefreshCircle",
    @"RefreshSemiCircle",
    @"RefreshPoint",
    @"RefreshStar",
};

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sizeof(refreshStyle)/sizeof(refreshStyle[0]);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = refreshStyle[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HHTableViewController *refreshVC = [[HHTableViewController alloc] init];
    refreshVC.navTitle = refreshStyle[indexPath.row];
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            refreshVC.animationType = AnimationTypeCircle;
            break;
        case 2:
            refreshVC.animationType = AnimationTypeSemiCircle;
            break;
        case 3:
            refreshVC.animationType = AnimationTypePoint;
            break;
        case 4:
            refreshVC.animationType = AnimationTypeStar;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:refreshVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
