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
@property(nonatomic,weak)IBOutlet UILabel* nameLab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,assign)int custCount;
@property (nonatomic, assign) BOOL isSkip;
@property(nonatomic,assign)NSInteger nbaseData;
@property (nonatomic, assign) StatisticalType statisticalType;

@property(nonatomic,strong)NSString* strtitle;
@property(nonatomic,strong)NSString* strUrl;

@property(nonatomic,strong)NSString* strYear;
@property(nonatomic,strong)NSString* strMonth;
@end
