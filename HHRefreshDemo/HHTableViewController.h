//
//  HHTableViewController.h
//  RefreshManager
//
//  Created by 豫风 on 16/11/12.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHRefreshManager.h"

@interface HHTableViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *refreshTableView;

@property (nonatomic, assign) AnimationType animationType;
@property (nonatomic, copy) NSString *navTitle;

@end
