//
//  BankCardViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,assign)BOOL isEmpty;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)STAlertView* stAlertView;
-(IBAction)addBankCard:(id)sender;
@end
