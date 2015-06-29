//
//  StoreSalesYearViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BaseViewController.h"

@interface StoreSalesYearViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UILabel* nameLab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property (nonatomic, assign) StatisticalType statisticalType;
@property(nonatomic,assign)int custCount;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)NSString* strtitle;
@property(nonatomic,assign)NSInteger nbaseData;
@property(nonatomic,strong)NSString* strUrl;
@property (nonatomic, assign) BOOL isSkip;
@property(nonatomic,strong)NSString* strYear;
@end
