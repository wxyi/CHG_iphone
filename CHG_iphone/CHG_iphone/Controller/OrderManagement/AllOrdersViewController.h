//
//  AllOrdersViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrdersViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSMutableArray* items;
@property(nonatomic,strong)STAlertView* stAlertView;
@property (nonatomic,assign)OrderManagementType ManagementTyep;

@property(nonatomic,assign)NSInteger m_nPageNumber;
@end
