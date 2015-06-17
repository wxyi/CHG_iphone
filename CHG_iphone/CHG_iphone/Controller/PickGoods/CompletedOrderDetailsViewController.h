//
//  CompletedOrderDetailsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/11.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedOrderDetailsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* returnBtn;
@property(nonatomic,strong)NSDictionary* items;

@property (nonatomic, strong) NSString *strOrderId;
@property (nonatomic, assign) CGFloat m_height;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
-(IBAction)orderProcessing:(UIButton*)sender;
@end
