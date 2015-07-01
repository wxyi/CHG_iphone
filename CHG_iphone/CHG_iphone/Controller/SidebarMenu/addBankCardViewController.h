//
//  addBankCardViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/5.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addBankCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)BanKCode* bank;
@property(nonatomic,strong)UITableView* banktableview;
@property(nonatomic,strong)NSMutableArray* bankitems;
@end
