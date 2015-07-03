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
@property (retain, nonatomic) LKPageView* page;
@property (retain, nonatomic) NSMutableArray* pagearray;
@property (nonatomic,strong)NSDictionary* AccountBriefDict;
@property (nonatomic,strong)NSMutableArray* menuArr;
@property (nonatomic,strong)UserConfig* config;
@property (nonatomic,assign)NSInteger cellCount;
@end
