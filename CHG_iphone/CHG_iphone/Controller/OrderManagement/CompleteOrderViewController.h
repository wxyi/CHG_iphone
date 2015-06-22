//
//  CompleteOrderViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BaseViewController.h"

@interface CompleteOrderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSMutableArray* items;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
@property(nonatomic,assign)NSInteger m_nPageNumber;
-(IBAction)returnGoods:(UIButton*)sender;
@end
