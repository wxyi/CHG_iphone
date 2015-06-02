//
//  StoreSalesMonthViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BaseViewController.h"
#import "StatisticAnalysisTopCell.h"

@interface StoreSalesMonthViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSArray* items;
@property (nonatomic, assign) StatisticalType statisticalType;

@property(nonatomic,strong)NSString* strtitle;
@end
