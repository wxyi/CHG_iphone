//
//  HomePageViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/21.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPageView.h"
@interface HomePageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property (retain, nonatomic) NSMutableArray* pagearray;

@end