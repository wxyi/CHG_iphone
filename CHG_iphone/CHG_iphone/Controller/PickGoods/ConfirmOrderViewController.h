//
//  ConfirmOrderViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,assign)SaleType Confirmsaletype;
@property(nonatomic,assign)OrderReturnType returnType;
@property(nonatomic,strong)NSString* strOrderId;
@property(nonatomic,strong)NSString* strfinish;
@property (nonatomic,assign)SkipType skiptype;
@end
