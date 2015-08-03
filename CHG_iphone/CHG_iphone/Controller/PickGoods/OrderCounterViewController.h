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
@property(nonatomic,weak)IBOutlet UIButton* continuebtn;
@property(nonatomic,strong)NSMutableArray* items;
@property(nonatomic,strong)NSDictionary* dict;
@property(nonatomic,strong)NSDictionary* priceDict;
@property(nonatomic,assign)SaleType orderSaletype;
@property(nonatomic,strong)STAlertView* stAlertView;
@property(nonatomic,assign)OrderReturnType m_returnType;
@property(nonatomic,strong)NSDictionary* ChangePriceDict;
@property(nonatomic,strong)NSMutableArray* countitem;

@property(nonatomic,strong)NSMutableDictionary* OrderDate;

@property(nonatomic,assign)BOOL isfrist;
-(IBAction)OrderCounterView:(id)sender;

@end
