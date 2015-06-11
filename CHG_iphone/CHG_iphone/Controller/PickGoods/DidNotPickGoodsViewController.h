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
@property(nonatomic,weak)IBOutlet UIButton* Terminationbtn;//终止订单
@property(nonatomic,weak)IBOutlet UIButton* PickUpbtn;
@property(nonatomic,weak)IBOutlet UIButton* Returnbtn;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)STAlertView* stAlertView;
@property(nonatomic,assign)PickUpType picktype;
-(IBAction)orderProcessing:(id)sender;
@end
