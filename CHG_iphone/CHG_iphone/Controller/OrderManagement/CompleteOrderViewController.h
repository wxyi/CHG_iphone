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
@property(nonatomic,strong)NSArray* items;
@property (nonatomic, strong) NSString* strCustId;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
-(IBAction)returnGoods:(UIButton*)sender;
@end
