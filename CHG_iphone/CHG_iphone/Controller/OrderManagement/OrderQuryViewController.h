//
//  OrderQuryViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDatePicker.h"
@interface OrderQuryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)UUDatePicker *startdatePicker;
@property(nonatomic,strong)UUDatePicker *enddatePicker;
@end
