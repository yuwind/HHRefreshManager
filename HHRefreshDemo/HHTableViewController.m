//
//  HHTableViewController.m
//  RefreshManager
//
//  Created by 豫风 on 16/11/12.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import "HHTableViewController.h"

#define REFRESHTIME 5

@interface HHTableViewController ()<HHRefreshManagerDelegate>

@property (nonatomic, strong) HHRefreshManager *refreshManager;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HHTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.navTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.refreshTableView.tableFooterView = [UIView new];
    
    self.refreshManager = [HHRefreshManager refreshWithDelegate:self scrollView:self.refreshTableView type:self.animationType];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行Cell",indexPath.row];
    return cell;
}

- (void)beginRefreshWithType:(HHRefreshType)type
{
    [self sendNetRequestType:type];
}

- (void)sendNetRequestType:(HHRefreshType)type
{
    if (type == HHRefreshTypeHeader) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REFRESHTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshManager endRefreshWithType:type];
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REFRESHTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshManager endRefreshWithType:type];
        });
    }
}


- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc
{
    NSLog(@"HHTableViewController");
}

@end
