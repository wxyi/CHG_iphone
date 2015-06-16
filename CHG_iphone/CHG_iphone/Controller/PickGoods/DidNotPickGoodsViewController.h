//
//  DidNotPickGoodsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BaseViewController.h"

@interface DidNotPickGoodsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* Pickupbtn;
@property(nonatomic,weak)IBOutlet UIButton* Terminationbtn;
@property(nonatomic,weak)IBOutlet UIImageView* line;
@property(nonatomic,strong)NSDictionary* items;
@property(nonatomic,strong)STAlertView* stAlertView;
@property (nonatomic, strong) NSString *strOrderId;
@property (nonatomic, assign) CGFloat m_height;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
-(IBAction)orderProcessing:(id)sender;
@end
