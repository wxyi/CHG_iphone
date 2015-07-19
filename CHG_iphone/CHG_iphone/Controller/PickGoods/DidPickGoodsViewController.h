//
//  DidPickGoodsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BaseViewController.h"

@interface DidPickGoodsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* returnbtn;
@property(nonatomic,weak)IBOutlet UIImageView* line;
@property (nonatomic, strong) NSString *strOrderId;
@property(nonatomic,strong)NSDictionary* items;
@property (nonatomic, assign) CGFloat m_height;
@property (nonatomic,assign)CGFloat quantity;
@property (nonatomic,assign)CGFloat pickQuantity;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
-(IBAction)orderProcessing:(UIButton*)sender;

@end
