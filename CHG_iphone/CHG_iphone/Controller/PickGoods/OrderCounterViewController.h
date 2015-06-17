//
//  OrderCounterViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCounterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* button;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)NSDictionary* dict;
@property(nonatomic,strong)NSDictionary* priceDict;
@property(nonatomic,assign)SaleType orderSaletype;
@property(nonatomic,strong)STAlertView* stAlertView;
-(IBAction)OrderCounterView:(id)sender;

@end
